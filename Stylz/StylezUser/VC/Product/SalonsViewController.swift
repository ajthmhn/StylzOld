//
//  SalonsViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 14/08/23.
//

import UIKit
import StylesWebKit

class SalonsViewController: UIViewController {

    struct VCConst {
        static let salonListCellId = "salon_list_cell_id"
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblSaloons: UITableView!
    @IBOutlet weak var lblHead: UILabel!


    var salons = [Salons]()
    var serviceId = 0
    var isMySalons = false
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.tintColor = getThemeColor()
        if serviceId != 0{
            getServices()
        }else{
           
            if isMySalons == true{
                getMySalons()
            }else{
                let label = UILabel()
                label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                label.textAlignment = .center
                label.textColor = UIColor.darkGray
                label.sizeToFit()
                label.frame = CGRect(x: self.tblSaloons.frame.width/2, y: self.tblSaloons.frame.height/2, width: self.tblSaloons.frame.width, height: 50)

                if self.salons.count == 0{
                    self.tblSaloons.backgroundView = label
                }else{
                    self.tblSaloons.backgroundView = nil
                }
                
            }
        }
    }
    
    func getMySalons(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        self.salons.removeAll()
            
        StylzAPIFacade.shared.mySalons(gender: checkIfNotMale() == true ? 2 : 1) { (aRes) in
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
                        self.tblSaloons.reloadData()
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblSaloons.frame.width/2, y: self.tblSaloons.frame.height/2, width: self.tblSaloons.frame.width, height: 50)
                       
                        if self.salons.count == 0{
                            self.tblSaloons.backgroundView = label
                        }else{
                            self.tblSaloons.backgroundView = nil
                        }
                    }
                    }else{
                        DispatchQueue.main.async {
                            self.tblSaloons.reloadData()
                            let label = UILabel()
                            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                            label.textAlignment = .center
                            label.textColor = UIColor.darkGray
                            label.sizeToFit()
                            label.frame = CGRect(x: self.tblSaloons.frame.width/2, y: self.tblSaloons.frame.height/2, width: self.tblSaloons.frame.width, height: 50)
                           
                            if self.salons.count == 0{
                                self.tblSaloons.backgroundView = label
                            }else{
                                self.tblSaloons.backgroundView = nil
                            }
                        }
                    }
            }else{
                DispatchQueue.main.async {
                    self.tblSaloons.reloadData()
                    let label = UILabel()
                    label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                    label.textAlignment = .center
                    label.textColor = UIColor.darkGray
                    label.sizeToFit()
                    label.frame = CGRect(x: self.tblSaloons.frame.width/2, y: self.tblSaloons.frame.height/2, width: self.tblSaloons.frame.width, height: 50)
                   
                    if self.salons.count == 0{
                        self.tblSaloons.backgroundView = label
                    }else{
                        self.tblSaloons.backgroundView = nil
                    }
                }
            }
        }
    }
    
    func getServices(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        var details = [String:Any]()
        details["service_id"] = serviceId
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        details["latitude"] = latitude
        details["longitude"] = longitude

        self.salons.removeAll()
            
        StylzAPIFacade.shared.top10Salons(profDet: details){ (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{

                    if let data = aRes?.json?["data"].dictionary{
                            if let salons = data["items"]?.array{
                                for m in salons{
                                    let booking = Salons(json: m)
                                   self.salons.append(booking)
                                }
                            }
                    }
                    
                    DispatchQueue.main.async {
                        self.tblSaloons.reloadData()
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblSaloons.frame.width/2, y: self.tblSaloons.frame.height/2, width: self.tblSaloons.frame.width, height: 50)

                        if self.salons.count == 0{
                            self.tblSaloons.backgroundView = label
                        }else{
                            self.tblSaloons.backgroundView = nil
                        }
                        
                    }
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                    }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension SalonsViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.salonListCellId) as! SalonListCell
        cell.lblStar.textColor = getThemeColor()
        cell.imgStar.tintColor = getThemeColor()
        
        cell.viewBg.layer.cornerRadius = 20
        cell.viewBg.layer.masksToBounds = true
        cell.viewBg.layer.borderColor = UIColor.lightGray.cgColor
        cell.viewBg.layer.borderWidth = 1
        
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.service) as! ServiceViewController
        vc.saloonId = salons[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
