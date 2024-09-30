//
//  UISearchbarX.swift
//  DoctorsAppForPatients
//
//  Created by Me on 11/11/23.
//

import Foundation
//
//  DesignableUISearchBar.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/16/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UISearchBarX: UISearchBar {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var ImageTint: UIColor? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    
    private var _isRightViewVisible: Bool = true
    var isRightViewVisible: Bool {
        get {
            return _isRightViewVisible
        }
        set {
            _isRightViewVisible = newValue
            updateView()
        }
    }
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    @IBInspectable public var shadowRadius: CGFloat = 0
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 0)
   
    // MARK: - Corner Radius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    
    func updateView() {
       // setLeftImage()
        //setRightImage()
        
        // Placeholder text color
    //    attributedPlaceholder = NSAttributedString(string: placeholder != nil ?
      //      placeholder! :
        //    "", attributes:[NSAttributedString.Key.foregroundColor: tintColor])
        
    }
    
//    func setLeftImage() {
//        leftViewMode = UISearchBar.ViewMode.always
//        var view: UIView
//
//        if let image = leftImage {
//            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
//            imageView.image = image
//            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
//            imageView.tintColor = tintColor
//
//            var width = imageView.frame.width + leftPadding
//
//            if borderStyle == UISearchBar.BorderStyle.none || borderStyle == UISearchBar.BorderStyle.line {
//                width += 5
//            }
//
//            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
//            view.addSubview(imageView)
//        } else {
//            view = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 20))
//        }
//
//        leftView = view
//    }
//
//    func setRightImage() {
//        rightViewMode = UISearchBar.ViewMode.always
//
//        var view: UIView
//
//        if let image = rightImage, isRightViewVisible {
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            imageView.image = image
//            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
//            imageView.tintColor = tintColor
//
//            var width = imageView.frame.width + rightPadding
//
//            if borderStyle == UISearchBar.BorderStyle.none || borderStyle == UISearchBar.BorderStyle.line {
//                width += 5
//            }
//
//            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
//            view.addSubview(imageView)
//
//        } else {
//            view = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: 20))
//        }
//
//        rightView = view
//    }
//
    

}

//extension UISearchBar {
//    @IBInspectable var placeholderColor: UIColor {
//        get {
//            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
//        }
//        set {
//            guard let attributedPlaceholder = attributedPlaceholder else { return }
//            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
//            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
//        }
//    }
//}
