![Palette for TypographyKit](Palette.png)

[![CI Status](http://img.shields.io/travis/rwbutler/TypographyKitPalette.svg?style=flat)](https://travis-ci.org/rwbutler/TypographyKitPalette)
[![License](https://img.shields.io/cocoapods/l/TypographyKit.svg?style=flat)](http://cocoapods.org/pods/TypographyKit)

Palette is a tool for use with [TypographyKit](https://github.com/rwbutler/TypographyKit) which takes your app's color palette as defined in your TypographyKit.json or TypographyKit.plist file and generates a palette for use in Xcode Interface Builder so that developers can easily make use of the same colors regardless of whether they are being assigned programmatically or through IB.

# Usage

The palette tool is invoked as follows:

`palette --color-list <color palette name> --config-url <url>`

Where the `--color-list` parameter specifies the name of the color palette as you wish it to appear in Interface Builder and `--config-url` specifies the URL to your [TypographyKit.json](https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.json) or [TypographyKit.plist](https://github.com/rwbutler/TypographyKit/blob/master/Example/TypographyKit/TypographyKit.plist) file. This may either be a path to a local file or remotely-hosted file using either `http` or `https` protocol.