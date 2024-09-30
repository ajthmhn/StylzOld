//
//  RegisterViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 14/08/23.
//

import UIKit
import StylesWebKit
import DropDown
import WebKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtNationality: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtOcupation: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblNationality: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblAgree: UILabel!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var viewPolicy: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnClose: UIButton!


    var isAccept = false
    var countryId = -1
    var countries = [Countrys]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnRegister.backgroundColor = getThemeColor()
        btnBack.tintColor = getThemeColor()
        imgCheck.tintColor = getThemeColor()
        getCountry()
       // txtNationality.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtPhone.delegate = self
        setLanguage()
        viewPolicy.isHidden = true
    }
    
    func setLanguage(){
        btnClose.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "close", comment: ""), for: .normal)
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "create_account", comment: "")
       
        lblFullName.attributedText = setAsterist(text: LocalizationSystem.sharedInstance.localizedStringForKey(key: "full_name", comment: ""))
        lblEmail.attributedText = setAsterist(text: LocalizationSystem.sharedInstance.localizedStringForKey(key: "email", comment: ""))
        lblPhone.attributedText = setAsterist(text: LocalizationSystem.sharedInstance.localizedStringForKey(key: "phone", comment: ""))
        
        //lblNationality.attributedText = setAsterist(text: LocalizationSystem.sharedInstance.localizedStringForKey(key: "nationality", comment: ""))
        
        lblNationality.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "nationality", comment: "")
        
        lblAge.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "age", comment: "")
        lblOccupation.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "occupation", comment: "")
        lblPassword.attributedText = setAsterist(text: LocalizationSystem.sharedInstance.localizedStringForKey(key: "password", comment: ""))
        
        let string              = LocalizationSystem.sharedInstance.localizedStringForKey(key: "agree_terms", comment: "")
       
        let range               = (string as NSString).range(of: LocalizationSystem.sharedInstance.localizedStringForKey(key: "policy", comment: ""))
        let attributedString    = NSMutableAttributedString(string: string)

        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.black, range: range)

        lblAgree.attributedText = attributedString

        
       // lblAgree.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "agree_terms", comment: "")
        
        btnCreate.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "create_account", comment: ""), for: .normal)
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtName.textAlignment = .right
            txtEmail.textAlignment = .right
            txtPhone.textAlignment = .right
            txtName.textAlignment = .right
            txtAge.textAlignment = .right
            txtOcupation.textAlignment = .right
            txtPassword.textAlignment = .right
            txtNationality.textAlignment = .right
        }else{
            txtNationality.textAlignment = .left
            txtName.textAlignment = .left
            txtEmail.textAlignment = .left
            txtPhone.textAlignment = .left
            txtName.textAlignment = .left
            txtAge.textAlignment = .left
            txtOcupation.textAlignment = .left
            txtPassword.textAlignment = .left
        }

    }
    
    func setAsterist(text : String) -> NSMutableAttributedString{
        let text = "\(text) *"
        let range = (text as NSString).range(of: "*")
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)

            //Apply to the label
            return  attributedString;
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        let dropDown = DropDown()
        
        if textField.text?.count ?? 0 > 2{
            var names = [Countrys]()
            
            for all in countries{
                let name = all.name?.lowercased()
                let search = textField.text?.lowercased()
                if (name!.contains(search!)){
                    names.append(all)
                }
            }
                  dropDown.anchorView = textField // UIView or UIBarButtonItem
                  var titles = [String]()
                  for all in names{
                      titles.append(all.name ?? "")
                  }
            
                  dropDown.dataSource = titles
                  dropDown.dismissMode = .automatic
                  dropDown.selectRows(at: [countryId])
                  
                  DropDown.appearance().textColor = UIColor.lightGray
                  DropDown.appearance().backgroundColor = UIColor.white
                  DropDown.appearance().selectedTextColor = UIColor.black
                  DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
                  DropDown.appearance().selectionBackgroundColor = UIColor.white
                  DropDown.appearance().cellHeight = 60
                  DropDown.appearance().cornerRadius = 20

                  
                  dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                      txtNationality.text = item
                      countryId = index
                  }
                  dropDown.show()
        }else{
            dropDown.hide()
        }
        
    }
    
    func getCountry(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
            
           self.countries.removeAll()
            
        StylzAPIFacade.shared.getCountry { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{

                                                        if let data = aRes?.json?["data"].array{
                                                            for m in data{
                                                                let booking = Countrys(json: m)
                                                                self.countries.append(booking)
                                                            }
                                                        }
                    print("countries: \(self.countries)")
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                    }
            }
        }
    }
    
    func registerUser(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        var  details = [String:Any]()
        details["password"] = txtPassword.text
        details["email"] = txtEmail.text
        details["first_name"] = txtName.text
        details["phone"] = txtPhone.text
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        if countryId != -1 && self.countries.count > countryId{
            details["country_id"] = self.countries[countryId].id ?? 0
        }
        
        details["age"] = txtAge.text
        details["occupation"] = txtOcupation.text
        
        
        
        print("details: \(details)")
        
        StylzAPIFacade.shared.signUp(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.otpView) as! OTPViewController
                   vc.otp =  aRes?.json?["phone_otp"].stringValue ?? ""
                   vc.userId =  aRes?.json?["user_id"].intValue ?? 0
                   vc.mobile = self.txtPhone.text ?? ""
                   self.navigationController?.pushViewController(vc, animated: false)
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
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCountry(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
            var names = [Countrys]()
            
            for all in countries{
                let name = all.name
                names.append(all)
            }
                  dropDown.anchorView = sender // UIView or UIBarButtonItem
                  var titles = [String]()
                  for all in names{
                      titles.append(all.name ?? "")
                  }
            
                  dropDown.dataSource = titles
                  dropDown.dismissMode = .automatic
                  dropDown.selectRows(at: [countryId])
                  
                  DropDown.appearance().textColor = UIColor.lightGray
                  DropDown.appearance().backgroundColor = UIColor.white
                  DropDown.appearance().selectedTextColor = UIColor.black
                  DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
                  DropDown.appearance().selectionBackgroundColor = UIColor.white
                  DropDown.appearance().cellHeight = 60
                  DropDown.appearance().cornerRadius = 20

                  
                  dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                      txtNationality.text = item
                      countryId = index
                  }
                  dropDown.show()
               
    }
    
    
   
    @IBAction func btnAccept(_ sender: Any) {
        if isAccept == true{
            isAccept = false
            imgCheck.image = UIImage(systemName: "circle")
        }else{
            isAccept = true
            imgCheck.image = UIImage(systemName: "checkmark.circle.fill")
        }
    }
    
    
    @IBAction func btnPrivacy(_ sender: UIButton) {
        if sender.tag == 0{
            viewPolicy.isHidden = false
            animationScaleEffectSingle(view: webView)
            
            let link = URL(string:"https://stylz.me/terms-and-condition.html")!
            let request = URLRequest(url: link)
            webView.load(request)
        }else{
            viewPolicy.isHidden = true
        }
    }
    
    
    @IBAction func btnRegister(_ sender: Any) {
        if txtName.text == ""{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_name", comment: ""), sender: self)
            return
        }else if txtEmail.text == ""{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_email", comment: ""), sender: self)
            return
        }else if txtPhone.text == ""{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "PhoneIsRequired", comment: ""), sender: self)
            return
        }
        
//        else if countryId == -1{
//            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_coutry", comment: ""), sender: self)
//            return
//            
//        }
        
        else if txtPassword.text == ""{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_password", comment: ""), sender: self)
            return
        }
        
        if txtEmail.text != ""{
            let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
            guard emailTest.evaluate(with: txtEmail.text) == true else {
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_valid", comment: ""), sender: self)
                          return
            }
        }
        
        if isAccept == false{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "accept_privacy", comment: ""), sender: self)
            return
        }
        
        registerUser()
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

extension RegisterViewController:UITextFieldDelegate{

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

extension String{
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
}
