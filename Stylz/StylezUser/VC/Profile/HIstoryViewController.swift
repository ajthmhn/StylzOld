//
//  HIstoryViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 20/08/23.
//

import UIKit
import StylesWebKit

class HIstoryViewController: UIViewController {

    struct VCConst {
        static let cellId = "history_cell_id"
        static let reORdrcellId = "reOrder_cell_id"
    }
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tblOrders: UITableView!
    @IBOutlet var tblReOrder: UITableView!
    @IBOutlet var lblHead: UILabel!

    
    var orders = [Appointments]()
    var isReORder = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.tintColor = getThemeColor()
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "history", comment: "")
        
        if isReORder == true{
            tblOrders.isHidden = true
            tblReOrder.isHidden = false
        }else{
            tblOrders.isHidden = false
            tblReOrder.isHidden = true

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getOrderHistory()
    }
    
    func getOrderHistory(){
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
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        self.orders.removeAll()
            
        StylzAPIFacade.shared.orderHIstory(profDet: details){ (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{

                    if let data = aRes?.json?["data"].array{
                        for m in data{
                            let booking = Appointments(json: m)
                           self.orders.append(booking)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tblOrders.reloadData()
                        self.tblReOrder.reloadData()
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblOrders.frame.width/2, y: self.tblOrders.frame.height/2, width: self.tblOrders.frame.width, height: 50)

                        if self.orders.count == 0{
                            self.tblOrders.backgroundView = label
                        }else{
                            self.tblOrders.backgroundView = nil
                        }
                    }
                    }else{
                        DispatchQueue.main.async {
                            self.tblOrders.reloadData()
                            
                            let label = UILabel()
                            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                            label.textAlignment = .center
                            label.textColor = UIColor.darkGray
                            label.sizeToFit()
                            label.frame = CGRect(x: self.tblOrders.frame.width/2, y: self.tblOrders.frame.height/2, width: self.tblOrders.frame.width, height: 50)

                            if self.orders.count == 0{
                                self.tblOrders.backgroundView = label
                            }else{
                                self.tblOrders.backgroundView = nil
                            }
                        }
                    }
            }
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension HIstoryViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblReOrder{
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.reORdrcellId) as! SalonListCell

            cell.viewBg.layer.cornerRadius = 20
            cell.viewBg.layer.masksToBounds = true
            cell.viewBg.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewBg.layer.borderWidth = 0.5
            cell.viewBg.dropShadow(color: UIColor.lightGray)
            
//            let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 9.0)!, NSAttributedString.Key.foregroundColor : getThemeColor()]
//            let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor : getThemeColor()]
//            let attributedString1 = NSMutableAttributedString(string:"SAR ", attributes:attrs1 as [NSAttributedString.Key : Any])
//            let attributedString2 = NSMutableAttributedString(string:" \(orders[indexPath.item].service_amount ?? 0.0)", attributes:attrs2 as [NSAttributedString.Key : Any])
//            attributedString1.append(attributedString2)
//            cell.lblPaid.attributedText = attributedString1

                    var name = [String]()
                    for all in orders[indexPath.item].services{
                        name.append(LocalizationSystem.sharedInstance.getLanguage() == "ar" ? all.service_name_ar ?? "" : all.service_name_en ?? "")
                    }

            
            cell.lblService.text = name.joined(separator: ",")
            cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? orders[indexPath.item].salon_name_ar : orders[indexPath.item].salon_name_en
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! SalonListCell
            
            cell.viewBg.layer.cornerRadius = 20
            cell.viewBg.layer.masksToBounds = true
            cell.viewBg.dropShadow(color: UIColor.lightGray)
            
            cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? orders[indexPath.row].salon_name_ar : orders[indexPath.row].salon_name_en
            cell.lblAddress.text = orders[indexPath.row].salon_address
            cell.lblDate.text = "\(orders[indexPath.row].date ?? "") - \(orders[indexPath.row].start_time ?? "")"
            
            switch orders[indexPath.row].appointment_status {
            case 1:
                cell.lblStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "active", comment: "")
                cell.viewStatus[0].backgroundColor = UIColor.systemGreen
                cell.viewStatus[1].backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
                cell.lblStatus.textColor = UIColor.systemGreen
            case 2:
                cell.lblStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelled", comment: "")
                cell.viewStatus[0].backgroundColor = UIColor.red
                cell.viewStatus[1].backgroundColor = UIColor.red.withAlphaComponent(0.3)

                cell.lblStatus.textColor = UIColor.red

            case 3:
                cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "attanded", comment: "")
                cell.viewStatus[0].backgroundColor = UIColor(hexString: "FFBB00")
                cell.viewStatus[1].backgroundColor = UIColor.init(hexString: "FCF2D0")

                cell.lblStatus.textColor =  UIColor(hexString: "FFBB00")
            case 4:
                cell.lblStatus.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "resceduled", comment: "")
                cell.viewStatus[0].backgroundColor = UIColor.systemGreen
                cell.viewStatus[1].backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)

                
                cell.lblStatus.textColor = UIColor.systemGreen
            default:
                cell.lblStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "active", comment: "")
                cell.viewStatus[0].backgroundColor = UIColor.blue
                cell.viewStatus[1].backgroundColor = UIColor.blue.withAlphaComponent(0.3)

                cell.lblStatus.textColor = UIColor.blue
            }
            
            cell.services = orders[indexPath.row].services
            cell.tblService.reloadData()
            cell.tblHeight.constant = CGFloat(orders[indexPath.row].services.count * 30)
            
            if orders[indexPath.row].customer_prepaid == 1{
                cell.lblPaid.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "paid", comment: "")
                cell.viewPaid[0].backgroundColor = UIColor.systemGreen
                cell.viewPaid[1].backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
                cell.lblPaid.textColor = UIColor.systemGreen
            }else{
                cell.lblPaid.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "un_paid", comment: "")
                cell.viewPaid[0].backgroundColor = UIColor.red
                cell.lblPaid.textColor = UIColor.red
                cell.viewPaid[1].backgroundColor = UIColor.red.withAlphaComponent(0.2)
            }
            
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblReOrder{
            return 100
        }else{
            return UITableView.automaticDimension

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let stry = UIStoryboard(name: "Main", bundle: nil)
        let vc = stry.instantiateViewController(withIdentifier: stryBrdId.appointmentDetails) as! AppointmentDetailsViewController
        vc.appointments = self.orders[indexPath.row]
        if tableView == tblReOrder{
            vc.isReorde = true
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
}


extension UIColor {

    var lighterColor: UIColor {
        return lighterColor(removeSaturation: 0.5, resultAlpha: -1)
    }

    func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}

        return UIColor(hue: h,
                       saturation: max(s - val, 0.0),
                       brightness: b,
                       alpha: alpha == -1 ? a : alpha)
    }
}
