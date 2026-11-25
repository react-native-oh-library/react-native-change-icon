import NativeChangeIcon from './specs/v1/NativeChangeIcon';
export const changeIcon = iconName => (NativeChangeIcon === null || NativeChangeIcon === void 0 ? void 0 : NativeChangeIcon.changeIcon(iconName)) ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
export const resetIcon = () => (NativeChangeIcon === null || NativeChangeIcon === void 0 ? void 0 : NativeChangeIcon.resetIcon()) ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
export const getIcon = () => (NativeChangeIcon === null || NativeChangeIcon === void 0 ? void 0 : NativeChangeIcon.getIcon()) ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
//# sourceMappingURL=index.js.map