> Document Template: v0.4.2

<p align="center">
  <h1 align="center"> <code>react-native-change-icon</code> </h1>
</p>

This project is based on [react-native-change-icon](https://github.com/skb1129/react-native-change-icon).

The version correspondence details are as follows:

| Name | Version(Npm Address) | Release Information | Supported RN Version | Supported Autolink | Compile API Version | Community Baseline Version | Source code address |
| --- | --- | --- | --- | --- | --- | --- | --- |
| @react-native-ohos/react-native-change-icon | [~ 1.0.0](https://www.npmjs.com/package/@react-native-ohos/react-native-change-icon) | [Gitcode Releases](https://gitcode.com/xdxs/rntpc_react-native-change-icon/releases) | 0.72.* / 0.77.* / 0.82.* / 0.84.* / 0.86.* | Yes | API12+ | 5.0.0 | [main](https://gitcode.com/xdxs/rntpc_react-native-change-icon) |

## Introduction

Change the application icon in React Native.<br/>
On OpenHarmony, the library switches cloud dynamic icons through AppGallery Kit `appInfoManager`. The argument of `changeIcon()` is an AppGallery Connect icon ID, not a local resource name.

## Installation

Go to the project directory and execute the following instruction:

**npm**

```bash
npm install @react-native-ohos/react-native-change-icon
```

**yarn**

```bash
yarn add @react-native-ohos/react-native-change-icon
```

## Link

| Version | Supported Autolink | Supported RN Version |
| --- | --- | --- |
| ~ 1.0.0 | Yes | 0.72 / 0.77 / 0.82 / 0.84 / 0.86 |

Projects using Autolink need to be configured according to this document, Autolink framework guide: https://atomgit.com/CPF-RN/ohos_react_native/blob/main/docs/en/02-development/02-development-guide/autolinking.md

If the version you are using supports Autolink and the project has integrated Autolink, you can skip the ManualLink configuration.

<details>
  <summary>ManualLink: This step provides guidance for manually configuring native dependencies.</summary>

Open the `harmony` directory of the OpenHarmony project in DevEco Studio.

### 1. Overrides RN SDK

Add an `overrides` field to the project root `oh-package.json5` so the project uses one React Native SDK.

For more information about this field, please refer to the [official documentation](https://developer.huawei.com/consumer/en/doc/harmonyos-guides-V5/ide-oh-package-json5-V5#en-us_topic_0000001792256137_overrides).

```json
{
  "overrides": {
    "@rnoh/react-native-openharmony": "file:../node_modules/@react-native-oh/react-native-harmony/react_native_openharmony.har"
  }
}
```

### 2. Introducing Native Code

Currently, two methods are available:

- Use the HAR file.
- Directly link to the source code.

Method 1 (recommended): Use the HAR file.

> [!TIP] The HAR file is stored in the `harmony` directory in the installation path of the third-party library.

Open `entry/oh-package.json5` and add the following dependency:

```json
"dependencies": {
  "@react-native-ohos/react-native-change-icon": "file:../../node_modules/@react-native-ohos/react-native-change-icon/harmony/change_icon.har"
}
```

Click the `sync` button in the upper right corner.

Alternatively, run the following instruction on the terminal:

```bash
cd entry
ohpm install
```

Method 2: Directly link to the source code.

> [!TIP] To link the source code directly, see [Linking Source Code](https://atomgit.com/CPF-RN/usage-docs/blob/master/en/link-source-code.md).

### 3. Configuring CMakeLists and Introducing ChangeIconPackage

Open `entry/src/main/cpp/CMakeLists.txt` and add:

```diff
+ set(OH_MODULES "${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules")

# RNOH_BEGIN: manual_package_linking_1
+ add_subdirectory("${OH_MODULES}/@react-native-ohos/react-native-change-icon/src/main/cpp" ./change_icon)
# RNOH_END: manual_package_linking_1

# RNOH_BEGIN: manual_package_linking_2
+ target_link_libraries(rnoh_app PUBLIC change_icon)
# RNOH_END: manual_package_linking_2
```

Open `entry/src/main/cpp/PackageProvider.cpp` and add:

```diff
#include "RNOH/PackageProvider.h"
+ #include "ChangeIconPackage.h"

std::vector<std::shared_ptr<Package>> PackageProvider::getPackages(Package::Context ctx) {
    return {
+     std::make_shared<ChangeIconPackage>(ctx)
    };
}
```

### 4. Introducing ChangeIconPackage to ArkTS

Open `entry/src/main/ets/RNPackagesFactory.ets` and add:

```diff
+ import ChangeIconPackage from '@react-native-ohos/react-native-change-icon';

export function createRNPackages(ctx: RNPackageContext): RNPackage[] {
  return [
+   new ChangeIconPackage(ctx)
  ];
}
```

</details>

### Running

Click the `sync` button in the upper right corner, or run:

```bash
cd entry
ohpm install
```

Then build and run the code.

## Constraints

### Compatibility

This document is verified based on the following versions:

1. RNOH: 0.72.139; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
2. RNOH: 0.77.75; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
3. RNOH: 0.82.31; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
4. RNOH: 0.84.1; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)
5. RNOH: 0.86.1; SDK: HarmonyOS compatible 5.0.1(13) / target 6.0.1(21)

The dynamic icon APIs require a real device on 5.0.3(15) or later. They are not supported on the simulator.

### Permission Requirements

No `ohos.permission` declaration and no runtime permission request are required.

### API requirements

> [!TIP] This library can be compiled in `API12+` projects.

> [!TIP] The following behavior depends on a specific system capability. Calls on an older ROM fail.

1. `changeIcon()`, `resetIcon()`, and `getIcon()` depend on `SystemCapability.AppGalleryService.AppInfoManager`, available since 5.0.3(15). Otherwise the Promise rejects with `HARMONY:NOT_SUPPORTED`. The app must be released and icon management must be enabled. Dynamic icons must be configured and approved in AppGallery Connect.

## Example

The following code shows the basic usage of this library:

> [!WARNING] The import name stays unchanged.

```javascript
import { changeIcon, getIcon, resetIcon } from 'react-native-change-icon';

// iconId is the dynamic icon ID in AppGallery Connect
changeIcon('qixi')
  .then((name) => {
    console.log(name);
  })
  .catch((error) => {
    console.warn(error.message);
  });

// Default restores the original icon
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

## How to Use

On success, the Promise resolves to the active icon name. The default name is `Default`. On failure, it rejects and `message` is an error code.

Calling `changeIcon()` with no argument, an empty string, or `Default` matches `resetIcon()`. Any other string must be a configured dynamic icon ID.

After a successful switch, the system refreshes the launcher icon. The application does not need to restart.

| Error code | Meaning |
| --- | --- |
| `HARMONY:NOT_SUPPORTED` | The device does not support `SystemCapability.AppGalleryService.AppInfoManager` |
| `HARMONY:ICON_ALREADY_USED:<id>` | The target dynamic icon is already active |
| `HARMONY:ICON_INVALID:<id>` | The ID is not in the dynamic icon list |
| `HARMONY:AGC_<code>:<message>` | AppGallery Kit error passthrough. Restoring an already active default icon commonly returns `1006800012` |
| `TurboModule ChangeIcon not available` | The native TurboModule is not linked |

`getIcon()` resolves `Default` when the service reports no dynamic icon data (error code `1006800010`).

`getConstants()` on the TurboModule spec returns an empty object and is not re-exported from the JS entry.

## Available APIs

> [!TIP] The **Platform** column indicates the platform where the properties are supported in the original third-party library.

> [!TIP] If the value of **OpenHarmony Platform Support** is **Yes**, it means that the OpenHarmony platform supports this property; **No** means the opposite; **partially** means some capabilities of this property are supported. The usage method is the same on different platforms and the effect is the same as that of iOS or Android.

### API

| Name | Type | Parameter Type | Return Value | Required | Platform | OpenHarmony Platform Support | Description |
| --- | --- | --- | --- | --- | --- | --- | --- |
| changeIcon | function | iconName?: string | Promise\<string\> | No | All | Yes | Switches the dynamic icon. `iconName` is an icon ID. An omitted value, an empty string, or `Default` restores the default icon. |
| resetIcon | function | / | Promise\<string\> | No | All | Yes | Restores the default icon and resolves `Default`. Rejects `HARMONY:AGC_1006800012` when the default icon is already active. |
| getIcon | function | / | Promise\<string\> | No | All | Yes | Returns the active dynamic icon ID, or `Default` when the default icon is active or no dynamic icon data exists. |

## Known Issues

None

## Other

None

## Directory Structure

```
/rntpc_react-native-change-icon          # Repository root
├── harmony/                             # HarmonyOS adaptation
│   ├── change_icon.har                  # HAR package
│   └── change_icon/                     # HarmonyOS module
│       ├── index.ets                    # Module entry
│       ├── oh-package.json5
│       └── src/main/
│           ├── ets/                     # ArkTS implementation
│           │   ├── ChangeIconPackage.ets
│           │   ├── ChangeIconTurboModule.ets
│           │   └── generated/           # Codegen output
│           └── cpp/                     # C++ bridge
│               ├── CMakeLists.txt
│               ├── ChangeIconPackage.h
│               └── generated/           # Codegen output
├── src/                                 # RN JS / Spec
│   ├── index.ts                         # JS entry
│   └── specs/v1/NativeChangeIcon.ts     # TurboModule spec
├── example/                             # Example app
├── package.json
├── README.md
├── README_EN.md
├── CHANGELOG.md
├── COMMITTERS.md
├── README.OpenSource
└── LICENSE
```

## How to Contribute

If you find any problem when using react-native-change-icon, submit an [issue](https://gitcode.com/xdxs/rntpc_react-native-change-icon/issues) or a [PR](https://gitcode.com/xdxs/rntpc_react-native-change-icon/pulls).

## License

The repository is based on [The MIT License (MIT)](https://github.com/skb1129/react-native-change-icon/blob/master/LICENSE).
