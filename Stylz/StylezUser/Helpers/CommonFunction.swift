//
//  CommonFunction.swift
//  StylezUser
//
//  Created by Ajith Mohan on 10/08/23.
//

import Foundation
import UIKit
import StylesWebKit
import Kingfisher
import Indicate

struct stryBrdId {
    static let category = "CategoryViewController_id"
    static let shops = "ShopsViewController_id"
    static let service = "ServiceViewController_id"
    static let serviceDetail = "ServiceDetailsViewController_id"
    static let cartId = "CartViewController_id"
    static let selectDate = "SelectDateViewController_id"
    static let login = "LoginViewController_id"
    static let register = "RegisterViewController_id"
    static let thanks = "ThanksViewController_id"
    static let salons = "SalonsViewController_id"
    static let appointmentDetails = "AppointmentDetailsViewController_id"
    static let appointments = "AppointmentsViewController_id"
    static let editProfile = "EditProfileViewController_id"
    static let address = "AddressViewController_id"
    static let history = "HIstoryViewController_id"
    static let notifications = "NotificationsViewController_id"
    static let options = "SelectOptionsViewController_id"
    static let otpView = "OTPViewController_id"
    static let summary = "SummeryViewController_id"
    static let addAddress = "AddAddressViewController_id"
    static let updatePhone = "UpdatePhoneViewController_id"
    static let search = "SearchViewController_id"
    static let payment = "PaymentViewController_id"
    static let wallet = "WalletViewController_id"
    static let forgot = "ForgotPasswordViewController_id"
    static let updatePass = "UpdatePasswordViewController_id"
    static let menu = "MenuViewController_id"
}

var maleColor = UIColor(hexString : "61AB9A")
var femaleColor = UIColor(hexString : "F35F5D")
var addressSelected = false
var latitude = 0.0
var longitude = 0.0
var languageChange = false
var userAddress = ""

var mylatitude = 0.0
var mylongitude = 0.0
var myAddress = ""
var paynowDicountValue = 0.0

func formatPrice(price:Double) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal          // Set defaults to the formatter that are common for showing decimal numbers
    numberFormatter.usesGroupingSeparator = true    // Enabled separator
    numberFormatter.groupingSeparator = ","         // Set the separator to "," (e.g. 1000000 = 1,000,000)
    numberFormatter.groupingSize = 3                // Set the digits between each separator
    numberFormatter.minimumFractionDigits = 2

    // maximum decimal digit, eg: to display 2.5021 as 2.50
    numberFormatter.maximumFractionDigits = 2

    // round up 21.586 to 21.59. But doesn't round up 21.582, making it 21.58
    numberFormatter.roundingMode = .halfUp

    return numberFormatter.string(for: price) ?? ""
}

func clearCart(){
    UserDefaults.standard.set(nil, forKey: "cart_details")
    UserDefaults.standard.synchronize()
}

func saveCart(details:[String:Any]){
    var isSame = false
    var cartData = [[String:Any]]()
   
    if getCartData() != nil{
        cartData.append(contentsOf: getCartData()!)
    }
    
    if cartData.count > 0{
        for all in cartData{
            //all["customer_id"] as? Int == details["customer_id"] as? Int &&
            if all["service_id"] as? Int == details["service_id"] as? Int{
                isSame = true
            }
        }
    }
    
    if isSame == false{
        cartData.append(details)
    }
    
    UserDefaults.standard.set(cartData, forKey: "cart_details")
    UserDefaults.standard.synchronize()
}


func showSuccess(title:String, subTitle:String, view:UIView){
    // STEP 1: Define the content
    let content = Indicate.Content(title: .init(value: LocalizationSystem.sharedInstance.localizedStringForKey(key: "success", comment: ""), alignment: .natural),
                                   subtitle: .init(value: subTitle, alignment: .natural),
                                   attachment: .emoji(.init(value: "✅", alignment: .natural)))
    // STEP 2: Configure the presentation
    let config = Indicate.Configuration()
        .with(tap: { controller in
            controller.dismiss()
        })

    // STEP 3: Present the indicator
    let controller = Indicate.PresentationController(content: content, configuration: config)
    controller.present(in: (view))
}

func getCartData() -> [[String:Any]]?{
    return UserDefaults.standard.array(forKey: "cart_details") as? [[String:Any]]
}

func getDarkColor() -> UIColor{
    if checkIfNotMale() == true{
        return UIColor(hexString: "F35F5D")!
    }else{
        return UIColor(hexString: "1B263A")!
    }
}

func saveUserDetails(userDetails:User){
    let dict = userDetails.dicValue()
    UserDefaults.standard.set(dict, forKey: "user_details")
    UserDefaults.standard.synchronize()
}


func isNotFirstTime(value:Bool){
    UserDefaults.standard.set(value, forKey: "not_first")
    UserDefaults.standard.synchronize()
}

func checkIfNotFirst() -> Bool?{
    return UserDefaults.standard.bool(forKey: "not_first")
}


func getUserDetails() -> [String:Any]?{
    return UserDefaults.standard.dictionary(forKey: "user_details") ?? nil
}

func deleteUserDetails(){
    let defaults = UserDefaults.standard
    defaults.set(nil, forKey: "user_details")
    defaults.synchronize()
}

func showAlert(title:String,subTitle:String,sender:UIViewController){
    let alertController = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
        }
    alertController.addAction(okAction)
    sender.present(alertController, animated: true, completion: nil)
}


func showNetworkError(sender:UIViewController){
    let alert = UIAlertController(title: "" , message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "network_error", comment: ""), preferredStyle: .alert)
    let OkButton = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""),style: .cancel) { (alert) -> Void in
    }
    alert.addAction(OkButton)
    sender.present(alert, animated: true, completion: nil)
}

func setImage(imageView : UIImageView, url : String){
    let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let imagepath =  URL(string:urlString)
    imageView.kf.setImage(with: imagepath)
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }

}

func getLightColor() -> UIColor{
    if checkIfNotMale() == true{
        return UIColor(hexString: "F8E4E3")!
    }else{
        return UIColor(hexString: "F6F6F6")!
    }
}


func getThemeColor() -> UIColor{
    if checkIfNotMale() == true{
        return UIColor(hexString: "F35F5D")!
    }else{
        return UIColor(hexString: "61AB9A")!
    }
}

func isNotMale(value:Bool){
    let defaults = UserDefaults.standard
    defaults.setValue(value, forKey: "check_male")
    defaults.synchronize()
}

func checkIfNotMale() -> Bool{
    return UserDefaults.standard.bool(forKey: "check_male")
}

extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars = ["F","F"] + chars
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                  green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                  blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                  alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}

func animationScaleEffectSingle(view:UIView)
{
    DispatchQueue.main.async {
        view.transform = view.transform.scaledBy(x: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
    }
}

func animationScaleEffect(view:[UIView])
{
    DispatchQueue.main.async {
        for all in view{
            all.transform = all.transform.scaledBy(x: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                all.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            }, completion: nil)
        }
    }

}

class RTLNavController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Adding swipe to pop viewController
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self

        //  UINavigationControllerDelegate
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.view.semanticContentAttribute = UIView.isRightToLeft() ? .forceRightToLeft : .forceLeftToRight
        navigationController.navigationBar.semanticContentAttribute = UIView.isRightToLeft() ? .forceRightToLeft : .forceLeftToRight
    }

    //  Checking if the viewController is last, if not disable the gesture
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count > 1 {
            return true
        }
        
        return false
    }
}

extension UIView {
    static func isRightToLeft() -> Bool {
        return UIView.appearance().semanticContentAttribute == .forceRightToLeft
    }
}

extension UIView {
    func dropShadow(color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
      }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
