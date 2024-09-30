//
//  HomeViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 10/08/23.
//

import UIKit
import MapKit
import StylesWebKit
import ImageSlideshow
import FirebaseMessaging

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    struct VCConst {
        static let reOrderCellId = "reOrder_cell_id"
        static let recomsCellId = "recoms_cell_id"
        static let salonListCellId = "salon_list_cell_id"
        static let barbersListCellId = "barber_list_cell_id"
    }
    
    @IBOutlet var viewSearch : UIView!
    @IBOutlet var viewSlider : UIView!
    @IBOutlet var viewCategory : [UIView]!
    @IBOutlet var viewSalons : [UIView]!
    @IBOutlet var saonHeight : NSLayoutConstraint!
    @IBOutlet var barberHeight : NSLayoutConstraint!
    @IBOutlet var lbladdress : UILabel!
    @IBOutlet var view10Salons : UIView!
    @IBOutlet var tblTop : UITableView!
    @IBOutlet var viewBrabers : UIView!
    @IBOutlet var tblBarber : UITableView!
    @IBOutlet var viewOrder : UIView!
    @IBOutlet var colOrder : UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var lblSalons: UILabel!
    @IBOutlet weak var btnStylist: UIButton!
    @IBOutlet var btnslow: [UIButton]!
    @IBOutlet weak var lblappoint: UILabel!
    @IBOutlet weak var lblReOrder: UILabel!
    @IBOutlet weak var lblallBarber: UILabel!
    @IBOutlet weak var lblTopSalons: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var viewMenus: UIView!
    @IBOutlet weak var slider: ImageSlideshow!
    
    @IBOutlet weak var lblScedules: UILabel!
    @IBOutlet weak var lblSaloons: UILabel!
    @IBOutlet weak var lblStylist: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var viewNoDataSaloon: UIView!
    @IBOutlet weak var viewNoDataBarber: UIView!
    @IBOutlet var lblNoData: [UILabel]!
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var btnNOt: UIButton!
    
    
    let locationManager = CLLocationManager()
    
    var salons = [Salons]()
    var allBarbers = [Salons]()
    var orders = [Appointments]()
    var addressList = [Addresss]()
    var dataGot = false
    var deviceToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewOrder.isHidden = true
        setupUI()
        localizeTab()
        requateLocation()
       
        if checkIfNotMale() == true{ 
            
            self.slider.setImageInputs([ImageSource(image: UIImage(named: "fbanner1")!),ImageSource(image: UIImage(named: "fbanner2")!),ImageSource(image: UIImage(named: "fbanner3")!)])
        }
        else{
           
            self.slider.setImageInputs([ImageSource(image: UIImage(named: "banner1")!),ImageSource(image: UIImage(named: "banner2")!),ImageSource(image: UIImage(named: "banner3")!)])
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginNotif(notification:)), name: Notification.Name("session_reset"), object: nil)
        
        btnLocation.backgroundColor = getThemeColor()
        btnLocation.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "enable_location", comment: ""), for: .normal)
        viewLocation.isHidden = true
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.requateLocation()
        }
        
        
        txtSearch.delegate = self
        
        lblScedules.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "schedules", comment: "")
        lblSaloons.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "my_salons", comment: "")
        lblStylist.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_stylist", comment: "")
        lblCategory.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_category", comment: "")
        
        
        for all in lblNoData{
            all.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_data", comment: "") }
        
        
        imgLocation.tintColor = getThemeColor()
        
        if checkIfNotMale() == true{
            btnNOt.setImage(UIImage(named: "profile_female_4"), for: .normal)
        }else{
            btnNOt.setImage(UIImage(named: "profile_male_4"), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                self.deviceToken = token
                if getUserDetails() != nil{
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.updateToken()
                    }
                }
            }
        }
    }
    
    
    func updateToken(){
        var details = [String:Any]()
        details["user_id"] = StylzAPIFacade.shared.session?.UserId
        details["fcm_id"] = deviceToken
        StylzAPIFacade.shared.updateToken(profDet: details) { ares in
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if getUserDetails() == nil{
            self.viewOrder.isHidden = true
        }else{
            //  getOrderHistory()
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.getAddress()
                self.getDiscount()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if languageChange == true{
            UIView.appearance().semanticContentAttribute =   LocalizationSystem.sharedInstance.getLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight
        }
    }
    
    func getAddress(){
        self.addressList.removeAll()
        
        StylzAPIFacade.shared.addressList{ (aRes) in
            
            if aRes?.statusCode == 200{
                
                if let data = aRes?.json?["data"].array{
                    for m in data{
                        let booking = Addresss(json: m)
                        self.addressList.append(booking)
                    }
                    
                }
            }
        }
    }
    
    
    func localizeTab() {
        self.tabBarController?.tabBar.items![0].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "home", comment: "")
        self.tabBarController?.tabBar.items![1].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "appointment", comment: "")
        self.tabBarController?.tabBar.items![2].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profile", comment: "")
        self.tabBarController?.tabBar.items![3].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cart", comment: "")
        
        
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
            txtSearch.textAlignment = .right
        }else{
            txtSearch.textAlignment = .left
        }
        
        txtSearch.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search_hair", comment: "")
        btnCategory.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_category", comment: ""), for: .normal)
        btnStylist.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_stylist", comment: ""), for: .normal)
        lblSalons.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "my_salons", comment: "")
        for all in btnslow{
            all.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "show_all", comment: ""), for: .normal)
        }
        
        lblappoint.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "appointment", comment: "")
        lblReOrder.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "re_order", comment: "")
        lblTopSalons.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "top_saloons", comment: "")
        lblallBarber.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "all_barber", comment: "")
    }
    
    
    @objc func loginNotif(notification: Notification) {
        
        deleteUserDetails()
        StylzAPIFacade.shared.resetSession()
        clearCart()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "root_vc")
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: false)
        
        // showAlert(title: "", subTitle: "user logged out", sender: vc!)
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
                        self.colOrder.reloadData()
                        if self.orders.count == 0{
                            self.viewOrder.isHidden = true
                        }else{
                            self.viewOrder.isHidden = false
                        }
                    }
                }else{
                    self.viewOrder.isHidden = true
                }
            }else{
                self.viewOrder.isHidden = true
            }
        }
    }
    
    func getAllBarbers(){
        var details = [String:Any]()
        details["latitude"] = latitude
        details["longitude"] = longitude
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        self.allBarbers.removeAll()
        
        StylzAPIFacade.shared.allBarbers(profDet: details){ (aRes) in
            
            if aRes?.statusCode == 200{
                if aRes?.json?["status"].boolValue == true{
                    
                    if let data = aRes?.json?["data"].dictionary{
                        if let salons = data["items"]?.array{
                            for m in salons{
                                let booking = Salons(json: m)
                                self.allBarbers.append(booking)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if self.allBarbers.count == 0{
                            self.viewNoDataBarber.isHidden = false
                            self.barberHeight.constant = 280
                        }else{
                            self.tblBarber.reloadData()
                            self.viewNoDataBarber.isHidden = true
                            self.barberHeight.constant = CGFloat((260 * self.allBarbers.count) + 70)
                            
                        }
                    }
                }else{
                    // showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                    DispatchQueue.main.async {
                        if self.allBarbers.count == 0{
                            self.viewNoDataBarber.isHidden = false
                            self.barberHeight.constant = 280
                        }else{
                            self.tblBarber.reloadData()
                            self.viewNoDataBarber.isHidden = true
                            self.barberHeight.constant = CGFloat((260 * self.allBarbers.count) + 70)
                        }
                    }
                }
            }
        }
    }
    
    func getTop10(){
        var details = [String:Any]()
        details["latitude"] = latitude
        details["longitude"] = longitude
        if checkIfNotMale() == true{
            details["gender"] = 2
        }else{
            details["gender"] = 1
        }
        
        self.salons.removeAll()
        
        StylzAPIFacade.shared.top10Salons(profDet: details){ (aRes) in
            
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
                        if self.salons.count == 0{
                            self.viewNoDataSaloon.isHidden = false
                            self.saonHeight.constant = 280
                        }else{
                            self.viewNoDataSaloon.isHidden = true
                            self.saonHeight.constant = CGFloat((100 * self.salons.count) + 80)
                            self.tblTop.reloadData()
                            
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        if self.salons.count == 0{
                            self.viewNoDataSaloon.isHidden = false
                            self.saonHeight.constant = 280
                        }else{
                            self.viewNoDataSaloon.isHidden = true
                            self.saonHeight.constant = CGFloat((100 * self.salons.count) + 80)
                            self.tblTop.reloadData()
                        }
                        
                    }
                    
                    // showAlert(title: "", subTitle:  aRes?.json?["message"].stringValue ?? "" , sender: self)
                }
            }
        }
    }
    
    func requateLocation(){
        DispatchQueue.global(qos: .default).async {
            
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case  .denied, .restricted:
                    DispatchQueue.main.async {
                        self.viewLocation.isHidden = false
                    }
                case .authorizedAlways, .authorizedWhenInUse:
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self.locationManager.startUpdatingLocation()
                    DispatchQueue.main.async {
                        self.viewLocation.isHidden = true
                    }
                case .notDetermined:
                    DispatchQueue.main.async {
                        self.viewLocation.isHidden = false
                    }
                @unknown default:
                    break
                }
            } else {
                DispatchQueue.main.async {
                    self.viewLocation.isHidden = false
                }
            }
        }
    }
    
    func setupUI(){
        self.slider.slideshowInterval = 5.0
        self.slider.contentScaleMode = .scaleAspectFill
        self.slider.pageIndicator = nil
        self.slider.layer.cornerRadius = 20
        self.slider.layer.masksToBounds = true
        
        
        viewMenus.layer.masksToBounds = true
        viewMenus.layer.cornerRadius = 20
        viewMenus.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        viewSearch.layer.cornerRadius = 20
        viewSearch.layer.masksToBounds = true
        
        viewCategory[0].backgroundColor = getThemeColor()
        viewCategory[1].backgroundColor = UIColor.white
        viewCategory[1].layer.borderWidth = 1
        viewCategory[1].layer.borderColor = UIColor.black.cgColor
        
        viewSalons[0].backgroundColor = getDarkColor()
        viewSalons[1].backgroundColor = UIColor.white
        viewSalons[1].layer.borderWidth = 1
        viewSalons[1].layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func btnAddress(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.menu) as! MenuViewController
        vc.address = self.addressList
        vc.homeView = self
        
        let navController = UINavigationController(rootViewController: vc) //Add navigation controller
        
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: false)
        
    }
    
    @IBAction func btnREquestLocation(_ sender: UISwitch) {
        if let bundleId = Bundle.main.bundleIdentifier,
           let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)")
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnCategory(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.category) as! CategoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTopSalons(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.salons) as! SalonsViewController
        vc.salons = self.salons
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnhops(_ sender: UIButton) {
        if sender.tag == 0{
            let stry = UIStoryboard(name: "Profile", bundle: nil)
            let vc = stry.instantiateViewController(withIdentifier: stryBrdId.history) as! HIstoryViewController
            vc.isReORder = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.shops) as! ShopsViewController
            vc.isFromHome = true
            vc.salons = self.allBarbers
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func btnMain(_ sender: UIButton) {
        if sender.tag == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.salons) as! SalonsViewController
            vc.isMySalons = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.appointments) as! AppointmentsViewController
            vc.isFromHome = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    @IBAction func bnSearch(_ sender: UIButton) {
        print("sender taga \(sender.tag)")
        if sender.tag == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.search) as! SearchViewController
            self.navigationController?.pushViewController(vc, animated: false)
        } 
        else
        if sender.tag == 2{
           print("in sercj 2")
//            if txtSearch.hasText, txtSearch.text != "",((txtSearch.text?.isEmptyOrWhitespace()) == false){
//               print("search")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.search) as! SearchViewController
                vc.keyWord = txtSearch.text ?? ""
                txtSearch.resignFirstResponder()
                txtSearch.text = ""
                self.navigationController?.pushViewController(vc, animated: false)
           // }
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.search) as! SearchViewController
            vc.isStylist = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    @IBAction func btnNOts(_ sender: UIButton) {
        let stry = UIStoryboard(name: "Profile", bundle: nil)
        let vc = stry.instantiateViewController(withIdentifier:  stryBrdId.notifications) as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCConst.reOrderCellId, for: indexPath) as! ReOrderColCell
            
            cell.viewBg.layer.cornerRadius = 20
            cell.viewBg.layer.masksToBounds = true
            cell.viewBg.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewBg.layer.borderWidth = 0.5
            cell.viewBg.dropShadow(color: UIColor.lightGray)
            
            if orders.count > 0{
                let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 9.0)!, NSAttributedString.Key.foregroundColor : getThemeColor()]
                let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor : getThemeColor()]
                let attributedString1 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", attributes:attrs1 as [NSAttributedString.Key : Any])
                let attributedString2 = NSMutableAttributedString(string:" \(orders[indexPath.item].service_amount ?? 0.0)", attributes:attrs2 as [NSAttributedString.Key : Any])
                attributedString1.append(attributedString2)
                cell.lblPrice.attributedText = attributedString1
                
                var name = [String]()
                for all in orders[indexPath.item].services{
                    name.append(LocalizationSystem.sharedInstance.getLanguage() == "ar" ? all.service_name_ar ?? "" : all.service_name_en ?? "")
                }
                
                cell.lblService.text = name.joined(separator: ",")
                cell.lblSalon.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? orders[indexPath.item].salon_name_ar : orders[indexPath.item].salon_name_en
            }
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCConst.recomsCellId, for: indexPath) as! StoreCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0{
            return CGSize(width: 270, height: 72)
        }else{
            return CGSize(width: 210, height: 190)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.appointmentDetails) as! AppointmentDetailsViewController
        vc.appointments = self.orders[indexPath.item]
        vc.isReorde = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            return salons.count
        }else{
            return allBarbers.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.salonListCellId) as! SalonListCell
            cell.lblStar.textColor = getThemeColor()
            cell.imgStar.tintColor = getThemeColor()
            
            cell.viewBg.layer.cornerRadius = 20
            cell.viewBg.layer.masksToBounds = true
            cell.viewBg.layer.borderColor = UIColor.lightGray.cgColor
            cell.viewBg.layer.borderWidth = 1
            if salons.count > 0 {
                cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? salons[indexPath.row].name_ar :  salons[indexPath.row].name_en
                cell.lblStar.text = "\(salons[indexPath.row].salon_rating ?? 0.0)"
                cell.lblAddress.text = salons[indexPath.row].invoice_address
                if salons[indexPath.row].salon_images.count > 0{
                    setImage(imageView: cell.imgshop, url: salons[indexPath.row].salon_images[0] )
                }else{
                    cell.imgshop.image = UIImage(named: "test_2")
                }
            }
            
            return  cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.barbersListCellId) as! SalonListCell
            cell.lblStar.textColor = getThemeColor()
            cell.imgStar.tintColor = getThemeColor()
            
            cell.viewBg.dropShadow(color: UIColor.lightGray)
            cell.viewBg.layer.cornerRadius = 20
            cell.viewBg.layer.masksToBounds = true
            
            if allBarbers.count > 0{
                cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? allBarbers[indexPath.row].name_ar :  allBarbers[indexPath.row].name_en
                cell.lblStar.text = "\(allBarbers[indexPath.row].salon_rating ?? 0.0)"
                cell.lblAddress.text = allBarbers[indexPath.row].invoice_address
                if allBarbers[indexPath.row].salon_images.count > 0{
                    setImage(imageView: cell.imgshop, url: allBarbers[indexPath.row].salon_images[0] )
                }else{
                    cell.imgshop.image = UIImage(named: "test_2")
                }
            }
            
            
            
            return  cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0{
            return 100
        }else{
            return 260
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView.tag == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.service) as! ServiceViewController
            vc.saloonId = salons[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.service) as! ServiceViewController
            vc.saloonId = allBarbers[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

class CustomTabBarVC: UITabBarController, UITabBarControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tabBar.tintColor = getThemeColor()
        self.tabBar.barTintColor = .white
        self.tabBar.isTranslucent = true
        
        if let items = self.tabBar.items
        {
            for item in items
            {
                if let image = item.image
                {
                    item.image = image.withRenderingMode( .alwaysTemplate )
                    item.image?.withTintColor(getThemeColor())
                }
            }
        }
        
        self.delegate = self;
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        if let vc = viewController as? UINavigationController {
            vc.popViewController(animated: false);
        }
    }
    
}

extension HomeViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            if addressSelected == false{
                let location:CLLocation = locations[0] as CLLocation
                location.fetchCityAndCountry { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    //   print(city + ", " + country)  // Rio de Janeiro, Brazil
                    self.lbladdress.text = "\(city), \(country)"
                    
                    latitude = location.coordinate.latitude
                    longitude = location.coordinate.longitude
                    mylatitude = location.coordinate.latitude
                    mylongitude = location.coordinate.longitude
                    myAddress = self.lbladdress.text ?? ""
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        if self.dataGot == false{
                            self.dataGot = true
                            self.getTop10()
                            self.getAllBarbers()
                        }
                        
                    }
                    
                }
            }else{
                self.lbladdress.text = userAddress
                DispatchQueue.global(qos: .userInitiated).async {
                    if self.dataGot == false{
                        self.dataGot = true
                        self.getTop10()
                        self.getAllBarbers()
                        
                    }
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        //    print("Error \(error)")
    }
    
}


extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        let locale = Locale(identifier: "en")
        
        CLGeocoder().reverseGeocodeLocation(self, preferredLocale: locale) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}



//MARK: - textfeild delegate  - search
extension  HomeViewController{
   
    //oldd
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.search) as! SearchViewController
    //        vc.keyWord = txtSearch.text ?? ""
    //        txtSearch.text = ""
    ////        self.navigationController?.pushViewController(vc, animated: false)
    //
    //
    //    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        
        textField.resignFirstResponder()
        
       /// if txtSearch.hasText, txtSearch.text != "",((txtSearch.text?.isEmptyOrWhitespace()) == //false){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.search) as! SearchViewController
            vc.keyWord = txtSearch.text ?? ""
            txtSearch.text = ""
            self.navigationController?.pushViewController(vc, animated: false)
       // }
        
        return true
    }
}


extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        if(self.isEmpty) {
            return true
        }
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        // string contains non-whitespace characters
    }
}




//MARK: - get discount
extension HomeViewController{
    func getDiscount(){
       
        StylzAPIFacade.shared.getDiscount{ (aRes) in
           
            if aRes?.statusCode == 200{
                var _discountValue:Double? = nil
            
                if let data = aRes?.json?["data"].array{
                    for discount in data{
                        switch discount["Setting_choice"].intValue{
                        case 2:
                            _discountValue = discount["setting_value"].doubleValue
                            break
                        default:
                            print("\(discount)")
                        }
                    }
                }
                
                paynowDicountValue = _discountValue ?? 0.0
                print("disocunt \(paynowDicountValue)")
            }
        }
    }
}

