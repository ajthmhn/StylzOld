//
//  SelectOptionsViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 20/08/23.
//

import UIKit
import IQKeyboardManagerSwift

class SelectOptionsViewController: UIViewController {

    
    @IBOutlet var viewGender: [UIView]!
    @IBOutlet var viewLanguage: [UIView]!
    @IBOutlet var imgLanguage: [UIImageView]!
    @IBOutlet var imgGender: [UIImageView]!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var lblMale: UILabel!
    @IBOutlet var lblFemale: UILabel!


    @IBOutlet var viewGenderBase: [UIView]!
    @IBOutlet var viewLanguageBase: [UIView]!
    @IBOutlet var btnSelect: UIButton!

    
    var isGender = false
    var isFemale = false
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFemale =  checkIfNotMale()
        btnSelect.backgroundColor = getThemeColor()
        btnSelect.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "update", comment: ""), for: .normal)
        lblMale.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "male", comment: "")
        lblFemale.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "female", comment: "")

        
        for all in imgGender{
            all.image = UIImage(named: "circle_unsel")
            all.layer.cornerRadius = 20
            all.layer.masksToBounds = true

        }
        
        if isGender == true{
            for all in viewGenderBase{
                all.isHidden = false
            }
            for all in viewLanguageBase{
                all.isHidden = true
            }
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "selct_gender", comment: "")
            
            
            for all in viewGender{
                all.layer.borderWidth = 1
                all.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
                all.layer.cornerRadius = 20
                all.layer.masksToBounds = true
            }
            
            
            if checkIfNotMale() == true{
                imgGender[1].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
                viewGender[1].layer.borderWidth = 1
                viewGender[1].layer.borderColor = getThemeColor().cgColor

            }else{
                imgGender[0].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
                viewGender[0].layer.borderWidth = 1
                viewGender[0].layer.borderColor = getThemeColor().cgColor


            }
        }else{
            for all in viewGenderBase{
                all.isHidden = true
            }
            for all in viewLanguageBase{
                all.isHidden = false
            }
            
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_language", comment: "")
            
            
            for all in viewLanguage{
                all.layer.borderWidth = 1
                all.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
                all.layer.cornerRadius = 20
                all.layer.masksToBounds = true
            }
            
            
            if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
                imgLanguage[0].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
                viewLanguage[0].layer.borderWidth = 1
                viewLanguage[0].layer.borderColor = getThemeColor().cgColor
                tag = 0
            }else{
                imgLanguage[1].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
                viewLanguage[1].layer.borderWidth = 1
                viewLanguage[1].layer.borderColor = getThemeColor().cgColor
                tag = 1
            }
        }
        

        
        
        
       
        
        
        
    }
    

    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnGender(_ sender: UIButton) {
        clearCart()

        for all in viewGender{
            all.layer.borderWidth = 1
            all.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            all.layer.cornerRadius = 20
            all.layer.masksToBounds = true
        }
        
        for all in imgGender{
            all.image = UIImage(named: "circle_unsel")
        }
        
        if sender.tag == 0{
            isFemale = false
            
            imgGender[sender.tag].image = UIImage(named: "circle_sel_boy")
            viewGender[sender.tag].layer.borderWidth = 1
            viewGender[sender.tag].layer.borderColor = maleColor?.cgColor
            btnSelect.backgroundColor = maleColor

        }else{
            isFemale = true
            
            imgGender[sender.tag].image = UIImage(named: "circle_sel_girl")
            viewGender[sender.tag].layer.borderWidth = 1
            viewGender[sender.tag].layer.borderColor = femaleColor?.cgColor
            btnSelect.backgroundColor = femaleColor

        }
        
        
    }
    
    @IBAction func btnLanguage(_ sender: UIButton) {
        
        for all in viewLanguage{
            all.layer.borderWidth = 1
            all.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            all.layer.cornerRadius = 20
            all.layer.masksToBounds = true
        }
        
        for all in imgLanguage{
            all.image = UIImage(named: "circle_unsel")
        }
        
        
        imgLanguage[sender.tag].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
        viewLanguage[sender.tag].layer.borderWidth = 1
        viewLanguage[sender.tag].layer.borderColor = getThemeColor().cgColor
        languageChange = true
        tag = sender.tag
        
    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        isNotMale(value: isFemale)
        
        if languageChange == true{
            if tag == 0{
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
                IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "تم"
            }else{
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
                IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
            }
        }
        
        UIView.appearance().semanticContentAttribute =   LocalizationSystem.sharedInstance.getLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight

        
        let stry = UIStoryboard(name: "Main", bundle: nil)
        let vc = stry.instantiateViewController(withIdentifier: "root_vc")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    


}
