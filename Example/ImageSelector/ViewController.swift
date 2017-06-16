//
//  ViewController.swift
//  ImageSelector
//
//  Created by overswift on 06/15/2017.
//  Copyright (c) 2017 Lemberg Solutions. All rights reserved.
//

import UIKit
import ImageSelector

class ViewController: UIViewController {

    @IBOutlet weak var imageView:UIImageView!
    
    private lazy var imageController: ImagePickerController = {
        let a = ImagePickerController(imageSelector: self)
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectImage(_ sender: UIButton) {
        imageController.showImageSources()
    }
    
    @IBAction func handleLongPress(with gesture:UILongPressGestureRecognizer) {
        print("Long press \(gesture.state)")
    }
}

extension ViewController: ImageSelector {
    
    var presentingController:UIViewController? {
        return self
    }
    
    func imageSelected(_ image:UIImage) {
        imageView.image = image
    }
    
    func imageSelectionCanceled() {
        
    }
    
    func imageDeleted() {
        
    }
    
    func editingAllowed() -> Bool {
        return true
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
}

