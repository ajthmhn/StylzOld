//
//  UItextViewX.swift
//  DoctorsAppForPatients
//
//  Created by Me on 11/28/23.
//

import Foundation
import UIKit

@IBDesignable
class UITextViewX: UITextView {
    
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
    
    func updateView() {
    }
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

}

//extension UITextView {
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
