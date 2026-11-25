"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.resetIcon = exports.getIcon = exports.changeIcon = void 0;
var _NativeChangeIcon = _interopRequireDefault(require("./specs/v1/NativeChangeIcon"));
function _interopRequireDefault(e) { return e && e.__esModule ? e : { default: e }; }
const changeIcon = iconName => (_NativeChangeIcon.default === null || _NativeChangeIcon.default === void 0 ? void 0 : _NativeChangeIcon.default.changeIcon(iconName)) ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
exports.changeIcon = changeIcon;
const resetIcon = () => (_NativeChangeIcon.default === null || _NativeChangeIcon.default === void 0 ? void 0 : _NativeChangeIcon.default.resetIcon()) ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
exports.resetIcon = resetIcon;
const getIcon = () => (_NativeChangeIcon.default === null || _NativeChangeIcon.default === void 0 ? void 0 : _NativeChangeIcon.default.getIcon()) ?? Promise.reject(new Error('TurboModule ChangeIcon not available'));
exports.getIcon = getIcon;
//# sourceMappingURL=index.js.map