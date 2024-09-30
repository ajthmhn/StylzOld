//
//  UIViewX.swift
//  DesignableX
//
//  Created by Mark Moeykens on 12/31/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIViewX: UIView {
    
//   
//    // it would be better to create and add it in viewDidLoad though
//    lazy var heightConstraint: NSLayoutConstraint = {
//        let constraint = self.heightAnchor.constraint(equalToConstant: self.bounds.height)
//        constraint.isActive = true
//        return constraint
//    }()
//
//    @IBInspectable var iPadheight: CGFloat = 0.0 {
////        get {
////
////            if K.DeviceType.isPad{
////                return self.heightConstraint.constant + self.iPadheight
////            }
////
////            return self.heightConstraint.constant
////        }
////        set {
////            if K.DeviceType.isPad{
////                self.heightConstraint.constant = newValue + iPadheight
////                print("setting ipad height to \(self.heightConstraint.constant)")
////               }
////
////            self.heightConstraint.constant = newValue
////        }
//        didSet{
//            if K.DeviceType.isPad{
//                print("ipad height \(iPadheight)")
//                // self.heightConstraint.constant = iPadheight
//             //   self.frame.size.height = iPadheight
//            
//            }
//        }
//     }
//
//    
//    override func awakeFromNib()
//    {
//        super.awakeFromNib()
//
//        if(K.DeviceType.isPad)
//        {
//            print("ipad size *\(self.frame.size.height*2)")
//            //self.frame.size.height = self.frame.size.height * 2
//          //  self.heightConstraint.constant = self.heightConstraint.constant * 2
//      //
//        }
//    }

    
    // MARK: - Gradient
    
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]
        
        if (horizontalGradient) {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius

        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
}
