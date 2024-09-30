//
//  ProfileViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 16/08/23.
//

import UIKit
import StylesWebKit

class ProfileViewController: UIViewController {

    @IBOutlet var imgTypes: [UIImageView]!
    @IBOutlet var viewLogin: [UIView]!
    @IBOutlet var lblSignout: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet var lblAccountHead: UILabel!
    @IBOutlet var lblSettingsHead: UILabel!
    @IBOutlet var lblProfile: UILabel!
    @IBOutlet var lblWallet: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblHistory: UILabel!
    @IBOutlet var lblNOtifications: UILabel!
    @IBOutlet var lblGenderHead: UILabel!
    @IBOutlet var lblLanguageHead: UILabel!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblLanguage: UILabel!

    @IBOutlet var lblAccountDelete: UILabel!

    @IBOutlet var imgArrow: [UIImageView]!
    @IBOutlet var imgLogout: UIImageView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...imgTypes.count - 1 {
            if checkIfNotMale() == true{
                imgTypes[i].image = UIImage(named: "profile_female_\(i)")
            }else{
                imgTypes[i].image = UIImage(named: "profile_male_\(i)")
            }
        }
        
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            if checkIfNotMale() == true{
                imgTypes[6].image = UIImage(named: "profile_female_7")
            }else{
                imgTypes[6].image = UIImage(named: "profile_male_7")
            }
        }
        
        for all in imgArrow{
            if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
                all.image = UIImage(systemName: "chevron.left")
            }else{
                all.image = UIImage(systemName: "chevron.right")
            }
            
        }
        if getUserDetails() == nil{
            for all in viewLogin{
                all.isHidden = true
            }
            lblSignout.textColor = UIColor.systemGreen
            imgLogout.image = UIImage(named: "log_in")
            lblSignout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "sign_in", comment: "")
        }else{
            for all in viewLogin{
                all.isHidden = false
            }
            lblSignout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "sign_out", comment: "")
            lblSignout.textColor = UIColor.red
            imgLogout.image = UIImage(named: "log_out")
            lblPhone.text = "+966 \(getUserDetails()?["phone"] as? String ?? "")"

        }
        
        setLanguage()
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            lblLanguage.text = "العربية"
        }else{
            lblLanguage.text = "English"
        }
        
        if checkIfNotMale() == true{
            lblGender.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "female", comment: "")
        }else{
            lblGender.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "male", comment: "")
        }
    }
    
    
    func setLanguage(){
       
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profile", comment: "")
        lblAccountHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "my_account", comment: "")
        lblSettingsHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "settings", comment: "")
        lblProfile.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profile", comment: "")
        lblWallet.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "wallet", comment: "")
        lblAddress.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "address", comment: "")
        lblHistory.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "order_history", comment: "")
        lblNOtifications.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "notifications", comment: "")
        lblGenderHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "gender", comment: "")
        lblLanguageHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "language", comment: "")

        lblAccountDelete.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "DeleteAccount", comment: "")
    }
    
    
    @IBAction func btnSelect(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.editProfile) as! EditProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let stry = UIStoryboard(name: "Profile", bundle: nil)
            let vc = stry.instantiateViewController(withIdentifier:  stryBrdId.address) as! AddressViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let stry = UIStoryboard(name: "Main", bundle: nil)
            let vc = stry.instantiateViewController(withIdentifier:  stryBrdId.wallet) as! WalletViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let stry = UIStoryboard(name: "Profile", bundle: nil)
            let vc = stry.instantiateViewController(withIdentifier:  stryBrdId.history) as! HIstoryViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let stry = UIStoryboard(name: "Profile", bundle: nil)
            let vc = stry.instantiateViewController(withIdentifier:  stryBrdId.notifications) as! NotificationsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 5,6:
            let stry = UIStoryboard(name: "Profile", bundle: nil)
            let vc = stry.instantiateViewController(withIdentifier:  stryBrdId.options) as! SelectOptionsViewController
            vc.modalPresentationStyle = .popover
            if sender.tag == 5{
                vc.isGender = true
            }else{
                vc.isGender = false
            }
            self.present(vc, animated: true)
        case 7:
            if getUserDetails() == nil{
                let stry = UIStoryboard(name: "Main", bundle: nil)
                let vc = stry.instantiateViewController(withIdentifier:  stryBrdId.login) as! LoginViewController
                vc.isFromProfile = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                StylzAPIFacade.shared.logout { ares in
                    
                }
                clearCart()
                deleteUserDetails()
                StylzAPIFacade.shared.resetSession()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true)
            }
            
        case 8:
            showDeleteAccountAlert()
            
        default:
            print("")
            
        }
    }
}


//MARK: - Delete account

extension ProfileViewController{
    
    func showDeleteAccountAlert(){
        
     
        let confirm = LocalizationSystem.sharedInstance.localizedStringForKey(key: "confirm", comment: "")
        let cancel = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: "")
        let areYouSure = LocalizationSystem.sharedInstance.localizedStringForKey(key: "YouSure", comment: "")
        let youWantToDeleteAcc = LocalizationSystem.sharedInstance.localizedStringForKey(key: "WantToDelete", comment: "")
        let alertTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: "DeleteAccount2", comment: "")
     
        
      
        let alertController = UIAlertController(title: alertTitle, message: youWantToDeleteAcc, preferredStyle: UIAlertController.Style.alert)
  
        let okAction = UIAlertAction(title: confirm, style: UIAlertAction.Style.destructive) {
            (result : UIAlertAction) -> Void in
        
            self.deleteAcc()
            
        }
        
        let deleteAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.default) {
             (result : UIAlertAction) -> Void in
             print("OK")
         }
        
         alertController.addAction(okAction)
         alertController.addAction(deleteAction)
        
         self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAcc(){

        //let accDeleted = LocalizationSystem.sharedInstance.localizedStringForKey(key: "DeletedMsg", comment: "")
         StylzAPIFacade.shared.deleteAccount { ares in
            print("acc deleted: \(ares?.json?["message"])")
        }
        
        clearCart()
        deleteUserDetails()
        StylzAPIFacade.shared.resetSession()
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
}
