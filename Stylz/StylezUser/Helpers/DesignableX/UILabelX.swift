//
//  UILabelX.swift
//  DesignableXTesting
//
//  Created by Mark Moeykens on 1/28/17.
//  Copyright © 2017 Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UILabelX: UILabel {
   
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        if(K.DeviceType.isPad)
//        {
//            print("ipad label font")
//
////            let mySelectedFont = self.font
////            let selectedTextFontSize = (mySelectedFont!.pointSize * 2)
////
////            self.font = UIFont(name: mySelectedFont!.fontName,size: selectedTextFontSize)
////            self.frame.size.height = self.frame.size.height  * 2
//        }
//    }

    
//    @IBInspectable var iPadFontSize: CGFloat = 0 {
//        didSet {
//            if K.DeviceType.isPad{
//                print("ipad label font")
//             //   self.font = self.font.withSize(iPadFontSize)
//            }
//        }
//    }
// 
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rotationAngle: CGFloat = 0 {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: rotationAngle * .pi / 180)
        }
    }
    
    // MARK: - Shadow Text Properties
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColorLayer: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColorLayer.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetLayer: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetLayer
        }
    }
}
