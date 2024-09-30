//
//  ForgotPasswordViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 24/09/23.
//

import UIKit
import StylesWebKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet var btnTypes: [UIButton]!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var viewBorder: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnSubmit: UIButton!

    @IBOutlet var lblHead: UILabel!

    
    var isEmail = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.tintColor = getThemeColor()
        btnSubmit.backgroundColor = getThemeColor()
        viewBorder.layer.cornerRadius = 10
        viewBorder.layer.masksToBounds = true
        viewBorder.layer.borderWidth = 1
        viewBorder.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        viewBorder.dropShadow(color: UIColor.lightGray)
        self.txtEmail.delegate = self
        
        btnTypes[0].backgroundColor = getThemeColor()
        btnTypes[0].setTitleColor(UIColor.white, for: .normal)
        btnTypes[0].imageView?.tintColor = UIColor.black
       
        btnTypes[1].backgroundColor = UIColor.clear
        btnTypes[1].setTitleColor(UIColor.darkGray, for: .normal)
        btnTypes[1].imageView?.tintColor = UIColor.darkGray
        setLanguage()
    }
    
    func setLanguage(){
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "forgot_pass", comment: "")
        btnTypes[0].setTitle(" \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "email", comment: ""))", for: .normal)
        btnTypes[1].setTitle(" \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "phone", comment: ""))", for: .normal)
        btnSubmit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "submit", comment: ""), for: .normal)
        txtEmail.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_email", comment: "")
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtEmail.textAlignment = .right
        }else{
            txtEmail.textAlignment = .left
        }
    }
    
    
    func forgotPassword(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

        var details = [String:Any]()
        
        if isEmail == true{
            details["email"] = txtEmail.text
        }else{
            details["phone"] = txtEmail.text
        }
        
        details["user_type"] = 3
             
        StylzAPIFacade.shared.forgotPassword(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   
                   if let data = aRes?.json?["data"].dictionary{
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.otpView) as! OTPViewController
                       vc.otp =  data["reset_code"]?.stringValue ?? ""
                       vc.userId =  data["user_id"]?.intValue ?? 0
                       vc.mobile = self.txtEmail.text ?? ""
                       vc.isPassword = true
                       vc.isEmail = self.isEmail
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
    
    @IBAction func btnTypes(_ sender: UIButton) {
        txtEmail.text = ""
        txtEmail.resignFirstResponder()
        if sender.tag == 0{
            btnTypes[0].backgroundColor = getThemeColor()
            btnTypes[0].setTitleColor(UIColor.white, for: .normal)
            btnTypes[0].imageView?.tintColor = UIColor.black
           
            btnTypes[1].backgroundColor = UIColor.clear
            btnTypes[1].setTitleColor(UIColor.darkGray, for: .normal)
            btnTypes[1].imageView?.tintColor = UIColor.darkGray
            self.isEmail = true
            txtEmail.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_email", comment: "")
            txtEmail.keyboardType = .emailAddress
            animationScaleEffectSingle(view: txtEmail)
        }else{
            btnTypes[1].backgroundColor = getThemeColor()
            btnTypes[1].setTitleColor(UIColor.white, for: .normal)
            btnTypes[1].imageView?.tintColor = UIColor.black
           
            btnTypes[0].backgroundColor = UIColor.clear
            btnTypes[0].setTitleColor(UIColor.darkGray, for: .normal)
            btnTypes[0].imageView?.tintColor = UIColor.darkGray
            self.isEmail = false
            txtEmail.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_phone", comment: "")
            txtEmail.keyboardType = .numberPad

            animationScaleEffectSingle(view: txtEmail)
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if txtEmail.text ==  ""{
            return
        }
        self.forgotPassword()
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

extension ForgotPasswordViewController:UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        if isEmail == false{
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
                return  prospectiveText.count <= 9
        }else{
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}

