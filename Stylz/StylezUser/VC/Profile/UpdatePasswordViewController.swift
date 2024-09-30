//
//  UpdatePasswordViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 24/09/23.
//

import UIKit
import StylesWebKit

class UpdatePasswordViewController: UIViewController {

    @IBOutlet var viewBorder: [UIView]!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirm: UITextField!
    @IBOutlet var txtOldPass: UITextField!
    @IBOutlet var viewOld: UIView!

    @IBOutlet var lblHead: UILabel!


    var otp = ""
    var userID = 0
    var isChangePassword = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.tintColor = getThemeColor()
        btnSubmit.backgroundColor = getThemeColor()
        for all in viewBorder{
            all.layer.cornerRadius = 10
            all.layer.masksToBounds = true
            all.layer.borderWidth = 1
            all.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            all.dropShadow(color: UIColor.lightGray)

        }
        setLanguage()
        
        if isChangePassword == true{
            self.viewOld.isHidden = false
        }else{
            self.viewOld.isHidden = true
        }
    }
    
    func setLanguage(){
        if isChangePassword == true{
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "change_password", comment: "")

        }else{
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "update_pass", comment: "")

        }
        txtPassword.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "new_password", comment: "")
        txtConfirm.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "confirm_password", comment: "")
        txtOldPass.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "old_password", comment: "")

        btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "update", comment: ""), for: .normal)
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtPassword.textAlignment = .right
            txtConfirm.textAlignment = .right
            txtOldPass.textAlignment = .right
        }else{
            txtPassword.textAlignment = .left
            txtConfirm.textAlignment = .left
            txtOldPass.textAlignment = .left
        }
    }
    
    func updatePassword(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

        var details = [String:Any]()
        details["reset_code"] = self.otp
        details["user_id"] = self.userID
        details["password"] = self.txtPassword.text

        StylzAPIFacade.shared.updatePassword(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   
                       
                       showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "password_updated", comment: ""), view: self.view)
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                           for aViewController in viewControllers {
                               if aViewController is LoginViewController {
                                   self.navigationController!.popToViewController(aViewController, animated: true)
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
                        if let error = aRes?.json?["error"].dictionary{
                            showAlert(title: "", subTitle:  error["email"]?.stringValue ?? "" , sender: self)
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
    
    func changePassword(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

        var details = [String:Any]()
        details["old_password"] = self.txtOldPass.text
        details["new_password"] = self.txtPassword.text

        StylzAPIFacade.shared.changePassword(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                       showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "password_updated", comment: ""), view: self.view)
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           self.navigationController?.popViewController(animated: true)
                       }
                   
                }else{
                    showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)

                }
            }else{
                showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)

                }
            }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        if isChangePassword == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if txtPassword.text ==  ""{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_pass", comment: ""), sender: self)
            return
        }else if txtPassword.text != txtConfirm.text{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "password_missmatch", comment: ""), sender: self)
            return
        }
        
        if isChangePassword == true{
            if txtOldPass.text ==  ""{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_current", comment: ""), sender: self)
                return
            }
            changePassword()
        }else{
            updatePassword()
        }
    }
    
    
    @IBAction func btnEye(_ sender: UIButton) {
        if sender.tag == 0{
            if txtOldPass.isSecureTextEntry == true{
                txtOldPass.isSecureTextEntry = false
                sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }else{
                txtOldPass.isSecureTextEntry = true
                sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            }
        }else if sender.tag == 1{
            if txtPassword.isSecureTextEntry == true{
                txtPassword.isSecureTextEntry = false
                sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }else{
                txtPassword.isSecureTextEntry = true
                sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            }
        }else{
            if txtConfirm.isSecureTextEntry == true{
                txtConfirm.isSecureTextEntry = false
                sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }else{
                txtConfirm.isSecureTextEntry = true
                sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            }
        }
        
    }
}
