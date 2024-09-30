//
//  AddressViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 20/08/23.
//

import UIKit
import StylesWebKit

class AddressViewController: UIViewController {

    struct VCConst {
        static let cellId = "address_cell_id"
    }
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tblAddress: UITableView!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var btnAddress: UIButton!

    var addressList = [Addresss]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.tintColor = getThemeColor()
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "address", comment: "")
        btnAddress.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_address", comment: ""), for: .normal)
        btnAddress.backgroundColor = getThemeColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }
    
    func deleteAddress(id :Int ){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

                           
        StylzAPIFacade.shared.deleteAddress(id: id) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                    self.getData()
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
    
    func getData(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        self.addressList.removeAll()


    
        
      //  appointments.removeAll()
        
        StylzAPIFacade.shared.addressList{ (aRes) in

            
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                               
                    if let data = aRes?.json?["data"].array{
                      
                        
                            for m in data{
                                let booking = Addresss(json: m)
                               self.addressList.append(booking)
                            }

                    }

                    DispatchQueue.main.async {
                        self.tblAddress.reloadData()


                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblAddress.frame.width/2, y: self.tblAddress.frame.height/2, width: self.tblAddress.frame.width, height: 50)

                        if self.addressList.count == 0{
                            self.tblAddress.backgroundView = label
                        }else{
                            self.tblAddress.backgroundView = nil
                        }
                    }                
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnAdd(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.addAddress) as! AddAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
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

extension AddressViewController : UITableViewDataSource, UITableViewDelegate{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! ServiceListCell
        
        cell.viewBg.layer.cornerRadius = 20
        cell.viewBg.layer.masksToBounds = true
        cell.viewBg.dropShadow(color: UIColor.lightGray)
        
        cell.lblName.text  = addressList[indexPath.row].nick_name
        cell.imgStar.image = checkIfNotMale() == true ?  UIImage(named: "address_list_girl") : UIImage(named: "address_list")
        cell.deleteTappedActions { aCell in
            let alertController = UIAlertController(title: "", message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "delete_address", comment: ""), preferredStyle: .alert)
                        let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: ""), style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                
                            self.deleteAddress(id: self.addressList[indexPath.row].id ?? 0)
                                
                            }
                            let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "no", comment: ""), style: UIAlertAction.Style.cancel) {
                                UIAlertAction in
                            }
                            alertController.addAction(okAction)
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true, completion: nil)
           
                
        }
            
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
