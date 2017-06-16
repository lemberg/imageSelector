//
//  UIImage+FixImageOrientation.swift
//
//  Created by Sergiy Loza on 29.08.16.
//  Copyright © 2016 Lemberg Solution. All rights reserved.
//

import UIKit

// MARK: - Fix image exif orientation

internal extension UIImage {
  
  func fixImageOrientation()->UIImage {
    
    if self.imageOrientation == UIImageOrientation.up {
      return self
    }
    
    var transform: CGAffineTransform = CGAffineTransform.identity
    
    switch self.imageOrientation {
    case UIImageOrientation.down, UIImageOrientation.downMirrored:
      transform = transform.translatedBy(x: self.size.width, y: self.size.height)
      transform = transform.rotated(by: CGFloat(Double.pi))
      break
    case UIImageOrientation.left, UIImageOrientation.leftMirrored:
      transform = transform.translatedBy(x: self.size.width, y: 0)
      transform = transform.rotated(by: CGFloat(Double.pi / 2))
      break
    case UIImageOrientation.right, UIImageOrientation.rightMirrored:
      transform = transform.translatedBy(x: 0, y: self.size.height)
      transform = transform.rotated(by: CGFloat(-(Double.pi / 2)))
      break
    case UIImageOrientation.up, UIImageOrientation.upMirrored:
      break
    }
    
    switch self.imageOrientation {
    case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
      transform.translatedBy(x: self.size.width, y: 0)
      transform.scaledBy(x: -1, y: 1)
      break
    case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
      transform.translatedBy(x: self.size.height, y: 0)
      transform.scaledBy(x: -1, y: 1)
    case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
      break
    }
    
    let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    
    ctx.concatenate(transform)
    
    switch self.imageOrientation {
    case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
      ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
      break
    default:
      ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
      break
    }
    
    let cgimg:CGImage = ctx.makeImage()!
    let img:UIImage = UIImage(cgImage: cgimg)
    
    return img
  }
}
