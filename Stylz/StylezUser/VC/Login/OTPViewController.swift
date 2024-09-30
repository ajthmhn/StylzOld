//
//  OTPViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 22/08/23.
//

import UIKit
import AEOTPTextField
import StylesWebKit
import FirebaseMessaging

class OTPViewController: UIViewController {

    @IBOutlet var txtOtp: AEOTPTextField!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var lblHead2: UILabel!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet var lblReceive: UILabel!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var btnback: UIButton!
    
    
    var otp = ""
    var mobile = ""
    var otpRight = ""
    var userId = 0
    var isPhoneLogin = false
    var isEmail = false
    var isPassword = false
    var deviceToken = ""
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtOtp.otpDelegate = self
        txtOtp.otpFont = UIFont.boldSystemFont(ofSize: 22)
        txtOtp.otpFontSize = 22
        txtOtp.otpTextColor = UIColor.black
        txtOtp.otpCornerRaduis = 10
        txtOtp.otpDefaultBorderColor = UIColor.lightGray.withAlphaComponent(0.3)
        txtOtp.otpDefaultBorderWidth = 1
        txtOtp.otpBackgroundColor = UIColor(hexString: "FFFFFF")!
        txtOtp.otpFilledBorderColor = UIColor(hexString: "143659")!
        txtOtp.otpFilledBackgroundColor = UIColor(hexString: "FFFFFF")!
        txtOtp.configure(with: 5)
        txtOtp.textContentType = .oneTimeCode
        
        txtOtp.becomeFirstResponder()
        txtOtp.textAlignment = .left
        
        setLanguage()
        
        
        Messaging.messaging().token { token, error in
                 if let error = error {
                   print("Error fetching FCM registration token: \(error)")
                 } else if let token = token {
                     self.deviceToken = token
                 }
               }
    }
    
    func setLanguage(){
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "otp_verification", comment: "")
        if isEmail == true{
            lblHead2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "check_email", comment: "")
        }else{
            lblHead2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "check_phone", comment: "")
            
        }
        btnContinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "continue", comment: ""), for: .normal)
        lblReceive.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "didnt_receive", comment: "")
        btnResend.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "resend", comment: ""), for: .normal)
        
        
        btnResend.tintColor = getThemeColor()
        btnback.tintColor = getThemeColor()
        
        if isUpdate == true{
            btnResend.isHidden = true
            lblReceive.isHidden = true
        }else{
            btnResend.isHidden = false
            lblReceive.isHidden = false
        }
        
    }
    

    func verifyOtp(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        var  details = [String:Any]()
        details["otp"] = otpRight
        details["user_id"] = userId
        details["fcm_id"] = deviceToken
        
        StylzAPIFacade.shared.verifyOtp(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   saveUserDetails(userDetails: (StylzAPIFacade.shared.session?.currentUser)!)
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
                   vc?.modalPresentationStyle = .fullScreen
                   self.present(vc!, animated: true)
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
    
    func verifyLoginOtp(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        var  details = [String:Any]()
        if isEmail == true{
            details["email_otp"] = otpRight
        }else{
            details["phone_otp"] = otpRight
        }
        
        details["user_id"] = userId
        details["fcm_id"] = deviceToken
        
        StylzAPIFacade.shared.verifyLoginOtp(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   saveUserDetails(userDetails: (StylzAPIFacade.shared.session?.currentUser)!)
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
                   vc?.modalPresentationStyle = .fullScreen
                   self.present(vc!, animated: true)
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
    
    func resendLoginOtp(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        var  details = [String:Any]()
        details["phone"] = self.mobile
        details["user_id"] = self.userId
        
        StylzAPIFacade.shared.sendOtpLogin(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   
                   if let data = aRes?.json?["data"].dictionary{
                       self.otp =  data["otp"]?.stringValue ?? ""
                      // DispatchQueue.main.async {
                          // showAlert(title: self.otp, subTitle: "For testing use this otp", sender: self)
                     //  }
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
    
    func forgotPassword(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

        var details = [String:Any]()
        
        if isEmail == true{
            details["email"] = self.mobile
        }else{
            details["phone"] = self.mobile
        }
        
        details["user_type"] = 3
             
        StylzAPIFacade.shared.forgotPassword(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   
                   if let data = aRes?.json?["data"].dictionary{
                       self.otp =  data["reset_code"]?.stringValue ?? ""
//                       DispatchQueue.main.async {
//                           showAlert(title: self.otp, subTitle: "For testing use this otp", sender: self)
//                       }
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
                            if self.isEmail == true{
                                showAlert(title: "", subTitle:  error["email"]?.stringValue ?? "" , sender: self)

                            }else{
                                showAlert(title: "", subTitle:  error["phone"]?.stringValue ?? "" , sender: self)

                            }

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
    
    func resendOtp(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

        var  details = [String:Any]()
        details["phone"] = self.mobile
        
        StylzAPIFacade.shared.loginPhone(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   
                   if let data = aRes?.json?["data"].dictionary{
                       self.otp =  data["otp"]?.stringValue ?? ""
//                       DispatchQueue.main.async {
//                           showAlert(title: self.otp, subTitle: "For testing use this otp", sender: self)
//                       }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        DispatchQueue.main.async {
//            showAlert(title: self.otp, subTitle: "For testing use this otp", sender: self)
//        }
    }
    
    @IBAction func btnVerify(_ sender: Any) {
        if isPassword == true{
            if self.otp != self.otpRight{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "valid_otp", comment: ""), sender: self)
                return
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.updatePass) as! UpdatePasswordViewController
                vc.userID = self.userId
                vc.otp = self.otpRight
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if isPhoneLogin == true{
            verifyOtp()
        }else{
            verifyLoginOtp()
        }
       
    }
    
    @IBAction func btnResend(_ sender: Any) {
        txtOtp.clearOTP()
        
        if isPassword == true{
            forgotPassword()
        }else if isPhoneLogin == true{
            resendOtp()
        }else{
            
            resendLoginOtp()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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


extension OTPViewController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
        otpRight = code
    }
}

