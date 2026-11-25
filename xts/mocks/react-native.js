/**
 * 被测源码在加载时调用 TurboModuleRegistry.get('ChangeIcon')。
 * 用例通过 global.__CHANGE_ICON_XTS__.native 决定返回 mock 还是 null。
 */
function getState() {
  if (!global.__CHANGE_ICON_XTS__) {
    global.__CHANGE_ICON_XTS__ = { native: null, lastName: undefined };
  }
  return global.__CHANGE_ICON_XTS__;
}

const TurboModuleRegistry = {
  get(name) {
    const state = getState();
    state.lastName = name;
    return state.native;
  },
};

module.exports = {
  TurboModuleRegistry,
};
