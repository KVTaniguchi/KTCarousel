# KTCarousel

[![CI Status](http://img.shields.io/travis/Kevin Taniguchi/KTCarousel.svg?style=flat)](https://travis-ci.org/Kevin Taniguchi/KTCarousel)
[![Version](https://img.shields.io/cocoapods/v/KTCarousel.svg?style=flat)](http://cocoapods.org/pods/KTCarousel)
[![License](https://img.shields.io/cocoapods/l/KTCarousel.svg?style=flat)](http://cocoapods.org/pods/KTCarousel)
[![Platform](https://img.shields.io/cocoapods/p/KTCarousel.svg?style=flat)](http://cocoapods.org/pods/KTCarousel)

## Example

KTCarousel is a zoom in zoom out carousel zooming using a custom view controller transition.

It subclasses off UIPresentationController and uses a custom UIViewControllerAnimatedTransitioning/UIViewControllerTransitioningDelegate object to manage the zoom in / zoom out effect.

To use it, you have your source view controller conform to the KTCarouselTransitioning, KTSynchronizingDelegate protocols and you conform your destination view controller to KTCarouselTransitioning.


To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Demo](https://cloud.githubusercontent.com/assets/4974425/16194371/3fa475b6-36c2-11e6-9eb7-88103c40c01e.gif)

## Requirements

## Installation

KTCarousel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KTCarousel"
```

## Author

Kevin Taniguchi, kv.taniguchi@gmail.com

## License

KTCarousel is available under the MIT license. See the LICENSE file for more info.
# KTCarousel
