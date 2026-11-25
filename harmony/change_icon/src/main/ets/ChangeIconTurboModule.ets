/**
 * react-native-change-icon HarmonyOS (OpenHarmony) TurboModule 实现。
 *
 * HarmonyOS 上应用内动态切换桌面图标的官方唯一途径是 AppGallery Kit 图标管理服务
 * （appInfoManager）：图标由云端下发，需应用正式上架、向华为邮件申请开通服务，
 * 且动态图标已在 AppGallery Connect「分发 > 服务 > 图标管理」配置并过审；
 * 接口起始版本 5.0.3(15)，不支持模拟器。
 *
 * 与原库（Android activity-alias / iOS CFBundleAlternateIcons）的语义映射：
 * - changeIcon(iconName)：iconName 为空或 'Default' 时恢复默认图标，其余值为
 *   AGC 配置的动态图标 ID（iconId），成功后 resolve 生效图标名；
 * - resetIcon()：恢复默认图标，成功 resolve 'Default'；
 * - getIcon()：resolve 当前启用的动态图标 ID，为默认图标时 resolve 'Default'。
 * 换图标由系统刷新桌面图标，无需重启应用（与 Android 端 finish Activity 不同）。
 *
 * reject 错误码（对齐原库「成功 resolve 图标名 / 失败 reject 字符串码」契约）：
 * - HARMONY:NOT_SUPPORTED          设备不支持 SystemCapability.AppGalleryService.AppInfoManager
 * - HARMONY:ICON_ALREADY_USED:<id> 目标图标已是当前启用图标（对齐 ANDROID/IOS:ICON_ALREADY_USED）
 * - HARMONY:ICON_INVALID:<id>      AGC 未配置该图标 ID，不在动态图标列表中（对齐 ANDROID:ICON_INVALID）
 * - HARMONY:AGC_<code>:<message>   appInfoManager 错误透传（如 1006800010 无动态图标信息）
 */
import { EtsUITurboModule } from '@rnoh/react-native-openharmony/ets';
import { appInfoManager } from '@kit.AppGalleryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { TM } from './generated/ts';

const DEFAULT_ICON_NAME: string = 'Default';
const SYSCAP_APP_INFO_MANAGER: string = 'SystemCapability.AppGalleryService.AppInfoManager';
const ERR_NOT_SUPPORTED: string = 'HARMONY:NOT_SUPPORTED';
const AGC_ERR_NO_DYNAMIC_ICON_DATA: number = 1006800010;

export class ChangeIconTurboModule extends EtsUITurboModule implements TM.ChangeIcon.Spec {
  public static readonly NAME = TM.ChangeIcon.NAME;

  getConstants(): Record<string, Object> {
    return {};
  }

  changeIcon(iconName?: string): Promise<string> {
    if (!this.isAppInfoManagerSupported()) {
      return Promise.reject(new Error(ERR_NOT_SUPPORTED));
    }
    const hasTarget: boolean = iconName !== undefined && iconName !== null &&
      iconName.length > 0 && iconName !== DEFAULT_ICON_NAME;
    if (!hasTarget) {
      return this.disableDynamicIcon();
    }
    return this.selectDynamicIcon(iconName as string);
  }

  resetIcon(): Promise<string> {
    if (!this.isAppInfoManagerSupported()) {
      return Promise.reject(new Error(ERR_NOT_SUPPORTED));
    }
    return this.disableDynamicIcon();
  }

  getIcon(): Promise<string> {
    if (!this.isAppInfoManagerSupported()) {
      return Promise.reject(new Error(ERR_NOT_SUPPORTED));
    }
    return this.queryCurrentIcon();
  }

  private isAppInfoManagerSupported(): boolean {
    return canIUse(SYSCAP_APP_INFO_MANAGER);
  }

  /**
   * 恢复默认图标；成功 resolve 'Default'。
   * 已是默认图标时 AGC 返回 1006800012，按 HARMONY:AGC_1006800012 透传 reject，
   * 对齐原库 IOS:ICON_ALREADY_USED / ANDROID:ICON_ALREADY_USED 的短路拒绝语义。
   */
  private async disableDynamicIcon(): Promise<string> {
    try {
      await appInfoManager.disableDynamicIcon();
      return DEFAULT_ICON_NAME;
    } catch (e) {
      throw this.toAgcError(e as BusinessError, 'disableDynamicIcon');
    }
  }

  /**
   * 切换到指定动态图标；成功 resolve 图标 ID。
   * 先查询动态图标列表做前置校验（对齐原库错误语义）：
   * 已是当前图标 → HARMONY:ICON_ALREADY_USED；列表中不存在 → HARMONY:ICON_INVALID。
   */
  private async selectDynamicIcon(iconId: string): Promise<string> {
    let icons: appInfoManager.DynamicIconInfo[];
    try {
      icons = await appInfoManager.queryDynamicIcons();
    } catch (e) {
      throw this.toAgcError(e as BusinessError, 'queryDynamicIcons');
    }
    let isConfigured = false;
    for (const info of icons) {
      if (info.iconId === iconId) {
        if (info.enabled) {
          throw new Error(`HARMONY:ICON_ALREADY_USED:${iconId}`);
        }
        isConfigured = true;
        break;
      }
    }
    if (!isConfigured) {
      throw new Error(`HARMONY:ICON_INVALID:${iconId}`);
    }
    try {
      await appInfoManager.selectDynamicIcon(iconId);
      return iconId;
    } catch (e) {
      throw this.toAgcError(e as BusinessError, 'selectDynamicIcon');
    }
  }

  /**
   * 查询当前启用图标；为默认图标时 resolve 'Default'。
   * AGC 返回 1006800010（无动态图标数据）时图标必然为默认图标，resolve 'Default'。
   */
  private async queryCurrentIcon(): Promise<string> {
    let icons: appInfoManager.DynamicIconInfo[];
    try {
      icons = await appInfoManager.queryDynamicIcons();
    } catch (e) {
      const err: BusinessError = e as BusinessError;
      if (err.code === AGC_ERR_NO_DYNAMIC_ICON_DATA) {
        return DEFAULT_ICON_NAME;
      }
      throw this.toAgcError(err, 'queryDynamicIcons');
    }
    for (const info of icons) {
      if (info.enabled) {
        return info.iconId;
      }
    }
    return DEFAULT_ICON_NAME;
  }

  private toAgcError(err: BusinessError, api: string): Error {
    const message: string = err.message ?? 'unknown BusinessError';
    this.ctx.logger.error(`ChangeIcon.${api} failed, code: ${err.code}, message: ${message}`);
    return new Error(`HARMONY:AGC_${err.code}:${message}`);
  }
}
