import NativeChangeIcon from './specs/v1/NativeChangeIcon';

export const changeIcon = (iconName?: string): Promise<string> =>
  NativeChangeIcon?.changeIcon(iconName) ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
export const resetIcon = (): Promise<string> =>
  NativeChangeIcon?.resetIcon() ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
export const getIcon = (): Promise<string> =>
  NativeChangeIcon?.getIcon() ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
