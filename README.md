> 文档模板：v0.4.2

<p align="center">
  <h1 align="center"> <code>react-native-change-icon</code> </h1>
</p>

本项目基于 [react-native-change-icon](https://github.com/skb1129/react-native-change-icon) 开发。

版本所属关系如下：

| 三方库名称 | 三方库版本（npm地址） | 发布信息 | 支持RN版本 | Autolink | 编译API版本 | 社区基线版本 | 源码地址 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| @react-native-ohos/react-native-change-icon | [~ 1.0.0](https://www.npmjs.com/package/@react-native-ohos/react-native-change-icon) | [Gitcode Releases](https://gitcode.com/xdxs/rntpc_react-native-change-icon/releases) | 0.72.* / 0.77.* / 0.82.* / 0.84.* / 0.86.* | 是 | API12+ | 5.0.0 | [main](https://gitcode.com/xdxs/rntpc_react-native-change-icon) |

## 简介

在 React Native 中切换应用桌面图标。<br/>
OpenHarmony 上通过 AppGallery Kit 的 `appInfoManager` 切换云端动态图标。`changeIcon() 接口` 的参数是 AppGallery Connect 中的动态图标 ID，不是本地资源名。

## 下载安装

进入到工程目录并输入以下命令：

**npm**

```bash
npm install @react-native-ohos/react-native-change-icon
```

**yarn**

```bash
yarn add @react-native-ohos/react-native-change-icon
```

## Link

| 版本 | 是否支持Autolink | RN框架版本 |
| --- | --- | --- |
| ~ 1.0.0 | 是 | 0.72 / 0.77 / 0.82 / 0.84 / 0.86 |

使用 Autolink 的工程需要根据该文档配置，Autolink 框架指导文档：https://atomgit.com/CPF-RN/ohos_react_native/blob/master/docs/zh-cn/Autolinking.md

如您使用的版本支持 Autolink，并且工程已接入 Autolink，可跳过 ManualLink 配置。

<details>
  <summary>ManualLink: 此步骤为手动配置原生依赖项的指导</summary>

首先需要使用 DevEco Studio 打开项目里的 OpenHarmony 工程 `harmony`。

### 1. Overrides RN SDK

为了让工程依赖同一个版本的 RN SDK，需要在工程根目录的 `oh-package.json5` 添加 overrides 字段，指向工程需要使用的 RN SDK 版本。

关于该字段的作用请阅读[官方说明](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-oh-package-json5-V5#zh-cn_topic_0000001792256137_overrides)。

```json
{
  "overrides": {
    "@rnoh/react-native-openharmony": "file:../node_modules/@react-native-oh/react-native-harmony/react_native_openharmony.har"
  }
}
```

### 2. 引入原生端代码

目前有两种方法：

- 通过 har 包引入。
- 直接链接源码。

方法一：通过 har 包引入（推荐）

> [!TIP] har 包位于三方库安装路径的 `harmony` 文件夹下。

打开 `entry/oh-package.json5`，添加以下依赖：

```json
"dependencies": {
  "@react-native-ohos/react-native-change-icon": "file:../../node_modules/@react-native-ohos/react-native-change-icon/harmony/change_icon.har"
}
```

点击右上角的 `sync` 按钮

或者在命令行终端执行：

```bash
cd entry
ohpm install
```

方法二：直接链接源码

> [!TIP] 如需使用直接链接源码，请参考[直接链接源码说明](https://atomgit.com/CPF-RN/usage-docs/blob/master/zh-cn/link-source-code.md)。

### 3. 配置 CMakeLists 和引入 ChangeIconPackage

打开 `entry/src/main/cpp/CMakeLists.txt`，添加：

```diff
+ set(OH_MODULES "${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules")

# RNOH_BEGIN: manual_package_linking_1
+ add_subdirectory("${OH_MODULES}/@react-native-ohos/react-native-change-icon/src/main/cpp" ./change_icon)
# RNOH_END: manual_package_linking_1

# RNOH_BEGIN: manual_package_linking_2
+ target_link_libraries(rnoh_app PUBLIC change_icon)
# RNOH_END: manual_package_linking_2
```

打开 `entry/src/main/cpp/PackageProvider.cpp`，添加：

```diff
#include "RNOH/PackageProvider.h"
+ #include "ChangeIconPackage.h"

std::vector<std::shared_ptr<Package>> PackageProvider::getPackages(Package::Context ctx) {
    return {
+     std::make_shared<ChangeIconPackage>(ctx)
    };
}
```

### 4. 在 ArkTS 侧引入 ChangeIconPackage

打开 `entry/src/main/ets/RNPackagesFactory.ets`，添加：

```diff
+ import ChangeIconPackage from '@react-native-ohos/react-native-change-icon';

export function createRNPackages(ctx: RNPackageContext): RNPackage[] {
  return [
+   new ChangeIconPackage(ctx)
  ];
}
```

</details>

### 运行

点击右上角的 `sync` 按钮

或者在命令行终端执行：

```bash
cd entry
ohpm install
```

然后编译、运行即可。

## 约束与限制

### 兼容性

本文档内容基于以下版本验证通过：

1. RNOH: 0.72.139; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
2. RNOH: 0.77.75; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
3. RNOH: 0.82.31; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
4. RNOH: 0.84.1; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
5. RNOH: 0.86.1; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)

动态图标接口需真机系统 5.0.3(15)+，不支持模拟器。

### 权限要求

无需声明 `ohos.permission`，也无需运行时申请权限。

### 编译运行API要求

> [!TIP] 当前三方库已支持在 `API12+` 工程编译。

> [!TIP] 以下功能依赖特定版本的系统能力。低于指定版本的 ROM 上调用会失败。

1. `changeIcon() 接口`、`resetIcon() 接口`、`getIcon() 接口` 依赖 `SystemCapability.AppGalleryService.AppInfoManager`。该能力从 5.0.3(15) 开始提供。不满足时 Promise reject `HARMONY:NOT_SUPPORTED`。应用须上架并开通图标管理服务。动态图标须在 AppGallery Connect 配置并过审。

## 使用示例

下面的代码展示了这个库的基本使用场景：

> [!WARNING] 使用时 import 的库名不变。

```javascript
import { changeIcon, getIcon, resetIcon } from 'react-native-change-icon';

// iconId 为 AppGallery Connect 中的动态图标 ID
changeIcon('qixi')
  .then((name) => {
    console.log(name);
  })
  .catch((error) => {
    console.warn(error.message);
  });

// Default 表示恢复默认图标
changeIcon('Default').then((name) => {
  console.log(name);
});

getIcon().then((name) => {
  console.log(name);
});

resetIcon()
  .then((name) => {
    console.log(name);
  })
  .catch((error) => {
    console.warn(error.message);
  });
```

## 使用说明

成功时 Promise resolve 当前图标名。默认图标名为 `Default`。失败时 reject，`message` 为错误码。

`changeIcon() 接口` 不传参数、传入空字符串或传入 `Default` 时，效果与 `resetIcon() 接口` 相同。其他字符串必须是已配置的动态图标 ID。

切换成功后由系统刷新桌面图标，不需要重启应用。

| 错误码 | 含义 |
| --- | --- |
| `HARMONY:NOT_SUPPORTED` | 设备不支持 `SystemCapability.AppGalleryService.AppInfoManager` |
| `HARMONY:ICON_ALREADY_USED:<id>` | 目标动态图标已是当前图标 |
| `HARMONY:ICON_INVALID:<id>` | 动态图标列表中没有该 ID |
| `HARMONY:AGC_<code>:<message>` | AppGallery Kit 错误透传。已是默认图标时再次恢复，常见码为 `1006800012` |
| `TurboModule ChangeIcon not available` | 原生 TurboModule 未链接 |

`getIcon() 接口` 在服务返回「无动态图标数据」（错误码 `1006800010`）时 resolve `Default`。

TurboModule Spec 中的 `getConstants() 接口` 返回空对象，JS 入口未再导出。

## 接口说明

> [!TIP] "平台"列表示该属性在原三方库上支持的平台。

> [!TIP] "OpenHarmony平台支持"列为 "是" 表示 OpenHarmony 平台支持该属性；"否" 则表示不支持；partially 表示部分支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果。

### API

| 名称 | 类型 | 参数类型 | 返回值 | 必填 | 平台 | OpenHarmony平台支持 | 描述 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| changeIcon | function | iconName?: string | Promise\<string\> | 否 | All | 是 | 切换动态图标。`iconName` 为动态图标 ID。空参数、空字符串或 `Default` 时恢复默认图标。 |
| resetIcon | function | / | Promise\<string\> | 否 | All | 是 | 恢复默认图标。成功 resolve `Default`。已是默认图标时 reject `HARMONY:AGC_1006800012`。 |
| getIcon | function | / | Promise\<string\> | 否 | All | 是 | 查询当前动态图标 ID。当前为默认图标或无动态图标数据时 resolve `Default`。 |

## 遗留问题

无

## 其他

无

## 目录结构

```
/rntpc_react-native-change-icon          # 项目根目录
├── harmony/                             # 鸿蒙适配代码
│   ├── change_icon.har                  # HAR 包
│   └── change_icon/                     # 鸿蒙模块源码
│       ├── index.ets                    # 模块入口
│       ├── oh-package.json5
│       └── src/main/
│           ├── ets/                     # ArkTS 实现
│           │   ├── ChangeIconPackage.ets
│           │   ├── ChangeIconTurboModule.ets
│           │   └── generated/           # Codegen 产物
│           └── cpp/                     # C++ 桥接
│               ├── CMakeLists.txt
│               ├── ChangeIconPackage.h
│               └── generated/           # Codegen 产物
├── src/                                 # RN JS / Spec
│   ├── index.ts                         # JS 入口
│   └── specs/v1/NativeChangeIcon.ts     # TurboModule Spec
├── example/                             # 门禁 example
├── package.json
├── README.md
├── README_EN.md
├── CHANGELOG.md
├── COMMITTERS.md
├── README.OpenSource
└── LICENSE
```

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue](https://gitcode.com/xdxs/rntpc_react-native-change-icon/issues)，当然，也非常欢迎提交 [PR](https://gitcode.com/xdxs/rntpc_react-native-change-icon/pulls)。

## 开源协议

本项目基于 [The MIT License (MIT)](https://github.com/skb1129/react-native-change-icon/blob/master/LICENSE)，请自由地享受和参与开源。
