//
//  ImagePickerControllerConfiguration.swift
//
//  Created by Sergiy Loza on 15.06.17.
//  Copyright © 2016 Lemberg Solution. All rights reserved.
//

import Foundation
import PermissionsService

public class ImagePickerControllerConfiguration {
    
    class var `default`:ImagePickerControllerConfiguration {
        
        let configuration = ImagePickerControllerConfiguration()
        configuration.actionSheetTitle = "Select image"
        configuration.actionSheetMessage = "Select image from proposed sources"
        configuration.cameraActionTitle = "Take a photo"
        configuration.galleryActionTitle = "Chose a photo"
        configuration.removeActionTitle = "Remove a photo"
        configuration.cameraActionTitle =  "Cancel"
        return configuration
    }
    
    var actionSheetTitle: String?
    var actionSheetMessage: String?
    var cameraActionTitle: String?
    var galleryActionTitle: String?
    var removeActionTitle: String?
    var cancelActionTitle: String?
    var cameraMessages: ServiceMessages = CameraDefaultMessages()
    var galleryMessages: ServiceMessages = GalleryDefaultMessages()
    
    var camera: UIImagePickerControllerCameraDevice = .front
}
