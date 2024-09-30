//
//  EditProfileViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 20/08/23.
//

import UIKit
import StylesWebKit
import DropDown

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var viewBg: [UIView]!
    @IBOutlet var imgIcons: [UIImageView]!
    @IBOutlet var viewBase: UIView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtAge: UITextField!
    @IBOutlet var txtJob: UITextField!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var btnUpdate: UIButton!
    @IBOutlet var viewUpload: UIView!
    @IBOutlet var txtPAssword: UITextField!
    
    
    @IBOutlet var imgUser: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var imageSelected = false
    var countryId = 0
    var countries = [Countrys]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        for all in viewBg{
        //            all.backgroundColor = getThemeColor()
        //        }
        for all in imgIcons{
            all.tintColor = getThemeColor()
        }
        
        viewUpload.layer.cornerRadius = 15
        viewUpload.layer.masksToBounds = true
        viewUpload.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        viewUpload.layer.borderWidth = 1
        
        txtName.text = getUserDetails()?["first_name"] as? String ?? ""
        txtEmail.text = getUserDetails()?["email"] as? String ?? ""
        txtPhone.text = getUserDetails()?["phone"] as? String ?? ""
        txtCountry.text = getUserDetails()?["country"] as? String ?? ""
        self.countryId = getUserDetails()?["country_id"] as? Int ?? 0
        txtJob.text = getUserDetails()?["occupation"] as? String ?? ""
        txtAge.text = "\(getUserDetails()?["age"] as? Int ?? 0)"
        txtCountry.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
        if getUserDetails()?["image"] as? String == "" || getUserDetails()?["images"] as? String == nil{
            imgUser.image = UIImage(named: "User-icon")
        }else{
            setImage(imageView: imgUser, url: getUserDetails()?["image"] as? String ?? "")
        }

        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profile", comment: "")
        btnUpdate.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "update_profile", comment: ""), for: .normal)
        btnUpdate.backgroundColor = getThemeColor()
        txtName.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "name", comment: "")

        txtCountry.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "nationality", comment: "")
        txtAge.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "age", comment: "")
        txtJob.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "occupation", comment: "")
        txtPAssword.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "change_password", comment: "")
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtName.textAlignment = .right
            txtPhone.textAlignment = .right
            txtEmail.textAlignment = .right
            txtCountry.textAlignment = .right
            txtAge.textAlignment = .right
            txtJob.textAlignment = .right
            txtPAssword.textAlignment = .right
        }else{
            txtName.textAlignment = .left
            txtPhone.textAlignment = .left
            txtEmail.textAlignment = .left
            txtCountry.textAlignment = .left
            txtAge.textAlignment = .left
            txtJob.textAlignment = .left
            txtPAssword.textAlignment = .left
        }
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
                      txtCountry.text = item
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
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
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
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                    }
            }
        }
    }
    
    func updateProfile(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();

        self.view.addSubview(loadingIndicator)

            var profDic = [String:Any]()
            profDic["first_name"] = txtName.text
            profDic["phone"] = txtPhone.text
            profDic["email"] = txtEmail.text
            profDic["country_id"] = self.countryId
            profDic["age"] = self.txtAge.text
            profDic["occupation"] = self.txtJob.text


        if imageSelected == true{
            let resize = resizeImage(image: imgUser.image!, targetSize: CGSize(width: 640, height: 480))
            let fixedImage = resize.fixOrientation()
            if let imgData:Data = fixedImage.pngData() {
                profDic["image"] = imgData
            }
        }
            
        StylzAPIFacade.shared.updateProfile(profDet: profDic) { (aRes) in
                DispatchQueue.main.async {
                    loadingIndicator.removeFromSuperview()
                }
       
            if aRes?.statusCode == 200{
            
                if aRes?.json?["status"].boolValue == true{
               
                    saveUserDetails(userDetails: (StylzAPIFacade.shared.session?.currentUser)!)
                    
                    let alertController = UIAlertController(title: "", message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "profile_updated", comment: "") , preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        
                        self.navigationController?.popViewController(animated: false)
                        
                    }
                
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else{
                    showAlert(title: "", subTitle: aRes?.json?["e_message"].stringValue ?? "" , sender: self)
                }
            }else{
                    showNetworkError(sender: self)
                }
            }
        }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        updateProfile()
    }
    
    @IBAction func btnPassword(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.updatePass) as! UpdatePasswordViewController
        vc.isChangePassword = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.updatePhone) as! UpdatePhoneViewController
        if sender.tag == 0{
            vc.isPhone = true
        }else{
            vc.isPhone = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSelectImage(_ sender: UIButton) {
        
              let alertController = UIAlertController(title: ""
      , message: "", preferredStyle: .actionSheet)
              
              let Camera = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "use_camera", comment: "")
      , style: .default) { action in
                  
                  if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                      self.imagePicker.delegate = self
                      self.imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                      self.imagePicker.allowsEditing = false
                      self.present(self.imagePicker, animated: true, completion: nil)
                      
                  }else{
                      let alert = UIAlertController(title: "" , message: "CameraNotFound", preferredStyle: .alert)
                      let OkButton = UIAlertAction(title: "Ok",style: .cancel) { (alert) -> Void in
                      }
                      alert.addAction(OkButton)
                      self.present(alert, animated: true, completion: nil)
                      
                  }
              }
              
              let Gallery = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "use_gallery", comment: "")
      , style: .default){ action in
                  
                  
                  if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                      
                      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                          self.imagePicker.delegate = self
                          self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                          self.imagePicker.allowsEditing = false
                          self.present(self.imagePicker, animated: true, completion: nil)
                          
                      }            }else
                  {
                      let alert = UIAlertController(title: "", message: "Can'tLocatePhotoLibrary", preferredStyle: .alert)
                      let OkButton = UIAlertAction(title: "Ok",style: .cancel) { (alert) -> Void in
                      }
                      alert.addAction(OkButton)
                      self.present(alert, animated: true, completion: nil)
                      
                  }
                  
                  
              }
              let Cancel = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: "")
      , style: .default)
              alertController.addAction(Camera)
              alertController.addAction(Gallery)
              alertController.addAction(Cancel)
              self.present(alertController, animated: true, completion: nil)
              
        }
      
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          // Local variable inserted by Swift 4.2 migrator.
          let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
          
          if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
               imgUser.image = image
               imageSelected = true
          }
          else if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
           imgUser.image = image
               imageSelected = true
          }
          else{
              print("error")
          }
          picker.dismiss(animated: true, completion: nil);
      }
      
      fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
            return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
        }
        
        // Helper function inserted by Swift 4.2 migrator.
        fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
            return input.rawValue
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
