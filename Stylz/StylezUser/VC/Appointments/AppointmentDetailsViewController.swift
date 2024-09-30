//
//  AppointmentDetailsViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 15/08/23.
//

import UIKit
import StylesWebKit

class AppointmentDetailsViewController: UIViewController {

    struct VCConst {
        static let cellId = "service_cell_id"
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRescedule: UIButton!

    @IBOutlet var lblHead: UILabel!
    @IBOutlet var lblDateHead: UILabel!
    @IBOutlet var lblTimeHead: UILabel!
    @IBOutlet var lblClientHead: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblCustomerMobile: UILabel!
    @IBOutlet var lblCustomerEmail: UILabel!
    @IBOutlet var imgCustomer: UIImageView!
    @IBOutlet var btnCheckout: UIButton!
    @IBOutlet var bottomHeight: NSLayoutConstraint!

    
    var appointments : Appointments?
    var isReorde = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.tintColor = getThemeColor()
       
        btnCancel.layer.borderColor = UIColor(hexString: "FF3386")?.cgColor
        btnCancel.layer.borderWidth = 1
        btnRescedule.layer.borderColor = UIColor.black.cgColor
        btnRescedule.layer.borderWidth = 1
        btnCheckout.backgroundColor = getThemeColor()
        
        lblDate.text = appointments?.date
        lblTime.text = appointments?.start_time
        lblCustomerName.text = appointments?.customerName
        lblCustomerMobile.text = appointments?.customerPhone
        lblCustomerEmail.text = appointments?.customerEmail
        
        if isReorde == true{
            btnCancel.isHidden = true
            btnRescedule.isHidden = true
            btnCheckout.isHidden = false
            btnCheckout.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "re_order", comment: ""), for: .normal)
            bottomHeight.constant = 60
        }else{
            if appointments?.appointment_status == 1 || appointments?.appointment_status == 4 {
                bottomHeight.constant = 180
                btnCancel.isHidden = false
                btnRescedule.isHidden = false
                btnCheckout.isHidden = false
                btnCheckout.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "go_to_location", comment: ""), for: .normal)
            }else{
                btnCheckout.isHidden = true
                btnCancel.isHidden = true
                btnRescedule.isHidden = true
                bottomHeight.constant = 0
            }
        }
      
        lblClientHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "client", comment: "")

        lblHead.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "appoint_details", comment: "")
        lblDateHead.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "date", comment: "")
        lblTimeHead.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "time", comment: "")
        btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), for: .normal)
        btnRescedule.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "rescedule", comment: ""), for: .normal)

    }
    
    func cancelAppointment(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        StylzAPIFacade.shared.cancelAppointment(id: appointments?.id ?? 0) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   
                   let alertController = UIAlertController(title: "", message:  LocalizationSystem.sharedInstance.localizedStringForKey(key: "appointment_cancel", comment: ""), preferredStyle: .alert)
                               let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "ok", comment: ""), style: UIAlertAction.Style.default) {
                                       UIAlertAction in
                                                self.navigationController?.popViewController(animated: false)
                                   }
                                   alertController.addAction(okAction)
                                   self.present(alertController, animated: true, completion: nil)
                   
                }else{
                    if let error = aRes?.json?["error"].array{
                        if error.count > 0{
                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                        }
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
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
    
    @IBAction func btnCancel(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel_appopint", comment: ""), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: ""), style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                        self.cancelAppointment()
                            
                        }
                        let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "no", comment: ""), style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                        }
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnRescedule(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "rescedule_appopint", comment: ""), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: ""), style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.selectDate) as! SelectDateViewController
                            vc.isRescedule = true
                            vc.appointmentDetails = self.appointments
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "no", comment: ""), style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                        }
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnLocation(_ sender: Any) {
        if isReorde == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.selectDate) as! SelectDateViewController
            vc.appointmentDetails = self.appointments
            vc.isreOrder = true
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            let latDouble = self.appointments?.salon_latitude
            let longDouble = self.appointments?.salon_longitude
                 if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

                     if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble ??  0.0),\(longDouble ?? 0.0)&directionsmode=driving") {
                               UIApplication.shared.open(url, options: [:])
                      }}
                 else {
                        //Open in browser
                     if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble ?? 0.0),\(longDouble ?? 0.0)&directionsmode=driving") {
                                          UIApplication.shared.open(urlDestination)
                                      }
                           }
        }
        
    }
    
    
    
}

extension AppointmentDetailsViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments?.services.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! ServiceListCell
        animationScaleEffectSingle(view: cell)
        cell.selectionStyle = .none
        
        cell.lblName.text = appointments?.services[indexPath.row].employee_first_name
        cell.lblService.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? appointments?.services[indexPath.row].service_name_ar :  appointments?.services[indexPath.row].service_name_en
        cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(appointments?.services[indexPath.row].service_amount ?? "")"
        cell.lblDuration.text = appointments?.services[indexPath.row].service_duration
        setImage(imageView: cell.imgProduct, url: appointments?.services[indexPath.row].employee_image ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
