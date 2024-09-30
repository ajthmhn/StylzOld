//
//  AppointmentsViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 15/08/23.
//

import UIKit
import StylesWebKit
import FSCalendar

class AppointmentsViewController: UIViewController {

    struct VCConst {
        static let cellId = "appointMent_cell_id"
    }
   
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var calender: FSCalendar!
    @IBOutlet var tblServicew: UITableView!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var lblHead2: UILabel!
    @IBOutlet var lblNONData: UILabel!

    
    var appointments = [Appointments]()

    var isFromHome = false
    var dates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        if isFromHome == true{
            btnBack.isHidden = false
            btnBack.tintColor = getThemeColor()
        }else{
            btnBack.isHidden = true
        }
        
        calender.select(Date())
        calender.delegate = self
        calender.dataSource = self
        calender.appearance.selectionColor = getThemeColor()

        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "appointment", comment: "")
        lblHead2.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "upcoming_appoint", comment: "")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAppointments()
        DispatchQueue.global(qos: .userInitiated).async {
            self.ghetAllAppointments()
        }
    }
    
    func ghetAllAppointments(){
        dates.removeAll()
        StylzAPIFacade.shared.getAllAppointments(gender: checkIfNotMale() == true ? 2 : 1){ (aRes) in
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                               
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Appointments(json: m)
                                
                                let dateFom = DateFormatter()
                                dateFom.locale = Locale(identifier:"en")
                                dateFom.dateFormat = "yyyy-MM-dd"
                                
                                self.dates.append(dateFom.date(from: booking.date!)!)
                                
                                DispatchQueue.main.async {
                                    self.calender.reloadData()
                                }
                                
                                if self.dates.count == 0{
                                    if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
                                    //    if languageChange == false{
                                            self.calender.transform = CGAffineTransform(scaleX: -1, y: 1);
                                            self.calender.calendarWeekdayView.transform = CGAffineTransform(scaleX: -1, y: 1);
                                        
                                     //   }
                                                let loc = Locale(identifier: "en")
                                                self.calender.locale = loc
                                            }else{
                                                let loc = Locale(identifier: "en")
                                                self.calender.locale = loc
                                            }
                                }else{
                                    let loc = Locale(identifier: "en")
                                    self.calender.locale = loc

                                }
                            }
                    }
                }else{
                }
            }
        }
    }
    
    func getAppointments(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        let date = calender.selectedDate!
        let dateFom = DateFormatter()
        dateFom.locale = Locale(identifier:"en")
        dateFom.dateFormat = "yyyy-MM-dd"
        
        appointments.removeAll()
        
        
        StylzAPIFacade.shared.getAppointments(date:dateFom.string(from: date), gender: checkIfNotMale() == true ? 2 : 1){ (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                               
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Appointments(json: m)
                                self.appointments.append(booking)
                            }
                    }

                }else{
                    
                }
        }
            
            DispatchQueue.main.async {
                self.tblServicew.reloadData()
                if self.appointments.count == 0{
                    self.lblNONData.isHidden = false
                    self.lblNONData.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_appoint", comment: "")
                }else{
                    self.lblNONData.isHidden = true
                }
            }
    }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension AppointmentsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! ServiceListCell
        cell.viewBg.dropShadow(color: UIColor.lightGray)
        
        if appointments.count > 0{
            cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? appointments[indexPath.row].salon_name_ar : appointments[indexPath.row].salon_name_en
    //        var name = [String]()
    //        for all in appointments[indexPath.row].services{
    //            name.append(all.employee_first_name ?? "")
    //        }
            
            cell.lblService.text = appointments[indexPath.row].salon_address
            
            cell.lblDuration.text = "\(appointments[indexPath.row].date ?? "") - \(appointments[indexPath.row].start_time ?? "")"

    //        if appointments[indexPath.row].billDetails.count > 0{
    //            cell.imgPaid.isHidden = true
    //        }else{
    //            cell.imgPaid.isHidden = false
    //        }
            
            cell.btnAdd.tintColor = getThemeColor()
            
            
            if appointments[indexPath.row].customer_prepaid == 1{
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
        }
        

        
        cell.deleteTappedActions { aCell in
            let latDouble = self.appointments[indexPath.row].salon_latitude
            let longDouble = self.appointments[indexPath.row].salon_longitude
                 if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

                     if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble ?? 0.0),\(longDouble ?? 0.0)&directionsmode=driving") {
                               UIApplication.shared.open(url, options: [:])
                      }}
                 else {
                        //Open in browser
                     if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble ?? 0.0),\(longDouble ?? 0.0)&directionsmode=driving") {
                                          UIApplication.shared.open(urlDestination)
                                      }
                           }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.appointmentDetails) as! AppointmentDetailsViewController
        vc.appointments = self.appointments[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AppointmentsViewController:FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
   
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        getAppointments()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if dates.contains(date){
            return 1
        }else{
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {

        if dates.contains(date){
            return [UIColor.black]
        }else{
            return [UIColor.white]
        }
    }
    
    
      
}

