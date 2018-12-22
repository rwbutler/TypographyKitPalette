![Palette for TypographyKit](Palette.png)

[![CI Status](http://img.shields.io/travis/rwbutler/TypographyKitPalette.svg?style=flat)](https://travis-ci.org/rwbutler/TypographyKitPalette)
[![Maintainability](https://api.codeclimate.com/v1/badges/0e476dc7f68ea48e61f2/maintainability)](https://codeclimate.com/github/rwbutler/TypographyKitPalette/maintainability)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
[![Twitter](https://img.shields.io/badge/twitter-@TypographyKit-blue.svg?style=flat)](https://twitter.com/TypographyKit)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://swift.org/)

Palette is a tool for use with [TypographyKit](https://github.com/rwbutler/TypographyKit) which takes your app's color palette as defined in your TypographyKit.json or TypographyKit.plist file and generates a palette for use in Xcode Interface Builder so that developers can easily make use of the same colors regardless of whether they are being assigned programmatically or through IB.

# Installation

## Homebrew

To install using [Homebrew](https://brew.sh/):

```bash
brew tap rwbutler/tools
brew install palette
```

# Usage

The palette tool is invoked as follows:

`palette --color-list <color palette name> --config-url <url>`

Where the `--color-list` parameter specifies the name of the color palette as you wish it to appear in Interface Builder and `--config-url` specifies the URL to your [TypographyKit.json](https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.json) or [TypographyKit.plist](https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.plist) file. This may either be a path to a local file or remotely-hosted file using either `http` or `https` protocol.

## Additional Software

### Frameworks

* [Connectivity](https://github.com/rwbutler/Connectivity) - Improves on Reachability for determining Internet connectivity in your iOS application.
* [FeatureFlags](https://github.com/rwbutler/FeatureFlags) - Allows developers to configure feature flags, run multiple A/B or MVT tests using a bundled / remotely-hosted JSON configuration file.
* [Skylark](https://github.com/rwbutler/Skylark) - Fully Swift BDD testing framework for writing Cucumber scenarios using Gherkin syntax.
* [TailorSwift](https://github.com/rwbutler/TailorSwift) - A collection of useful Swift Core Library / Foundation framework extensions.
* [TypographyKit](https://github.com/rwbutler/TypographyKit) - Consistent & accessible visual styling on iOS with Dynamic Type support.

### Tools

* [Config Validator](https://github.com/rwbutler/ConfigValidator) - Config Validator validates & uploads your configuration files and cache clears your CDN as part of your CI process.
* [IPA Uploader](https://github.com/rwbutler/IPAUploader) - Uploads your apps to TestFlight & App Store.
* [Palette](https://github.com/rwbutler/TypographyKitPalette) - Makes your [TypographyKit](https://github.com/rwbutler/TypographyKit) color palette available in Xcode Interface Builder.


|[Config Validator](https://github.com/rwbutler/ConfigValidator) | [Connectivity](https://github.com/rwbutler/Connectivity) | [FeatureFlags](https://github.com/rwbutler/FeatureFlags) | [IPA Uploader](https://github.com/rwbutler/IPAUploader) | [Skylark](https://github.com/rwbutler/Skylark) | [TypographyKit](https://github.com/rwbutler/TypographyKit) | [Palette](https://github.com/rwbutler/TypographyKitPalette)|
|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:|
|[![Config Validator](https://raw.githubusercontent.com/rwbutler/ConfigValidator/master/docs/images/config-validator-logo.png)](https://github.com/rwbutler/ConfigValidator) | [![Connectivity](https://github.com/rwbutler/Connectivity/raw/master/ConnectivityLogo.png)](https://github.com/rwbutler/Connectivity) | [![FeatureFlags](https://raw.githubusercontent.com/rwbutler/FeatureFlags/master/docs/images/feature-flags-logo.png)](https://github.com/rwbutler/FeatureFlags) | [![IPA Uploader](https://raw.githubusercontent.com/rwbutler/IPAUploader/master/docs/images/ipa-uploader-logo.png)](https://github.com/rwbutler/IPAUploader) | [![Skylark](https://github.com/rwbutler/Skylark/raw/master/SkylarkLogo.png)](https://github.com/rwbutler/Skylark) | [![TypographyKit](https://github.com/rwbutler/TypographyKit/raw/master/TypographyKitLogo.png)](https://github.com/rwbutler/TypographyKit) | [![Palette](https://raw.githubusercontent.com/rwbutler/TypographyKitPalette/master/docs/images/typography-kit-palette-logo.png)](https://github.com/rwbutler/TypographyKitPalette)

