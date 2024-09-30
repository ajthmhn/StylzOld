//
//  WelcomeViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 10/08/23.
//

import UIKit
import MapKit

class WelcomeViewController: UIViewController {

    @IBOutlet var lblBg : [UILabel]!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var viewBg: [UIView]!
    @IBOutlet var imgSel : [UIImageView]!
    @IBOutlet var lblHead : UILabel!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setColor(isMale: true)
        
        for all in viewBg{
            all.layer.cornerRadius = 10
            all.layer.masksToBounds = true
        }
        self.locationManager.requestAlwaysAuthorization()
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_gender", comment: "")
    }
    
    func setColor(isMale:Bool){
        if isMale == true{
            lblBg[0].textColor = maleColor
            viewBg[0].layer.borderColor = maleColor?.cgColor
            viewBg[0].layer.borderWidth = 2
            viewBg[0].dropShadow(color: maleColor!)
            
            lblBg[1].textColor = UIColor.black
            viewBg[1].layer.borderWidth = 0
            
            btnSubmit.backgroundColor = maleColor
            imgSel[0].image = UIImage(named: "male_select")
            imgSel[1].image = UIImage(named: "unSelect")

        }else{
            lblBg[1].textColor = femaleColor
            viewBg[1].layer.borderColor = femaleColor?.cgColor
            viewBg[1].layer.borderWidth = 2
            viewBg[0].dropShadow(color: femaleColor!)
            
            lblBg[0].textColor = UIColor.black
            viewBg[0].layer.borderWidth = 0
            
            btnSubmit.backgroundColor = femaleColor
            
            imgSel[1].image = UIImage(named: "female_select")
            imgSel[0].image = UIImage(named: "unSelect")
        }
    }
    
    @IBAction func btnSelect(_ sender: UIButton) {
        if sender.tag == 0{
            setColor(isMale: true)
            isNotMale(value: false)
        }else{
            setColor(isMale: false)
            isNotMale(value: true)
        }
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        isNotFirstTime(value: true)

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)
    }
    
}
