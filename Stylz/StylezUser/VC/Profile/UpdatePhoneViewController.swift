//
//  UpdatePhoneViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 16/09/23.
//

import UIKit
import StylesWebKit

class UpdatePhoneViewController: UIViewController {

    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnUPdate: UIButton!

    
    var isPhone = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isPhone == true{
            txtPhone.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_phone", comment: "")
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "update_phone", comment: "")
            self.txtPhone.delegate = self
            self.txtPhone.keyboardType = .phonePad
        }else{
            self.txtPhone.delegate = nil
            txtPhone.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_email", comment: "")
            lblHead.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "update_email", comment: "")
            self.txtPhone.keyboardType = .emailAddress
            
            
        }
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtPhone.textAlignment = .right
        }else{
            txtPhone.textAlignment = .left
        }
        
        btnUPdate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "update", comment: ""), for: .normal)
        btnUPdate.backgroundColor = getThemeColor()
        btnBack.tintColor = getThemeColor()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        if txtPhone.text == ""{
            if isPhone == true{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_phone", comment: ""), sender: self)
                return
            }else{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_email", comment: ""), sender: self)
                return
            }
        }
        
        isPhone == true ? updatePhone() : updateEmail()
    }
    
    func updatePhone(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        var  details = [String:Any]()
        details["phone"] = txtPhone.text
        details["user_id"] = StylzAPIFacade.shared.session?.UserId
        
        StylzAPIFacade.shared.updatePhone(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   if let data = aRes?.json?["data"].dictionary{
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.otpView) as! OTPViewController
                       vc.otp =  data["phone_otp"]?.stringValue ?? ""
                       vc.userId =  data["user_id"]?.intValue ?? 0
                       vc.isUpdate = true
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
    
    
    func updateEmail(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        var  details = [String:Any]()
        details["email"] = txtPhone.text
        details["user_id"] = StylzAPIFacade.shared.session?.UserId
        
        StylzAPIFacade.shared.updateEmail(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   if let data = aRes?.json?["data"].dictionary{
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.otpView) as! OTPViewController
                       vc.otp =  data["email_otp"]?.stringValue ?? ""
                       vc.userId =  data["user_id"]?.intValue ?? 0
                       vc.isEmail = true
                       vc.isUpdate = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UpdatePhoneViewController:UITextFieldDelegate{

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
