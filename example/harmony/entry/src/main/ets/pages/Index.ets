/**
 * This source code is licensed under the MIT license found in the
 * LICENSE-MIT file in the root directory of this source tree.
 */

import {
  AnyJSBundleProvider,
  ComponentBuilderContext,
  FileJSBundleProvider,
  MetroJSBundleProvider,
  ResourceJSBundleProvider,
  RNApp,
  RNOHErrorDialog,
  RNOHLogger,
  TraceJSBundleProviderDecorator,
  RNOHCoreContext
} from '@rnoh/react-native-openharmony';
import { createRNPackages } from '../RNPackagesFactory';
import { commentManager } from '@kit.AppGalleryKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common, OpenLinkOptions } from '@kit.AbilityKit';
// GEN:FABRIC_IMPORTS_BEGIN
// GEN:FABRIC_IMPORTS_END

// GEN:FABRIC_ARK_CONST_BEGIN
// GEN:FABRIC_ARK_CONST_END

@Builder
export function buildCustomRNComponent(ctx: ComponentBuilderContext) {
// GEN:FABRIC_BUILDER_BODY_BEGIN

// GEN:FABRIC_BUILDER_BODY_END
}

const wrappedCustomRNComponentBuilder = wrapBuilder(buildCustomRNComponent)

const COMMENT_SYSCAP: string = 'SystemCapability.AppGalleryService.Distribution.Comment';
const COMMENT_LOG_DOMAIN: number = 0x0001;
const COMMENT_LOG_TAG: string = 'IndexComment';

@Entry
@Component
struct Index {
  @StorageLink('RNOHCoreContext') private rnohCoreContext: RNOHCoreContext | undefined = undefined
  @State shouldShow: boolean = false
  @State commentStatus: string = ''
  private logger!: RNOHLogger

  aboutToAppear() {
    this.logger = this.rnohCoreContext!.logger.clone("Index")
    const stopTracing = this.logger.clone("aboutToAppear").startTracing();

    this.shouldShow = true
    stopTracing();
  }

  onBackPress(): boolean | undefined {
    // NOTE: this is required since `Ability`'s `onBackPressed` function always
    // terminates or puts the app in the background, but we want Ark to ignore it completely
    // when handled by RN
    this.rnohCoreContext!.dispatchBackPress()
    return true
  }

  private getAbilityContext(): common.UIAbilityContext | undefined {
    const hostContext = this.getUIContext().getHostContext();
    if (hostContext) {
      return hostContext as common.UIAbilityContext;
    }
    if (this.rnohCoreContext) {
      return this.rnohCoreContext.uiAbilityContext;
    }
    return undefined;
  }

  private showInAppComment(): void {
    const context = this.getAbilityContext();
    if (!context) {
      this.commentStatus = '无法获取 UIAbilityContext';
      return;
    }
    if (!canIUse(COMMENT_SYSCAP)) {
      this.commentStatus = '当前系统不支持应用内评论弹窗（需 6.0.0(20)+）';
      return;
    }
    try {
      commentManager.showCommentDialog(context).then(() => {
        this.commentStatus = '已拉起应用内评论弹窗';
        hilog.info(COMMENT_LOG_DOMAIN, COMMENT_LOG_TAG, 'succeeded in showing commentDialog.');
      }).catch((error: BusinessError) => {
        this.commentStatus = `评论弹窗失败 ${error.code}: ${error.message}`;
        hilog.error(COMMENT_LOG_DOMAIN, COMMENT_LOG_TAG,
          `showCommentDialog failed, Code: ${error.code}, message: ${error.message}`);
      });
    } catch (error) {
      const err = error as BusinessError;
      this.commentStatus = `评论弹窗失败 ${err.code}: ${err.message}`;
      hilog.error(COMMENT_LOG_DOMAIN, COMMENT_LOG_TAG,
        `showCommentDialog failed, Code: ${err.code}, message: ${err.message}`);
    }
  }

  private openCommentByAppLinking(): void {
    const context = this.getAbilityContext();
    if (!context) {
      this.commentStatus = '无法获取 UIAbilityContext';
      return;
    }
    const bundleName: string = context.abilityInfo.bundleName;
    const link: string = 'https://appgallery.huawei.com/app/detail?id=' + bundleName + '&action=write-review';
    const openLinkOptions: OpenLinkOptions = {
      appLinkingOnly: false
    };
    try {
      context.openLink(link, openLinkOptions).then(() => {
        this.commentStatus = '已通过 App Linking 拉起评论页';
        hilog.info(COMMENT_LOG_DOMAIN, COMMENT_LOG_TAG, 'openlink success. link=' + link);
      }).catch((error: BusinessError) => {
        this.commentStatus = `App Linking 失败 ${error.code}: ${error.message}`;
        hilog.error(COMMENT_LOG_DOMAIN, COMMENT_LOG_TAG,
          `openlink failed. Code: ${error.code}, message is ${error.message}`);
      });
    } catch (error) {
      const err = error as BusinessError;
      this.commentStatus = `App Linking 失败 ${err.code}: ${err.message}`;
      hilog.error(COMMENT_LOG_DOMAIN, COMMENT_LOG_TAG,
        `openlink failed. Code: ${err.code}, message is ${err.message}`);
    }
  }

  build() {
    Column() {
      // 应用内评论弹窗 / App Linking 评论页按钮已验证，先注释，恢复 changeIcon 功能测试页。
      // Column() {
      //   Row() {
      //     Button('应用内评论弹窗')
      //       .layoutWeight(1)
      //       .height(36)
      //       .fontSize(13)
      //       .onClick(() => {
      //         this.showInAppComment();
      //       })
      //     Button('App Linking 评论页')
      //       .layoutWeight(1)
      //       .height(36)
      //       .fontSize(13)
      //       .margin({ left: 8 })
      //       .onClick(() => {
      //         this.openCommentByAppLinking();
      //       })
      //   }
      //   .width('100%')
      //
      //   if (this.commentStatus.length > 0) {
      //     Text(this.commentStatus)
      //       .fontSize(12)
      //       .fontColor('#666666')
      //       .margin({ top: 6 })
      //       .width('100%')
      //   }
      // }
      // .width('100%')
      // .padding(8)
      // .backgroundColor('#F2F3F5')

      if (this.rnohCoreContext && this.shouldShow) {
        if (this.rnohCoreContext?.isDebugModeEnabled) {
          RNOHErrorDialog({ ctx: this.rnohCoreContext })
        }
        RNApp({
          rnInstanceConfig: {
            createRNPackages,
            enableNDKTextMeasuring: true,
            enableBackgroundExecutor: false,
            enableCAPIArchitecture: true,
            arkTsComponentNames: []
          },
          initialProps: { "foo": "bar" } as Record<string, string>,
          appKey: "AwesomeProject",
          wrappedCustomRNComponentBuilder: wrappedCustomRNComponentBuilder,
          onSetUp: (rnInstance) => {
            rnInstance.enableFeatureFlag("ENABLE_RN_INSTANCE_CLEAN_UP")
          },
          jsBundleProvider: new TraceJSBundleProviderDecorator(
            new AnyJSBundleProvider([
              new MetroJSBundleProvider(),
              // NOTE: to load the bundle from file, place it in
              // `/data/app/el2/100/base/com.rnoh.tester/files/bundle.harmony.js`
              // on your device. The path mismatch is due to app sandboxing on OpenHarmony
              new FileJSBundleProvider('/data/storage/el2/base/files/bundle.harmony.js'),
              new ResourceJSBundleProvider(this.rnohCoreContext.uiAbilityContext.resourceManager, 'hermes_bundle.hbc'),
              new ResourceJSBundleProvider(this.rnohCoreContext.uiAbilityContext.resourceManager, 'bundle.harmony.js')
            ]),
            this.rnohCoreContext.logger),
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}
