//
//  ImagePickerControllerConfiguration.swift
//
//  Created by Sergiy Loza on 15.06.17.
//  Copyright © 2016 Lemberg Solution. All rights reserved.
//

import Foundation
import PermissionsService

public class ImagePickerControllerConfiguration: NSObject {
    
    public class var `default`:ImagePickerControllerConfiguration {
        let configuration = ImagePickerControllerConfiguration()
        return configuration
    }
    
    public var actionSheetTitle: String  = "Select image"
    public var actionSheetMessage: String = "Select image from proposed sources"
    public var cameraActionTitle: String = "Take a photo"
    public var galleryActionTitle: String = "Chose a photo"
    public var removeActionTitle: String = "Remove a photo"
    public var cancelActionTitle: String = "Cancel"
    public var cameraMessages: ServiceMessages = CameraDefaultMessages()
    public var galleryMessages: ServiceMessages = GalleryDefaultMessages()
    
    public var camera: UIImagePickerControllerCameraDevice = .front
    
    public override init() {
        super.init()
    }
    
}
