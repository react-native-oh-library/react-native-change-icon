/**
 * react-native-change-icon JS 封装白盒用例。
 * 覆盖 changeIcon / resetIcon / getIcon 对 TurboModule 的转发，以及模块缺失时的拒绝。
 */

const NOT_AVAILABLE = 'TurboModule ChangeIcon not available';

function createNative() {
  return {
    changeIcon: jest.fn(async iconName => {
      if (iconName === undefined || iconName === null || iconName === '' || iconName === 'Default') {
        return 'Default';
      }
      return iconName;
    }),
    resetIcon: jest.fn(async () => 'Default'),
    getIcon: jest.fn(async () => 'qixi'),
    getConstants: jest.fn(() => ({})),
  };
}

function loadApi(native) {
  global.__CHANGE_ICON_XTS__ = { native, lastName: undefined };
  jest.resetModules();
  return require('../../src/index.ts');
}

describe('ChangeIconTurboModuleRegistry', () => {
  test('loads ChangeIcon from TurboModuleRegistry', () => {
    loadApi(createNative());
    expect(global.__CHANGE_ICON_XTS__.lastName).toBe('ChangeIcon');
  });
});

describe('changeIcon', () => {
  test('forwards an AGC icon id and resolves that id', async () => {
    const native = createNative();
    const api = loadApi(native);

    await expect(api.changeIcon('qixi')).resolves.toBe('qixi');
    expect(native.changeIcon).toHaveBeenCalledTimes(1);
    expect(native.changeIcon).toHaveBeenCalledWith('qixi');
  });

  test('forwards spring_festival icon id', async () => {
    const native = createNative();
    const api = loadApi(native);

    await expect(api.changeIcon('spring_festival')).resolves.toBe('spring_festival');
    expect(native.changeIcon).toHaveBeenCalledWith('spring_festival');
  });

  test('forwards omitted, empty and Default names to the native module', async () => {
    const native = createNative();
    const api = loadApi(native);

    await expect(api.changeIcon()).resolves.toBe('Default');
    await expect(api.changeIcon('')).resolves.toBe('Default');
    await expect(api.changeIcon('Default')).resolves.toBe('Default');
    expect(native.changeIcon).toHaveBeenNthCalledWith(1, undefined);
    expect(native.changeIcon).toHaveBeenNthCalledWith(2, '');
    expect(native.changeIcon).toHaveBeenNthCalledWith(3, 'Default');
  });

  test('rejects when the TurboModule is unavailable', async () => {
    const api = loadApi(null);
    await expect(api.changeIcon('qixi')).rejects.toThrow(NOT_AVAILABLE);
  });

  test('propagates native icon errors', async () => {
    const native = createNative();
    native.changeIcon
      .mockRejectedValueOnce(new Error('HARMONY:ICON_INVALID:missing'))
      .mockRejectedValueOnce(new Error('HARMONY:ICON_ALREADY_USED:qixi'))
      .mockRejectedValueOnce(new Error('HARMONY:NOT_SUPPORTED'))
      .mockRejectedValueOnce(new Error('HARMONY:AGC_1006800010:no dynamic icon'));
    const api = loadApi(native);

    await expect(api.changeIcon('missing')).rejects.toThrow('HARMONY:ICON_INVALID:missing');
    await expect(api.changeIcon('qixi')).rejects.toThrow('HARMONY:ICON_ALREADY_USED:qixi');
    await expect(api.changeIcon('qixi')).rejects.toThrow('HARMONY:NOT_SUPPORTED');
    await expect(api.changeIcon('qixi')).rejects.toThrow('HARMONY:AGC_1006800010:no dynamic icon');
  });
});

describe('resetIcon', () => {
  test('forwards to the native module and resolves Default', async () => {
    const native = createNative();
    const api = loadApi(native);

    await expect(api.resetIcon()).resolves.toBe('Default');
    expect(native.resetIcon).toHaveBeenCalledTimes(1);
  });

  test('rejects when the TurboModule is unavailable', async () => {
    const api = loadApi(null);
    await expect(api.resetIcon()).rejects.toThrow(NOT_AVAILABLE);
  });

  test('propagates native reset errors', async () => {
    const native = createNative();
    native.resetIcon.mockRejectedValueOnce(new Error('HARMONY:NOT_SUPPORTED'));
    const api = loadApi(native);

    await expect(api.resetIcon()).rejects.toThrow('HARMONY:NOT_SUPPORTED');
  });
});

describe('getIcon', () => {
  test('forwards to the native module and resolves the current icon', async () => {
    const native = createNative();
    const api = loadApi(native);

    await expect(api.getIcon()).resolves.toBe('qixi');
    expect(native.getIcon).toHaveBeenCalledTimes(1);
  });

  test('resolves Default when the native module reports the default icon', async () => {
    const native = createNative();
    native.getIcon.mockResolvedValueOnce('Default');
    const api = loadApi(native);

    await expect(api.getIcon()).resolves.toBe('Default');
  });

  test('rejects when the TurboModule is unavailable', async () => {
    const api = loadApi(null);
    await expect(api.getIcon()).rejects.toThrow(NOT_AVAILABLE);
  });

  test('propagates native query errors', async () => {
    const native = createNative();
    native.getIcon.mockRejectedValueOnce(new Error('HARMONY:AGC_1006800001:query failed'));
    const api = loadApi(native);

    await expect(api.getIcon()).rejects.toThrow('HARMONY:AGC_1006800001:query failed');
  });
});
