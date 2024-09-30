////
////  HandlingIpadSize.swift
////  DoctorsAppForPatients
////
////  Created by Me on 11/29/23.
////
//
//import Foundation
//import UIKit
//
//@IBDesignable class AdaptiveConstraint: NSLayoutConstraint {
//
////@IBInspectable override var constant: CGFloat {
////      get {
////          return self.constant }
////      set {
////          self.constant = newValue + A_VARIABLE_I_USE_BASED_ON_IPHONE_TYPE
////
////      }
////
////}
//    
////    @IBInspectable override var constant: CGFloat {
////        get {
////            // note we are calling `super.`, added subtract for consistency
////            if K.DeviceType.isPad{
////                return super.constant * CGFloat()
////            }
////
////            return super.constant
////        }
////        set {
////            // note we are calling `super.`
////            super.constant = newValue + 20
////
////            if K.DeviceType.isPad{
////                super.constant = newValue * CGFloat(K.iPAdSize)
////            }
//////            super.constant = newValue + A_VARIABLE_I_USE_BASED_ON_IPHONE_TYPE
////
////            super.constant = newValue
////           }
////    }
////
//
//    
//}
//
//
//
//@IBDesignable class AttributedView: UIView {
//    
//    // it would be better to create and add it in viewDidLoad though
//    lazy var heightConstraint: NSLayoutConstraint = {
//        let constraint = self.heightAnchor.constraint(equalToConstant: self.bounds.height)
//        constraint.isActive = true
//        return constraint
//    }()
//
//    @IBInspectable var iPadheight: CGFloat {
//        get {
//            return self.heightConstraint.constant + iPadheight
//        }
//        set {
//            self.heightConstraint.constant = newValue + 30
//            
//        }
//     }
//
//
//    
//}
