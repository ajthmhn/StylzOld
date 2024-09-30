//
//  ServiceViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 13/08/23.
//

import UIKit
import StylesWebKit
import ImageSlideshow


class ServiceViewController: UIViewController {

    struct VCConst {
        static let cellId = "category_cell_id"
        static let serviceCellId = "service_cell_id"
        static let employeeCellId = "employee_cell_id"
        static let offerCellId = "offer_cell_id"
    }
    
    
    @IBOutlet var tblHeight: NSLayoutConstraint!
    @IBOutlet var tblServicew: UITableView!
    @IBOutlet var imgTabs: [UIImageView]!
    @IBOutlet var lblTabs: [UILabel]!
    @IBOutlet var viewCart: UIView!
    @IBOutlet var lblCart: UILabel!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var colCategories: UICollectionView!
    @IBOutlet var bottomSpace: NSLayoutConstraint!
    @IBOutlet var viewCol: UIView!
    @IBOutlet var slider: ImageSlideshow!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnHeart: UIButton!
    @IBOutlet var imgLike: UIImageView!

    
    @IBOutlet var lblService: UILabel!
    @IBOutlet var lblOffer: UILabel!
    @IBOutlet var lblEmployee: UILabel!
    @IBOutlet var btnInsta: UIButton!

    
    var selectedService = 0
    var isOffer = false
    var isEmplooyee = false
    var saloonId : Salons?
    var categories = [Categories]()
    var employeeList = [Employee]()
    var offerList = [Services]()
    var favStatus = 0
    var firsttime = true
   
    override func viewDidLoad() {
       super.viewDidLoad()
        
        setUpUI()
        getServices()
        DispatchQueue.global(qos: .userInitiated).async {
            self.getEmployees()
            self.getOffers()
        }
        viewCart.isHidden = true
        viewCart.backgroundColor = getThemeColor()
        bottomSpace.constant = 0

        var bannerImageList = [AlamofireSource]()
        for all in saloonId?.salon_images ?? []{
                    let imageURl =  AlamofireSource(urlString:all)
                    if imageURl != nil{
                    bannerImageList.append(imageURl!)
                }
            }
                         
        if bannerImageList.count == 0{
            self.slider.setImageInputs([ImageSource(image: UIImage(named: "test_2")!)])
        }else{
            self.slider.setImageInputs(bannerImageList)
        }
       
        self.slider.slideshowInterval = 5.0
        self.slider.contentScaleMode = .scaleAspectFill
        self.slider.pageIndicator = nil
        lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? saloonId?.name_ar : saloonId?.name_en
        lblAddress.text = saloonId?.invoice_address
       
        if saloonId?.insta_link != nil &&  saloonId?.insta_link != ""{
            btnInsta.isHidden = false
            btnInsta.tintColor = getThemeColor()
        }else{
            btnInsta.isHidden = true
        }
        
        lblService.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "services", comment: "")
        lblOffer.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "special_offer", comment: "")
        lblEmployee.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "employee", comment: "")
        
        checkIfFavourite()
    }
    
    
    func checkIfFavourite(){
        StylzAPIFacade.shared.checkFavourite(id: saloonId?.id ?? 0, gender: checkIfNotMale() == true ? 2 : 1){ (aRes) in
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                    self.favStatus = 1
                }else{
                    self.favStatus = 0
                }
                
                if self.favStatus == 1{
                    self.imgLike.image = UIImage(named: "like")
                }else{
                    self.imgLike.image = UIImage(named: "unlike")
                }
            }else{
                self.favStatus = 0
                self.imgLike.image = UIImage(named: "unlike")

            }
        }
    }
    
    
    func getOffers(){
     offerList.removeAll()
            
        StylzAPIFacade.shared.getOffers(id: saloonId?.id ?? 0) { (aRes) in
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Services(json: m)
                               self.offerList.append(booking)
                            }
                    }
                    
                    DispatchQueue.main.async {
                        self.tblServicew.reloadData()
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblServicew.frame.width/2, y: self.tblServicew.frame.height/2, width: self.tblServicew.frame.width, height: 50)

                        if self.offerList.count == 0{
                            self.tblServicew.backgroundView = label
                        }else{
                            self.tblServicew.backgroundView = nil
                        }
                    }
                    }else{
                        self.tblServicew.reloadData()
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblServicew.frame.width/2, y: self.tblServicew.frame.height/2, width: self.tblServicew.frame.width, height: 50)

                        if self.offerList.count == 0{
                            if self.firsttime == false{
                                self.tblServicew.backgroundView = label
                            }
                            
                        }else{
                            self.tblServicew.backgroundView = nil
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
               
        
        categories.removeAll()
            
        StylzAPIFacade.shared.getServices(id: saloonId?.id ?? 0, gender: checkIfNotMale() == true ? 2 : 1) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Categories(json: m)
                                self.categories.append(booking)
                            }
                        
                    }
                       
                    
                    DispatchQueue.main.async {
                        self.colCategories.reloadData()
                        self.tblServicew.reloadData()
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblServicew.frame.width/2, y: self.tblServicew.frame.height/2, width: self.tblServicew.frame.width, height: 50)

                        if self.categories.count == 0{
                            self.tblServicew.backgroundView = label
                        }else{
                            self.tblServicew.backgroundView = nil
                        }
                    }
                    }else{
                        
                        DispatchQueue.main.async {
                            self.colCategories.reloadData()
                            self.tblServicew.reloadData()
                            
                            let label = UILabel()
                            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                            label.textAlignment = .center
                            label.textColor = UIColor.darkGray
                            label.sizeToFit()
                            label.frame = CGRect(x: self.tblServicew.frame.width/2, y: self.tblServicew.frame.height/2, width: self.tblServicew.frame.width, height: 50)

                            if self.categories.count == 0{
                                self.tblServicew.backgroundView = label
                            }else{
                                self.tblServicew.backgroundView = nil
                            }
                        }
                    }
            }
        }
    }
    
    
    
    func getEmployees(){
      
        var details = [String:Any]()
        
        details["branch_id"] =  self.saloonId?.id ?? 0
        
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        employeeList.removeAll()
            
        StylzAPIFacade.shared.getEmployees(profDet: details) { (aRes) in
           
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Employee(json: m)
                                self.employeeList.append(booking)
                            }
                   }
                       
                    DispatchQueue.main.async {
                        self.tblServicew.reloadData()
                        
                        let label = UILabel()
                        label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                        label.textAlignment = .center
                        label.textColor = UIColor.darkGray
                        label.sizeToFit()
                        label.frame = CGRect(x: self.tblServicew.frame.width/2, y: self.tblServicew.frame.height/2, width: self.tblServicew.frame.width, height: 50)

                        if self.employeeList.count == 0{
                            if self.firsttime == false{
                                self.tblServicew.backgroundView = label
                            }
                        }else{
                            self.tblServicew.backgroundView = nil
                        }
                    }
                    }else{
                        
                        DispatchQueue.main.async {
                            self.tblServicew.reloadData()
                            
                            let label = UILabel()
                            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "")
                            label.textAlignment = .center
                            label.textColor = UIColor.darkGray
                            label.sizeToFit()
                            label.frame = CGRect(x: self.tblServicew.frame.width/2, y: self.tblServicew.frame.height/2, width: self.tblServicew.frame.width, height: 50)

                            if self.employeeList.count == 0{
                                if self.firsttime == false{
                                    self.tblServicew.backgroundView = label
                                }
                            }else{
                                self.tblServicew.backgroundView = nil
                            }
                        }
                    }
            }
        }
    }
    
    func setUpUI(){
        for all in imgTabs{
            all.setImageColor(color: UIColor.darkGray)
        }
        for all in lblTabs{
            all.textColor = UIColor.darkGray
        }
        
        imgTabs[0].setImageColor(color: getThemeColor())
        lblTabs[0].textColor = getThemeColor()
        viewCart.backgroundColor = getThemeColor()
        
        let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "سلة", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
        //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
        let attributedString4 = NSMutableAttributedString(string:"100 \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))", attributes:attrs4 as [NSAttributedString.Key : Any])
        attributedString3.append(attributedString4)
        lblCart.attributedText = attributedString3
        lblCount.textColor = getThemeColor()
        lblCount.layer.cornerRadius = 5
        lblCount.layer.masksToBounds = true
        lblCart.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tblServicew.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        if getCartData()?.count ?? 0 > 0{
            viewCart.isHidden = false
            bottomSpace.constant = 80
            lblCount.text = "\(getCartData()?.count ?? 0)"
            
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
            viewCart.isHidden = true
            bottomSpace.constant = 0
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                if newsize.height == 0{
                    tblHeight.constant = 200
                }else{
                    tblHeight.constant = newsize.height + 80
                }
            }
        }
    }
    
    @IBAction func btnfavourite(_ sender: Any) {
        if getUserDetails() == nil{
            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "login_continue", comment: ""), sender: self)
            return
        }
        
        
        if favStatus == 1{
            favStatus = 0
            imgLike.image = UIImage(named: "unlike")
        showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "removed_mySalons", comment: ""), view: self.view)

        }else{
            favStatus = 1
            imgLike.image = UIImage(named: "like")
            showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_mySallons", comment: ""), view: self.view)
        }
        
        animationScaleEffectSingle(view: imgLike)
        
        StylzAPIFacade.shared.makeFavourite(id: saloonId?.id ?? 0, status: favStatus, gender: checkIfNotMale() == true ? 2 : 1) { (aRes) in
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                  //  showSuccess(title: "", subTitle: aRes?.json?["message"].stringValue ?? "", view: self.view)
                    }else{
                        //showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                    }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCart(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.cartId) as! CartViewController
        vc.isFromBack = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btmSelect(_ sender: UIButton) {
        firsttime = false
        for all in imgTabs{
            all.setImageColor(color: UIColor.darkGray)
        }
        for all in lblTabs{
            all.textColor = UIColor.darkGray
        }
        self.tblServicew.backgroundView = nil
        imgTabs[sender.tag].setImageColor(color: getThemeColor())
        lblTabs[sender.tag].textColor = getThemeColor()
        
        if sender.tag == 2{
            self.isOffer = false
            self.isEmplooyee = true
            if employeeList.count == 0{
                getEmployees()
            }
            viewCol.isHidden = true
        }else if sender.tag == 0{
            self.isOffer = false
            self.isEmplooyee = false
            if categories.count == 0{
                getServices()
            }
            
            viewCol.isHidden = false
        }else{
            self.isOffer = true
            if offerList.count == 0{
                getOffers()
            }
        }
        self.tblServicew.reloadData()
    }
    
    @IBAction func btnInsta(_ sender: Any) {
        guard let url = URL(string: saloonId?.insta_link ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
}

extension ServiceViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCConst.cellId, for: indexPath) as! CategColCell
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        cell.lblItem.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? categories[indexPath.item].name_ar : categories[indexPath.item].name_en
       // setImage(imageView: cell.imgItem, url: categories[indexPath.item].service_category_icon ?? "")
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        if selectedService == indexPath.item{
            animationScaleEffectSingle(view: cell)
            cell.backgroundColor = getThemeColor()
            cell.lblItem.textColor = UIColor.white
            //cell.imgItem.setImageColor(color: UIColor.white)
            animationScaleEffectSingle(view: cell)
        }else{
            cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            cell.lblItem.textColor = UIColor.black
          //  cell.imgItem.setImageColor(color: UIColor(hexString: "61AB9A")!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let label = UILabel(frame: CGRect.zero)
           label.font = UIFont.systemFont(ofSize: 19)
           label.text = "Cutting"
           label.sizeToFit()
           return CGSize(width: label.frame.width + 60, height: 40)
    }

        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedService = indexPath.item
        collectionView.reloadData()
        self.tblServicew.reloadData()
    }
}

extension ServiceViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOffer == true{
            return offerList.count
        }else{
            if isEmplooyee == false{
                if categories.count > 0{
                    return categories[selectedService].services.count
                }else{
                    return 0
                }
            }else{
                return employeeList.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isOffer == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.offerCellId) as! ServiceListCell
            animationScaleEffectSingle(view: cell)
            cell.dropShadow(color: UIColor.lightGray)
            
            cell.lblName.text =  LocalizationSystem.sharedInstance.getLanguage() == "ar" ? offerList[indexPath.row].name_ar : offerList[indexPath.row].name_en
            cell.lblDuration.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? offerList[indexPath.row].description_ar : offerList[indexPath.row].description_en
            cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(offerList[indexPath.row].discount_value ?? 0.0)"
            cell.lblService.text = "Coupen Code : \(offerList[indexPath.row].discount_coupon ?? "")"
        
            return cell
            
        }
        else{
            if isEmplooyee == false{
                let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.serviceCellId) as! ServiceListCell
                animationScaleEffectSingle(view: cell)
                cell.dropShadow(color: UIColor.lightGray)
                
                let service = categories[selectedService].services
                
                cell.lblName.text =  LocalizationSystem.sharedInstance.getLanguage() == "ar" ? service[indexPath.row].name_ar : service[indexPath.row].name_en
                if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
                    cell.lblDuration.text = "\(service[indexPath.row].duration ?? "") دقيقة"
                }else{
                    cell.lblDuration.text = "\(service[indexPath.row].duration ?? "") Mins"
                }
              
               // setImage(imageView: cell.imgProduct, url: categories[selectedService].service_category_icon ?? "")
                
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
                
//                       cell.lblPrice.isHidden = true
//                       cell.imgStar.isHidden = true

                
                cell.lblRateHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "rate", comment: "")
                cell.lblDurationHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "duration", comment: "")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.employeeCellId) as! ServiceListCell
                animationScaleEffectSingle(view: cell)
                cell.dropShadow(color: UIColor.lightGray)
                   
                cell.lblName.text =  employeeList[indexPath.row].first_name
                cell.lblDuration.text = employeeList[indexPath.row].phone
                setImage(imageView: cell.imgProduct, url: employeeList[indexPath.row].image ?? "")
                cell.lblPrice.text = employeeList[indexPath.row].employee_rating

                return cell
            }
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isOffer == true{
            return 125
        }else{
            return UITableView.automaticDimension
        }
        
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
            if isOffer == true{
                UIPasteboard.general.string = offerList[indexPath.row].discount_coupon
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "code_copy", comment: ""), sender: self)
            }else{
                if isEmplooyee == true{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.serviceDetail) as! ServiceDetailsViewController
                    vc.modalPresentationStyle = .popover
                    vc.selectedEmployee = employeeList[indexPath.row]
                    vc.parents = self
                    vc.isEmployee = true
                 //   vc.isWalkins = self.isWalkin
                    self.present(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.serviceDetail) as! ServiceDetailsViewController
                    vc.modalPresentationStyle = .popover
                    let service = categories[selectedService].services
                    vc.selectedService = service[indexPath.row]
                    vc.parents = self
                    vc.isEmployee = false
                  //  vc.isWalkins = self.isWalkin
                    self.present(vc, animated: true)
                }
            }
        }
}
