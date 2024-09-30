//
//  ShopsViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 13/08/23.
//

import UIKit
import StylesWebKit

class ShopsViewController: UIViewController {
   
    struct VCConst {
        static let barbersListCellId = "barber_list_cell_id"
    }

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblSalons: UITableView!
    @IBOutlet weak var lblHead: UILabel!


    var categoryId = 0
    var name = ""
    var salons = [Salons]()
    var isFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.tintColor = getThemeColor()
        if isFromHome == true{
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "all_barber", comment: "")
            
            self.tblSalons.reloadData()
            let label = UILabel()
            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
            label.textAlignment = .center
            label.textColor = UIColor.darkGray
            label.sizeToFit()
            label.frame = CGRect(x: self.tblSalons.frame.width/2, y: self.tblSalons.frame.height/2, width: self.tblSalons.frame.width, height: 50)
           
            if self.salons.count == 0{
                self.tblSalons.backgroundView = label
            }else{
                self.tblSalons.backgroundView = nil
            }
            
        }else{
            if latitude == 0.0{
                let label = UILabel()
                label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                label.textAlignment = .center
                label.textColor = UIColor.darkGray
                label.sizeToFit()
                label.frame = CGRect(x: self.tblSalons.frame.width/2, y: self.tblSalons.frame.height/2, width: self.tblSalons.frame.width, height: 50)
               
                self.tblSalons.backgroundView = label
            }else{
                getShops()
                if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
                    lblHead.text = "متجر لل \(name)"
                }else{
                    lblHead.text = "Shop for \(name)"
                }
            }
           
            
        }
       
        
        
    }
    

    
    @IBAction func btnREquestLocation(_ sender: UISwitch) {
        if let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func getShops(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        var details = [String:Any]()
        details["category_id"] = categoryId
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        details["latitude"] = latitude
        details["longitude"] = longitude

        self.salons.removeAll()
            
        StylzAPIFacade.shared.getBranches(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{

                    if let salons = aRes?.json?["data"].array{
                        for m in salons{
                            let booking = Salons(json: m)
                            self.salons.append(booking)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tblSalons.reloadData()
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblSalons.frame.width/2, y: self.tblSalons.frame.height/2, width: self.tblSalons.frame.width, height: 50)
                       
                        if self.salons.count == 0{
                            self.tblSalons.backgroundView = label
                        }else{
                            self.tblSalons.backgroundView = nil
                        }
                    }
                    }else{
                        DispatchQueue.main.async {
                            self.tblSalons.reloadData()
                            let label = UILabel()
                            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                            label.textAlignment = .center
                            label.textColor = UIColor.darkGray
                            label.sizeToFit()
                            label.frame = CGRect(x: self.tblSalons.frame.width/2, y: self.tblSalons.frame.height/2, width: self.tblSalons.frame.width, height: 50)
                           
                            if self.salons.count == 0{
                                self.tblSalons.backgroundView = label
                            }else{
                                self.tblSalons.backgroundView = nil
                            }
                        }
                    }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension ShopsViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.barbersListCellId) as! SalonListCell
        cell.lblStar.textColor = getThemeColor()
        cell.imgStar.tintColor = getThemeColor()
        
        cell.viewBg.dropShadow(color: UIColor.lightGray)
        cell.viewBg.layer.cornerRadius = 20
        cell.viewBg.layer.masksToBounds = true
        
        cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? salons[indexPath.row].name_ar :  salons[indexPath.row].name_en
        cell.lblStar.text = "\(salons[indexPath.row].salon_rating ?? 0.0)"
        cell.lblAddress.text = salons[indexPath.row].invoice_address
        if salons[indexPath.row].salon_images.count > 0{
            setImage(imageView: cell.imgshop, url: salons[indexPath.row].salon_images[0] )
        }else{
            cell.imgshop.image = UIImage(named: "test_2")
        }
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.service) as! ServiceViewController
        vc.saloonId = salons[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
}


