//
//  UISwitchX.swift
//  Bilz
//
//  Created by Me on 1/2/24.
//

import Foundation
import UIKit
//extension UISwitch {
//
//    func set(width: CGFloat, height: CGFloat) {
//
//        let standardHeight: CGFloat = 31
//        let standardWidth: CGFloat = 51
//
//        let heightRatio = height / standardHeight
//        let widthRatio = width / standardWidth
//
//        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
//    }
//}

@IBDesignable class UISwitchX: UISwitch {
    
    @IBInspectable var scale : CGFloat = 1{
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }
    
    
    
    @IBInspectable var width: CGFloat {
        set {
            set(width: newValue, height: height)
        }
        get {
            frame.width
        }
    }
    
    @IBInspectable var height: CGFloat {
        set {
            set(width: width, height: newValue)
        }
        get {
            frame.height
        }
    }
  
    func set(width: CGFloat, height: CGFloat) {

            let standardHeight: CGFloat = 31
            let standardWidth: CGFloat = 51

            let heightRatio = height / standardHeight
            let widthRatio = width / standardWidth
print("chaing width and height")
            transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
        }
    
}
