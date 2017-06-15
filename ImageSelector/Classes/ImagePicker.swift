//
//  ImagePicker.swift
//  StylesCloud
//
//  Created by Sergiy Loza on 29.08.16.
//  Copyright © 2016 Lemberg Solution. All rights reserved.
//

import UIKit
import PermissionsService

protocol ImageSelector: class {
    
    var presentingController:UIViewController? { get }
    func imageSelected(_ image:UIImage)
    func imageSelectionCanceled()
    func imageDeleted()
    func editingAllowed() -> Bool
}

protocol ImagePickerProtocol: class {
    
    func showImageSources(_ withDeleteOption:Bool)
    func pickFromGallery()
    func pickFromCamera()
}

struct GalleryDefaultMessages: ServiceMessages {
    
    var restrictedTitle: String = "Restricted"
    var restrictedMessage: String = "Access to gallery restricted"
    var deniedTitle: String = "Denied"
    var deniedMessage: String = "Access to gallery denied"
}

struct CameraDefaultMessages: ServiceMessages {
    
    var restrictedTitle: String = "Restricted"
    var restrictedMessage: String = "Access to camera restricted"
    var deniedTitle: String = "Denied"
    var deniedMessage: String = "Access to camera denied"
}

class ImagePickerControllerConfiguration {
    
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

extension UIViewController: ServiceDisplay {
    
    public func showAlert(vc: UIAlertController) {
        self.present(vc, animated: true, completion: nil)
    }
}

class ImagePickerController: NSObject, UINavigationControllerDelegate, ImagePickerProtocol {
    
    fileprivate weak var imageSelector:ImageSelector?
    
    var configuration:ImagePickerControllerConfiguration
    
    init(imageSelector:ImageSelector, configuration: ImagePickerControllerConfiguration = ImagePickerControllerConfiguration.default) {
        self.imageSelector = imageSelector
        self.configuration = configuration
    }
    
    func showImageSources(_ showDeleteOption:Bool = false) {
        let controller = UIAlertController(title: configuration.actionSheetTitle, message: configuration.actionSheetMessage, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: configuration.galleryActionTitle, style: .default) { (action) -> Void in
            self.pickFromGallery()
        }
        

        
        let cancelAction = UIAlertAction(title: configuration.cancelActionTitle, style: .cancel) { (action) -> Void in
        }
        
        if showDeleteOption {
            let removeAction = UIAlertAction(title: configuration.removeActionTitle, style: .destructive) { (action) -> Void in
                self.imageSelector?.imageDeleted()
            }
            controller.addAction(removeAction)
        }
        
        
        if UIImagePickerController.isCameraDeviceAvailable(configuration.camera) {
            let cameraAction = UIAlertAction(title: configuration.cameraActionTitle, style: .default) { (action) -> Void in
                self.pickFromCamera()
            }
            controller.addAction(cameraAction)
        }
        controller.addAction(galleryAction)
        controller.addAction(cancelAction)
        self.imageSelector?.presentingController?.present(controller, animated: true, completion: nil)
    }
    
    
    func pickFromGallery() {
        guard let controller = imageSelector?.presentingController else {
            assertionFailure("ViewController miss")
            return
        }
        
        Permission<Gallery>.prepare(for: controller) { [weak self] (granted) in
            if granted {
                self?.showGallery()
            }
        }

    }
    
    func pickFromCamera() {
        guard let controller = imageSelector?.presentingController else {
            assertionFailure("ViewController miss")
            return
        }
        
        Permission<Camera>.prepare(for: controller) { [weak self] (granted) in
            if granted {
                self?.showCamera()
            }
        }
    }
    
    // MARK: - Camera
    fileprivate func showCamera() {
        let cameraController = UIImagePickerController()
        cameraController.allowsEditing = imageSelector?.editingAllowed() ?? false
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.camera
        cameraController.cameraDevice = configuration.camera
        self.imageSelector?.presentingController?.showDetailViewController(cameraController, sender: self)
    }
    
    // MARK: - Gallery
    func showGallery() {
        let cameraController = UIImagePickerController()
        cameraController.allowsEditing = imageSelector?.editingAllowed() ?? false
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.imageSelector?.presentingController?.showDetailViewController(cameraController, sender: self)
    }
}

extension ImagePickerController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            self.imageSelector?.presentingController?.dismiss(animated: true, completion: nil)
        }
        
        var selectedImage:UIImage?
        
        if picker.sourceType == UIImagePickerControllerSourceType.camera {
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                selectedImage = editedImage.fixImageOrientation()
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                selectedImage = originalImage.fixImageOrientation()
            }
        } else {
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                selectedImage = editedImage.fixImageOrientation()
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                selectedImage = originalImage.fixImageOrientation()
            }
        }
        
        guard let image = selectedImage else {
            print("Some problem with selection image from camera")
            return
        }
        imageSelector?.imageSelected(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imageSelector?.presentingController?.dismiss(animated: true, completion: nil)
    }
}
