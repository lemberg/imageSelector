# ImageSelector

[![CI Status](http://img.shields.io/travis/overswift/ImageSelector.svg?style=flat)](https://travis-ci.org/overswift/ImageSelector)
[![Version](https://img.shields.io/cocoapods/v/ImageSelector.svg?style=flat)](http://cocoapods.org/pods/ImageSelector)
[![Swift Version](https://img.shields.io/badge/Swift-3.1%2B-orange.svg?style=flat)](http://cocoapods.org/pods/ImageSelector) 
[![iOS Platform](https://img.shields.io/badge/iOS-%209.0%2B-blue.svg?style=flat)](http://cocoapods.org/pods/ImageSelector) 
[![License](https://img.shields.io/cocoapods/l/ImageSelector.svg?style=flat)](http://cocoapods.org/pods/ImageSelector)
[![By](https://img.shields.io/badge/By-Lemberg%20Solutions%20Limited-blue.svg?style=flat)](http://cocoapods.org/pods/ImageSelector)

The simplest way to work with camera & photo library. 

1. [Features](https://github.com/lemberg/imageSelector#features)
1. [Requirements](https://github.com/lemberg/imageSelector#requirements)
1. [Installation](https://github.com/lemberg/imageSelector#installation)
1. [How To Use](https://github.com/lemberg/imageSelector#how-to-use)
1. [Customizing](https://github.com/lemberg/imageSelector#customizing) 
1. [Example Project](https://github.com/lemberg/imageSelector#example-project) 
1. [Author](https://github.com/lemberg/imageSelector#author)
1. [License](https://github.com/lemberg/imageSelector#license)

## Features

- [x] Automatic permission request
- [x] Permissions error handling 
- [x] ActionsSheet creating, presenting and handling 
- [x] Simple and fast implementing  
- [x] Customising opportunity 
- [x] Localizing opportunity for dialogue 

## Requirements

- iOS 9.0+
- Swift 3.0+
- Xcode 8.0+

## Installation

ImageSelector is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```swift
pod "ImageSelector"
```

:exclamation: This pod have a dependency to  [ios-permissions-service framework](https://github.com/lemberg/ios-permissions-service) so it will be installed too. You can read about it [here](https://github.com/lemberg/ios-permissions-service).

## How To Use

1. Configure your project for chosen permission type: add a specific key with purpose string to your .plist file.  

2. Implement  `ImageSelector ` protocol in your class with all methods. 

Name | Description
-----| -----------
`presentingController` | Should return current view controller, for example, `self`
`imageSelected(_:)` |  Will return you selected image or photo from camera
`imageSelectionCanceled()` | Do something when user cancel 
`imageDeleted()` | User choose to delete option in presented dialogue 
`editingAllowed()` | Allow or disable edit option 


3. Create object of type `ImagePickerController` custom type 

```swift

    private lazy var imageController: ImagePickerController = {
        let picker = ImagePickerController(imageSelector: self)
        return picker
    }()

```
> :exclamation: You can do it not `lazy`,  but you **should always** create it like **global** variable and **never** like local.   

4. Call `showImageSources()` method       

```swift
     imageController.showImageSources()
```

4. Build. Run. Be happy! :tada: 

## Customizing

* You can add `Delete` option to action sheet wich presenting to the user via `showImageSources` method. By default, this method contains a `false` parameter for the delete option, so you can change it to `true`.  

```swift
     imageController.showImageSources(true)
```

* If you don't want to show actions sheet to the user, you can simply call `pickFromGallery()` or `pickFromCamera()` to show image picker. 

* You can localise action sheet or give it your custom messages by creating custom `ImagePickerControllerConfiguration`.  After it, you need to put into the init method of `ImagePickerController`. 

> If you don't create custom configuration default value will be used. 

```swift

     let configuration = ImagePickerControllerConfiguration()
     configuration.actionSheetTitle = "Select photo"
     configuration.actionSheetMessage = "Select image from proposed sources"
     configuration.cameraActionTitle = "Take a photo"
     configuration.galleryActionTitle = "Chose a photo"
     configuration.removeActionTitle = "Remove a photo"
     configuration.camera = .front

     let picker = ImagePickerController(imageSelector: self, configuration())
```

By adding custom configuration you can change default camera source too. 

```swift
      configuration.camera = .front

```

## Example Project

:exclamation: For more details or if you have some problems you can check Example project. 

### How to do it?

1. Clone the repo. 
1. run `pod install` from the Example directory
1. Enjoy!  :tada: 

## Author

### [Lemberg Solutions](http://lemberg.co.uk) 

[![iOS Platform](http://lemberg.co.uk/sites/all/themes/lemberg/images/logo.png)](https://github.com/lemberg) 

Sergiy Loza, sergiy.loza@lemberg.co.uk

## License

ImageSelector is available under the [MTI license](https://directory.fsf.org/wiki/License:MTI). See the LICENSE file for more info.

