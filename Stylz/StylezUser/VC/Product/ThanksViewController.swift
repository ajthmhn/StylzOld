//
//  ThanksViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 14/08/23.
//

import UIKit

class ThanksViewController: UIViewController {

    @IBOutlet weak var btnCotinue: UIButton!
    @IBOutlet  var viewCol: [UIView]!
    @IBOutlet  var lblSub: UILabel!
    @IBOutlet  var lblHead: UILabel!

    var isRescedule = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isRescedule == true{
            lblSub.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "appointment_resceduled", comment: "")
        }else{
            clearCart()
            lblSub.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "for_booking", comment: "")
        }
        
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "thank_you", comment: "")
        btnCotinue.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "back_service", comment: ""), for: .normal)
        
        btnCotinue.backgroundColor = getThemeColor()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animationScaleEffect(view: viewCol)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true)

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
