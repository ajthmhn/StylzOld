//
//  LoginViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 14/08/23.
//

import UIKit
import StylesWebKit
import FirebaseMessaging

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnQuick: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnLogin2: UIButton!
    @IBOutlet weak var imgLogo2: UIImageView!
    @IBOutlet weak var btnQuick2: UIButton!
    @IBOutlet weak var viewQuick: UIView!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnRetrive: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var lblPhone2: UILabel!
    @IBOutlet weak var btnCreate2: UIButton!
    
    
    
    var isFromProfile = false
    var deviceToken = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnQuick2.setTitleColor(getThemeColor(), for: .normal)
        btnQuick.setTitleColor(getThemeColor(), for: .normal)
        btnLogin.backgroundColor = getThemeColor()
        btnPassword.setTitleColor(getThemeColor(), for: .normal)
        btnBack.tintColor = getThemeColor()
        imgLogo.tintColor = getThemeColor()
        imgLogo2.tintColor = getThemeColor()
        btnLogin2.backgroundColor = getThemeColor()
        viewQuick.isHidden = true
        self.txtPhone.delegate = self
        
        
        lblLogin.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "login", comment: "")
        lblEmail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "email", comment: "")
        lblPassword.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "password", comment: "")
        btnRetrive.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "retrive_passwrd", comment: ""), for: .normal)
        btnLogin.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "login", comment: ""), for: .normal)
        btnLogin2.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "login", comment: ""), for: .normal)
        btnCreate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "create_account", comment: ""), for: .normal)
        btnCreate2.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "create_account", comment: ""), for: .normal)
        btnQuick.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "quick_login", comment: ""), for: .normal)
        btnQuick2.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "email_login", comment: ""), for: .normal)
        lblPhone2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "phone", comment: "")
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtEmail.textAlignment = .right
            txtPhone.textAlignment = .right
            txtPassword.textAlignment = .right
        }else{
            txtEmail.textAlignment = .left
            txtPhone.textAlignment = .left
            txtPassword.textAlignment = .left
        }
        
        
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                self.deviceToken = token
            }
        }
        
    }
    
    func loginUser(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        
        var  details = [String:Any]()
        details["email"] = txtEmail.text
        details["password"] = txtPassword.text
        details["user_type"] = 3
        details["fcm_id"] = deviceToken
        
        
        print(details)
        
        StylzAPIFacade.shared.login(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
                if let data = aRes?.json?["data"].dictionary{}
                if aRes?.json?["status"].stringValue == "true"{
                    if let data = aRes?.json?["data"].dictionary{
                        let emailVerified = data["email_verification_status"]?.boolValue
                        if emailVerified == false{
                            if  let userDetails = data["user_details"]?.dictionary{
                                let userID = data["user_id"]?.intValue
                                self.verifyOtpLogin(phone: "", email: self.txtEmail.text ?? "", id: userID ?? 0, isEmail: true)
                            }
                        }
                        else{
                            saveUserDetails(userDetails: (StylzAPIFacade.shared.session?.currentUser)!)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
                            vc?.modalPresentationStyle = .fullScreen
                            self.present(vc!, animated: true)
                            
                        }
                    }
                }else{
                    if let error = aRes?.json?["error"].array{
                        if error.count > 0{
                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                        }
                    }else{
                        let eror = aRes?.json?["error"].stringValue
                        if eror?.range(of:"verify your email address") != nil {
                            let alertController = UIAlertController(title: "", message: aRes?.json?["error"].stringValue, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                let userID = aRes?.json?["user_id"].intValue
                                self.verifyOtpLogin(phone: "", email: self.txtEmail.text ?? "", id: userID ?? 0, isEmail: true)
                            }
                            
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                            
                        }
                    }
                }
            }else{
                if let error = aRes?.json?["error"].array{
                    if error.count > 0{
                        showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                    }
                }else{
                    showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                }
            }
        }
    }
    
    func verifyOtpLogin(phone : String,email:String, id: Int, isEmail:Bool){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        
        var  details = [String:Any]()
        if isEmail == true{
            details["email"] = email
        }else{
            details["phone"] = phone
        }
        details["user_id"] = id
        
        
        print(details)
        
        StylzAPIFacade.shared.sendOtpLogin(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].stringValue == "true"{
                    if let data = aRes?.json?["data"].dictionary{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.otpView) as! OTPViewController
                        if isEmail == true{
                            vc.otp =  data["email_otp"]?.stringValue ?? ""
                        }else{
                            vc.otp =  data["phone_otp"]?.stringValue ?? ""
                        }
                        vc.isEmail = isEmail
                        vc.userId =  data["user_id"]?.intValue ?? 0
                        vc.mobile = self.txtPhone.text ?? ""
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }else{
                    if let error = aRes?.json?["error"].array{
                        if error.count > 0{
                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                        }
                    }else{
                        if let error = aRes?.json?["error"].dictionary{
                            showAlert(title: "", subTitle:  error["phone"]?.stringValue ?? "" , sender: self)
                            
                        }
                    }
                }
            }else{
                if let error = aRes?.json?["error"].array{
                    if error.count > 0{
                        showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                    }
                }else{
                    showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                }
            }
        }
    }
    
    func loginPhone(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        
        var  details = [String:Any]()
        details["phone"] = txtPhone.text
        
        print(details)
        
        StylzAPIFacade.shared.loginPhone(profDet: details) { (aRes) in
            
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].stringValue == "true"{
                    
                    if let data = aRes?.json?["data"].dictionary{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.otpView) as! OTPViewController
                        vc.otp =  data["otp"]?.stringValue ?? ""
                        vc.userId =  data["user_id"]?.intValue ?? 0
                        vc.mobile = self.txtPhone.text ?? ""
                        vc.isPhoneLogin = true
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }else{
                    if let error = aRes?.json?["error"].array{
                        if error.count > 0{
                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                        }
                    }else{
                        if let error = aRes?.json?["error"].dictionary{
                            showAlert(title: "", subTitle:  error["phone"]?.stringValue ?? "" , sender: self)
                            
                        }
                    }
                }
            }else{
                if let error = aRes?.json?["error"].array{
                    if error.count > 0{
                        showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                    }
                }else{
                    showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.register) as! RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //    @IBAction func btnRegister(_ sender: Any) {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.register) as! RegisterViewController
    //        self.navigationController?.pushViewController(vc, animated: true)
    //
    //    }
    
    @IBAction func btnForgot(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.forgot) as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnQuick(_ sender: UIButton) {
        if viewQuick.isHidden == true{
            viewQuick.isHidden = false
            animationScaleEffectSingle(view: viewQuick)
        }else{
            viewQuick.isHidden = true
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        
        if sender.tag == 0{
            if txtEmail.text == ""{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_email", comment: ""), sender: self)
                return
            }else if txtPassword.text == ""{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_passwrd", comment: ""), sender: self)
                return
            }
            
            loginUser()
        }else{
            if txtPhone.text == ""{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_phone", comment: ""), sender: self)
                return
            }
            loginPhone()
        }
    }
    
    @IBAction func btnEye(_ sender: UIButton) {
        if txtPassword.isSecureTextEntry == true{
            txtPassword.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }else{
            txtPassword.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField {
        case txtPhone :
            return prospectiveText.containsOnlyCharactersIn(matchCharacters: "0123456789") &&
            prospectiveText.count <= 9
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}
