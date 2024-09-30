//
//  NotificationsViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 20/08/23.
//

import UIKit
import StylesWebKit

class NotificationsViewController: UIViewController {

    struct VCConst {
        static let cellId = "notifications_cell_id"
    }
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tblNotif: UITableView!
    @IBOutlet var lblHead: UILabel!

    
    var notifications = [NOtifications]()
    var page = 1
    var isDataLoading = true
    var dataEmpty = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        btnBack.tintColor = getThemeColor()
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "notifications", comment: "")
    }
    
    func getData(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        if self.page == 1 {
            self.view.addSubview(loadingIndicator)
            self.notifications.removeAll()
        }
      //  appointments.removeAll()
        
        StylzAPIFacade.shared.getNotifications(page: self.page, gender: checkIfNotMale() == true ? 2 : 1 ){ (aRes) in

            self.isDataLoading = false

            
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                               
                    if let data = aRes?.json?["results"].array{
                        if data.count == 0{
                                               self.dataEmpty = true
                                           }else{
                                               self.dataEmpty = false
                                           }
                        
                            for m in data{
                                let booking = NOtifications(json: m)
                               self.notifications.append(booking)
                            }

                    }

                    DispatchQueue.main.async {
                        self.tblNotif.reloadData()
                        
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblNotif.frame.width/2, y: self.tblNotif.frame.height/2, width: self.tblNotif.frame.width, height: 50)

                        if self.notifications.count == 0{
                            self.tblNotif.backgroundView = label
                        }else{
                            self.tblNotif.backgroundView = nil
                        }
                    }

               
                
                
            }else{
                DispatchQueue.main.async {
                    self.tblNotif.reloadData()
                    
                    
                    let label = UILabel()
                    label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                    label.textAlignment = .center
                    label.textColor = UIColor.darkGray
                    label.sizeToFit()
                    label.frame = CGRect(x: self.tblNotif.frame.width/2, y: self.tblNotif.frame.height/2, width: self.tblNotif.frame.width, height: 50)

                    if self.notifications.count == 0{
                        self.tblNotif.backgroundView = label
                    }else{
                        self.tblNotif.backgroundView = nil
                    }
                }
            }
    }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension NotificationsViewController : UITableViewDataSource, UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
               let contentOffsetX = scrollView.contentOffset.y
               if contentOffsetX >= (scrollView.contentSize.height - scrollView.bounds.height) - 20 /* Needed offset */ {
                 if !isDataLoading {
                             isDataLoading = true
                       page += 1
                   if self.dataEmpty == false{
                       self.getData()
                   }
                   }
                 }
               }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! ServiceListCell
        if page == 1{
            animationScaleEffectSingle(view: cell)
        }
        
        cell.dropShadow(color: UIColor.lightGray)
        cell.viewBg.dropShadow(color: UIColor.lightGray)
        cell.viewBg.layer.cornerRadius = 20
        cell.viewBg.layer.masksToBounds = true
        cell.lblName.text =  notifications[indexPath.row].title
        let dateFor = DateFormatter()
        dateFor.locale = Locale(identifier:"en")
        dateFor.dateFormat = "d/MMM/yyyy h:mm a"

        let date = dateFor.date(from: notifications[indexPath.row].created_at!)
        
        dateFor.dateFormat = "MMM d"
        let dates =  dateFor.string(from: date!)
        
        cell.lblDuration.text = dates.replacingOccurrences(of: " ", with: "\n")
        
        dateFor.dateFormat = "h:mm a"
        
        cell.lblPrice.text =  dateFor.string(from: date!)
             
        if indexPath.row % 2 == 0{
            cell.viewNot.backgroundColor = UIColor(hexString: "61AB9A")?.withAlphaComponent(0.1)
            cell.lblDuration.textColor = UIColor(hexString: "61AB9A")
        }else{
            cell.viewNot.backgroundColor = UIColor(hexString: "168BCC")?.withAlphaComponent(0.1)
            cell.lblDuration.textColor = UIColor(hexString: "168BCC")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
