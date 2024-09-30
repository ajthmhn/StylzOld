//
//  SelectDateViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 14/08/23.
//

import UIKit
import FSCalendar
import StylesWebKit

class SelectDateViewController: UIViewController {

    struct VCCont {
        static let cellId = "time_cell_id"
    }
    
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var calender: FSCalendar!
    @IBOutlet var calenderView: UIView!
    @IBOutlet var lblDate: UITextField!
    @IBOutlet var colTimings: UICollectionView!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var lblAvbailable: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    
    var selectedTime = -1
    var isRescedule = false
    var timings = [Timings]()
    var appointmentDetails : Appointments?
    var isreOrder = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCheckout.backgroundColor = getThemeColor()
        btnBack.tintColor = getThemeColor()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        dateFormat.locale  = Locale(identifier: "en")
        lblDate.text = dateFormat.string(from: Date())

        if isreOrder == true{
            btnCheckout.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "re_order", comment: ""), for: .normal)
        }else{
            if isRescedule == true{
                btnCheckout.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "rescedule_appoint", comment: ""), for: .normal)
            }else{
                btnCheckout.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "checkout", comment: ""), for: .normal)
            }
        }
        
        
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_date", comment: "")

        lblAvbailable.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "available_time", comment: "")
        btnCheckout.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "checkout", comment: ""), for: .normal)
        getTimings()
        
        lblDate.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))

        if LocalizationSystem.sharedInstance.getLanguage()  == "ar"{
            lblDate.textAlignment = .right
        }else{
            lblDate.textAlignment = .left
        }
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.lblDate.inputView as? UIDatePicker {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            dateFormat.locale  = Locale(identifier: "en")
            lblDate.text = dateFormat.string(from: datePicker.date)
            
            getTimings()
        }
        self.lblDate.resignFirstResponder()
     }
    
    func unlockTime(id: String){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        
        StylzAPIFacade.shared.unlockTime(id: id){ (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                    self.getTimings()
                }else{
                    if let error = aRes?.json?["error"].array{
                        if error.count > 0{
                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                        }
                    }else{
                        if let error = aRes?.json?["error"].dictionary{
                            showAlert(title: "", subTitle:  error["employee_id"]?.stringValue ?? "" , sender: self)

                        }

                    }
                }
        }
    }
    }
    
    
    func resceduleAppointment(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        StylzAPIFacade.shared.resceduleAppointment(id: appointmentDetails?.id ?? 0, date: lblDate.text ?? "", startTime: timings[selectedTime].start_time ?? "", endTime: timings[selectedTime].end_time ?? "", salonId: appointmentDetails?.salon_id ?? 0) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
           
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   
                       let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.thanks) as! ThanksViewController
                       vc.isRescedule = true
                       self.navigationController?.pushViewController(vc, animated: false)

                   
                }else{
                    if let error = aRes?.json?["error"].array{
                        if error.count > 0{
                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
                        }else{
                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
                        }
                    }else if let error = aRes?.json?["error"].dictionary{
                        showAlert(title: "", subTitle:  error["employee_id"]?.stringValue ?? "" , sender: self)
                    }
                    else{
                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)

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
    
    func getTimings(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        
        var details = [String:Any]()
       
        
        if isRescedule == true  || isreOrder == true{
            var appointment = [[String:Any]]()

            for all in appointmentDetails?.services ?? []{
                var data = [String:Any]()
                data["service_id"] = all.service_id
                data["employee_id"] = all.employee_id
                appointment.append(data)
            }
            
            details["date"] = lblDate.text
            details["appointment_details"] = appointment
            details["branch_id"] = appointmentDetails?.salon_id

        }
        
        else{
            var appointment = [[String:Any]]()
            var branchId = 0
            for all in getCartData()!{
                var data = [String:Any]()
                data["service_id"] = all["service_id"] as? Int
                data["employee_id"] = all["customer_id"] as? Int
                branchId = all["shop_id"] as? Int ?? 0
                appointment.append(data)
            }
            
            details["date"] = lblDate.text
            details["appointment_details"] = appointment
            details["branch_id"] = branchId

        }
        
        timings.removeAll()
     
        selectedTime = -1 // may 16th
        
        StylzAPIFacade.shared.checkAvailability(profDet: details){ (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                               
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Timings(json: m)
                                self.timings.append(booking)
                            }
                    }

                DispatchQueue.main.async {
                   
                    self.colTimings.reloadData()
                    
                    
                    let label = UILabel()
                    label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_time", comment: "")
                    label.textAlignment = .center
                    label.numberOfLines = 2
                    label.textColor = UIColor.darkGray
                    label.sizeToFit()
                    label.frame = CGRect(x: self.colTimings.frame.width/2, y: self.colTimings.frame.height/2, width: self.colTimings.frame.width, height: 50)

                    if self.timings.count == 0{
                        self.colTimings.backgroundView = label
                    }else{
                        self.colTimings.backgroundView = nil
                    }

                }
                    
                }else{
                    let label = UILabel()
                    label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                    label.textAlignment = .center
                    label.textColor = UIColor.darkGray
                    label.sizeToFit()
                    label.frame = CGRect(x: self.colTimings.frame.width/2, y: self.colTimings.frame.height/2, width: self.colTimings.frame.width, height: 50)

                    if self.timings.count == 0{
                        self.colTimings.backgroundView = label
                    }else{
                        self.colTimings.backgroundView = nil
                    }

                }
            }else{
                let label = UILabel()
                label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                label.textAlignment = .center
                label.textColor = UIColor.darkGray
                label.sizeToFit()
                label.frame = CGRect(x: self.colTimings.frame.width/2, y: self.colTimings.frame.height/2, width: self.colTimings.frame.width, height: 50)

                if self.timings.count == 0{
                    self.colTimings.backgroundView = label
                }else{
                    self.colTimings.backgroundView = nil
                }
            }
    }
    }
    
    @IBAction func btnCalenderShow(_ sender: Any) {
        Bundle.main.loadNibNamed("CalenderView", owner: self)
        btnDone.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), for: .normal)

        btnCancel.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), for: .normal)

        
        self.calenderView.frame = self.view.bounds
        self.view.addSubview(self.calenderView)
        self.view.bringSubviewToFront(self.calenderView)
        self.calender.select(Date())
        animationScaleEffectSingle(view: self.calender)
        self.calender.delegate = self
        
                        calender.semanticContentAttribute = .forceLeftToRight
                        calender.calendarWeekdayView.semanticContentAttribute = .forceLeftToRight
                        calender.calendarHeaderView.semanticContentAttribute = .forceLeftToRight

        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            if languageChange == true{
//                calender.semanticContentAttribute = .forceLeftToRight
//                calender.calendarWeekdayView.semanticContentAttribute = .forceLeftToRight
//                calender.calendarHeaderView.semanticContentAttribute = .forceLeftToRight
//                
//               self.calender.transform = CGAffineTransform(scaleX: 1, y: -1);
//                self.calender.calendarWeekdayView.transform = CGAffineTransform(scaleX: 1, y: -1);
//                calender.calendarHeaderView.transform  = CGAffineTransform(scaleX: 1, y: -1);

            }
                

                    let loc = Locale(identifier: "en")
                    self.calender.locale = loc
                }else{
                    let loc = Locale(identifier: "en")
                    self.calender.locale = loc
                }

        
    }
    
    @IBAction func btnCalenderActions(_ sender: UIButton) {
        if sender.tag == 1{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            dateFormat.locale  = Locale(identifier: "en")
            lblDate.text = dateFormat.string(from: self.calender.selectedDate ?? Date())
            
            getTimings()
        }
        self.calenderView.removeFromSuperview()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        if timings.count == 0{
            return
        }
            
        if selectedTime == -1{
            showAlert(title: "", subTitle: "Please select a time", sender: self)
            return
        }
        
        if isreOrder == true{
            if isRescedule == true{
                self.resceduleAppointment()
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.summary) as! SummeryViewController
                vc.date = self.lblDate.text ?? ""
                vc.time = self.timings[selectedTime].start_time ?? ""
                vc.dateView = self
                vc.isReorde = true
                vc.appointments = self.appointmentDetails
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if isRescedule == true{
                self.resceduleAppointment()
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.summary) as! SummeryViewController
                vc.date = self.lblDate.text ?? ""
                vc.time = self.timings[selectedTime].start_time ?? ""
                vc.dateView = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        

    }
    
}

extension SelectDateViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  timings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCCont.cellId, for: indexPath) as! CategColCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.lblItem.text = timings[indexPath.item].formatted_start_time
        
        if selectedTime == indexPath.item{
            animationScaleEffectSingle(view: cell)
            cell.lblItem.textColor = UIColor.white
            cell.backgroundColor = getThemeColor()
            cell.layer.borderWidth = 0
        }else{
            cell.lblItem.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 10, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTime = indexPath.item
        collectionView.reloadData()
    }
}

extension SelectDateViewController:FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool
    {
        let threeDays = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let day = Calendar.current.date(byAdding: .day, value: 1, to: date)
        
        if day! < threeDays!{
            return false
        }else{
            return true
        
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let threeDays = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let day = Calendar.current.date(byAdding: .day, value: 1, to: date)
     
        
        if day! < threeDays!{
            return UIColor.gray
        }else{
            return UIColor.black
        }
    }
}


extension UITextField {

  func addInputViewDatePicker(target: Any, selector: Selector) {

   let screenWidth = UIScreen.main.bounds.width

   //Add DatePicker as inputView
   let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
      let loc = Locale(identifier: "en_US")
      datePicker.locale = loc

      
   datePicker.datePickerMode = .date
      datePicker.minimumDate = Date()
   self.inputView = datePicker
    datePicker.preferredDatePickerStyle = .wheels

   //Add Tool Bar as input AccessoryView
   let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
   let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
   let cancelBarButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: .plain, target: self, action: #selector(cancelPressed))
   let doneBarButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), style: .plain, target: target, action: selector)
   toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

   self.inputAccessoryView = toolBar
}

  @objc func cancelPressed() {
    self.resignFirstResponder()
  }
}
