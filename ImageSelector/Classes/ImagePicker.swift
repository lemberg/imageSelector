//
//  ImagePicker.swift
//
//  Created by Sergiy Loza on 29.08.16.
//  Copyright © 2016 Lemberg Solution. All rights reserved.
//

import UIKit
import PermissionsService

public
protocol ImagePicker: class {
    
    func showImageSources(_ withDeleteOption:Bool)
    func pickFromGallery()
    func pickFromCamera()
}

public struct GalleryDefaultMessages: ServiceMessages {
    
    public var restrictedTitle: String = "Restricted"
    public var restrictedMessage: String = "Access to gallery restricted"
    public var deniedTitle: String = "Denied"
    public var deniedMessage: String = "Access to gallery denied"
}

public struct CameraDefaultMessages: ServiceMessages {
    
    public var restrictedTitle: String = "Restricted"
    public var restrictedMessage: String = "Access to camera restricted"
    public var deniedTitle: String = "Denied"
    public var deniedMessage: String = "Access to camera denied"
}



extension UIViewController: ServiceDisplay {
    
    public func showAlert(vc: UIAlertController) {
        self.present(vc, animated: true, completion: nil)
    }
}

public class ImagePickerController: NSObject, UINavigationControllerDelegate, ImagePicker {
    
    fileprivate weak var imageSelector:ImageSelector?
    
    var configuration:ImagePickerControllerConfiguration
    
    private override init() {
        self.configuration = ImagePickerControllerConfiguration.default
        super.init()
    }
    
    public init(imageSelector:ImageSelector, configuration: ImagePickerControllerConfiguration = ImagePickerControllerConfiguration.default) {
        self.imageSelector = imageSelector
        self.configuration = configuration
        super.init()
    }
    
    public func showImageSources(_ showDeleteOption:Bool = false) {
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
    
    
    public func pickFromGallery() {
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
    
    public func pickFromCamera() {
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imageSelector?.presentingController?.dismiss(animated: true, completion: nil)
    }
}
