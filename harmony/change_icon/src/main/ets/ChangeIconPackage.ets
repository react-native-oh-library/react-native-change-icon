/**
 * react-native-change-icon HarmonyOS RNPackage 工厂。
 * 注册 ChangeIcon TurboModule（名称与 JS 侧 TurboModuleRegistry.get('ChangeIcon') 一致）。
 */
import {
  RNOHPackage,
  UITurboModule,
  UITurboModuleContext,
} from '@rnoh/react-native-openharmony';
import { ChangeIconTurboModule } from './ChangeIconTurboModule';

export class ChangeIconPackage extends RNOHPackage {
  override getUITurboModuleFactoryByNameMap(): Map<string, (ctx: UITurboModuleContext) => UITurboModule | null> {
    return new Map<string, ((ctx: UITurboModuleContext) => UITurboModule)>()
      .set(ChangeIconTurboModule.NAME, (ctx: UITurboModuleContext) => new ChangeIconTurboModule(ctx));
  }
}
