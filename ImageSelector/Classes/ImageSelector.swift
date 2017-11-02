//
//  ImageSelector.swift
//
//  Created by Sergiy Loza on 15.06.17.
//  Copyright © 2016 Lemberg Solution. All rights reserved.
//

import Foundation

public protocol ImageSelector: class {
    
    var presentingController: UIViewController? { get }
    func imageSelected(_ image:UIImage)
    func imageSelectionCanceled()
    func imageDeleted()
    func editingAllowed() -> Bool
}
