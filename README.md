![Palette for TypographyKit](Palette.png)

[![CI Status](http://img.shields.io/travis/rwbutler/TypographyKitPalette.svg?style=flat)](https://travis-ci.org/rwbutler/TypographyKitPalette)
[![Maintainability](https://api.codeclimate.com/v1/badges/0e476dc7f68ea48e61f2/maintainability)](https://codeclimate.com/github/rwbutler/TypographyKitPalette/maintainability)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
[![Twitter](https://img.shields.io/badge/twitter-@TypographyKit-blue.svg?style=flat)](https://twitter.com/TypographyKit)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)

Palette is a tool for use with [TypographyKit](https://github.com/rwbutler/TypographyKit) which takes your app's color palette as defined in your TypographyKit.json or TypographyKit.plist file and generates a palette for use in Xcode Interface Builder so that developers can easily make use of the same colors regardless of whether they are being assigned programmatically or through IB.

In order to support dark mode in iOS 13 or higher, Palette now includes the option to export an asset catalog to host your dynamic colors.

# Installation

## Homebrew

To install using [Homebrew](https://brew.sh/):

```bash
brew install rwbutler/tools/palette
```

# Usage

## Color Palettes

In order to export a color palette for use in Xcode, Palette is invoked as follows:

`palette --color-list <color palette name> --config-url <url> -export palette`

Where the `--color-list` parameter specifies the name of the color palette as you wish it to appear in Interface Builder and `--config-url` specifies the URL to your [TypographyKit.json](https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.json) or [TypographyKit.plist](https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.plist) file. This may either be a path to a local file or remotely-hosted file using either `http` or `https` protocol.

## Asset Catalogs

In order to support dark mode in iOS 13, Palette now allows colors to be exported to asset catalogs. In order to export an asset catalog invoke palette as follows:

`palette --color-list <asset catalog name> --config-url <url> -export assetCatalog --asset-catalog-url <directory to save asset catalog>`

The `--color-list` parameter represents the name of the asset catalog to be exported and the `--asset-catalog-url` parameter represents the directory to which the asset catalog will be saved.

## Author

[Ross Butler](https://github.com/rwbutler)

## License

Palette is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.

## Additional Software

### Controls

* [AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) - Powerful gradient animations made simple for iOS.

|[AnimatedGradientView](https://github.com/rwbutler/AnimatedGradientView) |
|:-------------------------:|
|[![AnimatedGradientView](https://raw.githubusercontent.com/rwbutler/AnimatedGradientView/master/docs/images/animated-gradient-view-logo.png)](https://github.com/rwbutler/AnimatedGradientView) 

### Frameworks

* [Cheats](https://github.com/rwbutler/Cheats) - Retro cheat codes for modern iOS apps.
* [Connectivity](https://github.com/rwbutler/Connectivity) - Improves on Reachability for determining Internet connectivity in your iOS application.
* [FeatureFlags](https://github.com/rwbutler/FeatureFlags) - Allows developers to configure feature flags, run multiple A/B or MVT tests using a bundled / remotely-hosted JSON configuration file.
* [FlexibleRowHeightGridLayout](https://github.com/rwbutler/FlexibleRowHeightGridLayout) - A UICollectionView grid layout designed to support Dynamic Type by allowing the height of each row to size to fit content.
* [Hash](https://github.com/rwbutler/Hash) - Lightweight means of generating message digests and HMACs using popular hash functions including MD5, SHA-1, SHA-256.
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.
* [Updates](https://github.com/rwbutler/Updates) - Automatically detects app updates and gently prompts users to update.

|[Cheats](https://github.com/rwbutler/Cheats) |[Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Updates](https://github.com/rwbutler/Updates) |
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Cheats](https://raw.githubusercontent.com/rwbutler/Cheats/master/docs/images/cheats-logo.png)](https://github.com/rwbutler/Cheats) |[![Connectivity](https://github.com/rwbutler/Connectivity/raw/master/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://raw.githubusercontent.com/rwbutler/TypographyKit/master/docs/images/typography-kit-logo.png)](https://github.com/rwbutler/TypographyKit) | [![Updates](https://raw.githubusercontent.com/rwbutler/Updates/master/docs/images/updates-logo.png)](https://github.com/rwbutler/Updates)

### Tools

* [Clear DerivedData](https://github.com/rwbutler/ClearDerivedData) - Utility to quickly clear your DerivedData directory simply by typing `cdd` from the Terminal.
* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.

|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)