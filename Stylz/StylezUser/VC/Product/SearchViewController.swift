//
//  SearchViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 17/09/23.
//

import UIKit
import StylesWebKit



class SearchViewController: UIViewController, UITextFieldDelegate {

    struct VCConst {
        static let emplyeeCellId = "employee_cell_id"
        static let salonsCellId = "salon_list_cell_id"
        static let serviceCellId = "service_cell_id"
        static let stylistCellId = "barber_cell_id"
    }
    
    
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var tblSearch: UITableView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var viewCart: UIView!
    @IBOutlet var lblCart: UILabel!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var bottomSpace: NSLayoutConstraint!
    @IBOutlet var bottomSpaceEmployee: NSLayoutConstraint!

    @IBOutlet var lblHead: UILabel!
    @IBOutlet var colStylists: UICollectionView!

    
    var employeeList = [Employee]()
    var serviceList = [Services]()
    var salons = [Salons]()
    var isStylist = false
    var keyWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSearch.delegate = self
        btnBack.tintColor = getThemeColor()
        if isStylist == false{
            getData()
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: "")
            txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search_hair", comment: "")
            colStylists.isHidden = true
            tblSearch.isHidden = false
        }else{
            lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "stylist", comment: "")
            txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: "")
            colStylists.isHidden = false
            tblSearch.isHidden = true

        }
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtSearch.textAlignment = .right
        }else{
            txtSearch.textAlignment = .left
        }
        
        
        viewCart.isHidden = true
        txtSearch.text = keyWord
        
        if isStylist == false{
            if latitude ==  0.0{
                let label = UILabel()
                label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                label.textAlignment = .center
                label.textColor = UIColor.darkGray
                label.sizeToFit()
                label.frame = CGRect(x: self.colStylists.frame.width/2, y: self.colStylists.frame.height/2, width: self.colStylists.frame.width, height: 50)

                self.colStylists.backgroundView = label
                return
            }
            getData()
        }else{
            if latitude ==  0.0{
                let label = UILabel()
                label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                label.textAlignment = .center
                label.textColor = UIColor.darkGray
                label.sizeToFit()
                label.frame = CGRect(x: self.colStylists.frame.width/2, y: self.colStylists.frame.height/2, width: self.colStylists.frame.width, height: 50)

                self.colStylists.backgroundView = label
                return
            }

            getEmployees()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if getCartData()?.count ?? 0 > 0{
            viewCart.isHidden = false
            viewCart.backgroundColor = getThemeColor()
            bottomSpace.constant = 80
            bottomSpaceEmployee.constant = 80
            lblCount.text = "\(getCartData()?.count ?? 0)"
            lblCount.layer.cornerRadius = 5
            lblCount.layer.masksToBounds = true
            lblCount.clipsToBounds = true

            var totals = [Double]()
            for all in getCartData()!{
                totals.append(Double(all["price"] as? String ?? "0.0")!)
            }
            
            let sum = totals.reduce(0, +)
            let vat = (15 * sum) / 100
            
            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "basket", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
            let attributedString4 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(sum)", attributes:attrs4 as [NSAttributedString.Key : Any])
            attributedString3.append(attributedString4)
            lblPrice.attributedText = attributedString3
        }else{
            if viewCart != nil{
                viewCart.isHidden = true
            }
            
            bottomSpace.constant = 0
            bottomSpaceEmployee.constant = 0
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
        {
            if isStylist == false{
                getData()
            }else{
                getEmployees()
            }
           
            return true;
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isStylist == false{
            getData()
        }else{
            getEmployees()
        }
    }
    
    func getEmployees(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
               
        var details = [String:Any]()
        details["latitude"] =  latitude
        details["longitude"] =  longitude
        details["search_term"] =  txtSearch.text?.lowercased()
        
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        employeeList.removeAll()
            
        StylzAPIFacade.shared.getEmployees(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Employee(json: m)
                                self.employeeList.append(booking)
                            }
                        
                    }
                       
                    
                    DispatchQueue.main.async {
                        self.colStylists.reloadData()
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.colStylists.frame.width/2, y: self.colStylists.frame.height/2, width: self.colStylists.frame.width, height: 50)

                        if self.employeeList.count == 0{
                            self.colStylists.backgroundView = label
                        }else{
                            self.colStylists.backgroundView = nil
                        }
                    }
                    }else{
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.colStylists.frame.width/2, y: self.colStylists.frame.height/2, width: self.colStylists.frame.width, height: 50)

                        self.colStylists.backgroundView = label
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
        
        var details = [String:Any]()
        details["search_term"] = txtSearch.text
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        details["latitude"] = latitude
        details["longitude"] = longitude

        
        self.salons.removeAll()
        self.serviceList.removeAll()
        self.employeeList.removeAll()
        
        StylzAPIFacade.shared.searchAll(profDet: details) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{

                    if let data = aRes?.json?["data"].array{
                        for all in data{
                            if let salons = all["salons"].array{
                                for m in salons{
                                    let booking = Salons(json: m)
                                    self.salons.append(booking)
                                }
                            }
                            
                            if let salons = all["services"].array{
                                for m in salons{
                                    let booking = Services(json: m)
                                    self.serviceList.append(booking)
                                }
                            }
                            
                            if let salons = all["employees"].array{
                                for m in salons{
                                    let booking = Employee(json: m)
                                    self.employeeList.append(booking)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblSearch.frame.width/2, y: self.tblSearch.frame.height/2, width: self.tblSearch.frame.width, height: 50)

                        if self.salons.count == 0 && self.serviceList.count == 0 && self.employeeList.count == 0{
                            self.tblSearch.backgroundView = label
                        }else{
                            self.tblSearch.backgroundView = nil
                        }
                                                
                        self.tblSearch.reloadData()
                    }
                    }else{
                        showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                    }
            }
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.cartId) as! CartViewController
        vc.isFromBack = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isStylist == true{
            return 1
        }else{
            return 3
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return employeeList.count
        }else if section == 1{
            return salons.count
        }else{
            return serviceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.emplyeeCellId) as! ServiceListCell
            animationScaleEffectSingle(view: cell)
            cell.dropShadow(color: UIColor.lightGray)
               
            cell.lblName.text =  employeeList[indexPath.row].first_name
            cell.lblDuration.text = employeeList[indexPath.row].phone
            setImage(imageView: cell.imgProduct, url: employeeList[indexPath.row].image ?? "")
            cell.lblPrice.text = employeeList[indexPath.row].employee_rating
            return cell
            
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.salonsCellId) as! SalonListCell
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
            
        }else{
          
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.serviceCellId) as! ServiceListCell
            
            animationScaleEffectSingle(view: cell)
            cell.dropShadow(color: UIColor.lightGray)
            
            let service = serviceList
            
            cell.lblName.text =  LocalizationSystem.sharedInstance.getLanguage() == "ar" ? service[indexPath.row].name_ar : service[indexPath.row].name_en
            cell.lblDuration.text = service[indexPath.row].duration
            cell.imgProduct.image = UIImage(named: "test_5")
            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 14.0)!, NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 18.0)!, NSAttributedString.Key.foregroundColor : UIColor.black]
            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", attributes:attrs3 as [NSAttributedString.Key : Any])
            //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
            let attributedString4 = NSMutableAttributedString(string:"\(service[indexPath.row].amount ?? "")", attributes:attrs4 as [NSAttributedString.Key : Any])
            attributedString3.append(attributedString4)
            cell.lblPrice.attributedText = attributedString3
            
//            cell.lblPrice.textColor = getThemeColor()
//            cell.imgStar.tintColor = getThemeColor()
            return cell
            
        }
       

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 100
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
       
        if indexPath.section == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.serviceDetail) as! ServiceDetailsViewController
            vc.modalPresentationStyle = .popover
            vc.selectedEmployee = employeeList[indexPath.row]
            vc.searchView = self
            vc.isEmployee = true
         //   vc.isWalkins = self.isWalkin
            self.present(vc, animated: true)

        }else if indexPath.section == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.service) as! ServiceViewController
            vc.saloonId = salons[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.salons) as! SalonsViewController
            vc.serviceId = self.serviceList[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
                let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
                label.textColor = UIColor.darkGray
                label.font = UIFont.boldSystemFont(ofSize: 15)
                label.textAlignment = .left
        if section == 0{
            if employeeList.count > 0{
                label.text = "   Stylists"
            }else{
                label.text = ""
            }
           
        }else if section == 1{
            if salons.count > 0{
                label.text = "   Salons"
            }else{
                label.text = ""
            }
        }else{
            if serviceList.count > 0{
                label.text = "   Services"
            }else{
                label.text = ""
            }
        }
                
                let frame = tableView.frame
                let height:CGFloat = 50

                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: height))  // create custom view
                headerView.addSubview(label)
                return headerView
                //return label
                
            }

}

extension  SearchViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: VCConst.stylistCellId, for: indexPath) as! BarberColCell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
       
        cell.lblName.text = employeeList[indexPath.row].first_name
        cell.lblRating.text = employeeList[indexPath.row].employee_rating
        cell.lblPrice.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? employeeList[indexPath.row].branchNameAr :  employeeList[indexPath.row].branchNameEn
        setImage(imageView: cell.imgBarber, url: employeeList[indexPath.row].image ?? "")
        cell.imgStar.tintColor = getThemeColor()
        cell.lblRating.textColor = getThemeColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 10, height: 155)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.serviceDetail) as! ServiceDetailsViewController
        vc.modalPresentationStyle = .popover
        vc.selectedEmployee = employeeList[indexPath.row]
        vc.searchView = self
        vc.isEmployee = true
     //   vc.isWalkins = self.isWalkin
        self.present(vc, animated: true)

    }
}
