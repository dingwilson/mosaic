#Mosaic

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)][mitLink]

## About

Mosaic is a realtime object translation app, using Microsoft's Cognitive Services Computer Vision library to describe and translate objects around you simply by pointing your phone's camera at it. This project was created and featured at HackTX2016, where it won 3rd Place overall, as well as API prizes from Goldman Sachs, HBK, Microsoft, Facebook, CDK, and 1517.

## Installation

To install and run Mosaic on your own iOS device, simply clone the repository. Run 'pod install' to install the various cocoapods. Then, get an API Key from Microsoft Cognitive Services, and add it to CognitiveSDK/CognitiveServices.swift. (Under the CognitiveServicesApiKeys enum, for the case "ComputerVision") Finally, open the project via XCode and build/run it on your own iDevice.

## Libraries Used

- Microsoft-Cognitive-Services-Swift-SDK
- SwiftVideoBackground
- NVActivityIndicatorView
- Alamofire
- SwiftyJSON

## Contributors

Mosaic was originally created by Wilson Ding, Kevin Nguyen, Matthew Hudson, and Michelle Fang.

## License

`Mosaic` is released under an [MIT License][mitLink]. See `LICENSE` for details.

**Copyright &copy; 2016-present Wilson Ding.**

*Please provide attribution, it is greatly appreciated.*

[mitLink]:http://opensource.org/licenses/MIT

