//
//  ImageSelector.swift
//  Pods
//
//  Created by Sergiy Loza on 15.06.17.
//
//

import Foundation

public protocol ImageSelector: class {
    
    var presentingController:UIViewController? { get }
    func imageSelected(_ image:UIImage)
    func imageSelectionCanceled()
    func imageDeleted()
    func editingAllowed() -> Bool
}
