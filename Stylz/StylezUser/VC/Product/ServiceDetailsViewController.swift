//
//  ServiceDetailsViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 13/08/23.
//

import UIKit
import StylesWebKit

class ServiceDetailsViewController: UIViewController {

    struct VCConst {
        static let cellId = "barber_cell_id"
    }
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblEmployee: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPriceHad: UILabel!
    @IBOutlet weak var lblDurationHead: UILabel!
    @IBOutlet weak var lblNAme: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var desHeight: NSLayoutConstraint!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var viewTop: UIView!

    
    var isEmployee = false
    var selectedBarber = -1
    var selectedService : Services?
    var selectedEmployee : Employee?
    var parents : ServiceViewController?
   var searchView : SearchViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func addToCart(){
        if selectedService == nil{
            if selectedBarber == -1{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_service", comment: ""), sender: self)
                return
            }
            
            var details = [String:Any]()
            details["customer_id"] = self.selectedEmployee?.id
            details["customer_image"] = self.selectedEmployee?.image
            details["customer_name"] =  self.selectedEmployee?.first_name
            details["service_id"] = self.selectedEmployee?.services[selectedBarber].service
            details["service_name_en"] = self.selectedEmployee?.services[selectedBarber].name_en
            details["service_name_ar"] = self.selectedEmployee?.services[selectedBarber].name_ar
            details["price"] = self.selectedEmployee?.services[selectedBarber].amount
            if parents != nil{
                details["shop_id"] = self.parents?.saloonId?.id
            }else{
                details["shop_id"] = self.selectedEmployee?.branchId
            }
            print(details)
            saveCart(details: details)
            
        }else{
            if selectedBarber == -1{
                showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_employee", comment: ""), sender: self)
                return
            }
            
            var details = [String:Any]()
            details["customer_id"] = self.selectedService?.employees[self.selectedBarber].employee
            details["customer_image"] = self.selectedService?.employees[self.selectedBarber].image
            details["customer_name"] =  self.selectedService?.employees[self.selectedBarber].first_name
            details["service_id"] = self.selectedService?.id
            details["service_name_en"] = self.selectedService?.name_en
            details["service_name_ar"] = self.selectedService?.name_ar
            details["price"] = self.selectedService?.amount
            details["shop_id"] = self.parents?.saloonId?.id

            print(details)
            saveCart(details: details)
        }
        
        if parents != nil{
            showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "service_added", comment: ""), view: (parents?.view)!)
            parents?.viewCart.isHidden = false
            parents?.lblCount.text = "\(getCartData()?.count ?? 0)"
            
            
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
            parents?.lblPrice.attributedText = attributedString3
            
            animationScaleEffectSingle(view: (parents?.viewCart)!)
        }else{
            showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "service_added", comment: ""), view: (searchView?.view)!)
            searchView?.viewCart.isHidden = false
            searchView?.lblCount.text = "\(getCartData()?.count ?? 0)"
            
            
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
            searchView?.lblPrice.attributedText = attributedString3
            
            animationScaleEffectSingle(view: (searchView?.viewCart)!)

        }
        
        self.dismiss(animated: true)
    }
    
    func setupUI(){
        
        viewTop.clipsToBounds = true
        viewTop.layer.cornerRadius = 25
        viewTop.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively

        
        viewBtn.backgroundColor = getThemeColor()
        if isEmployee  == true{
            lblEmployee.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "services", comment: "")
            lblAmount.text = ""
            lblPriceHad.text = ""
            lblDurationHead.text = ""
            lblNAme.text =  selectedEmployee?.first_name
            lblAmount.text = ""
            lblDuration.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? selectedEmployee?.branchNameAr : selectedEmployee?.branchNameEn
            lblDes.text = ""
            self.desHeight.constant = 0
            setImage(imageView: imgUser, url: selectedEmployee?.image ?? "")
            imgUser.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_basket", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
            //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
            let attributedString4 = NSMutableAttributedString(string:"\("0.0") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))", attributes:attrs4 as [NSAttributedString.Key : Any])
            attributedString3.append(attributedString4)
            lblPrice.attributedText = attributedString3
            
        }else{
            lblNAme.text =  LocalizationSystem.sharedInstance.getLanguage() == "ar" ? selectedService?.name_ar : selectedService?.name_en
            imgUser.backgroundColor = UIColor.clear
            lblPriceHad.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "rate", comment: "")
            imgUser.image = UIImage(named: "test_5")
            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_basket", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
            let attributedString4 = NSMutableAttributedString(string:"\(selectedService?.amount ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))", attributes:attrs4 as [NSAttributedString.Key : Any])
            attributedString3.append(attributedString4)
            lblAmount.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(selectedService?.amount ?? "")"
            lblPrice.attributedText = attributedString3
            lblEmployee.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "employee", comment: "")
            lblPrice.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_now", comment: "")
            lblDurationHead.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "duration", comment: "")) :"
            if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
                lblDuration.text = "\(selectedService?.duration ?? "") دقيقة"
            }else{
                lblDuration.text = "\(selectedService?.duration ?? "") Mins"
            }
            lblDes.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? selectedService?.description_ar : selectedService?.description_en
            
            self.desHeight.constant = self.lblDes.getSize(constrainedWidth:self.view.frame.width).height

        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAddCart(_ sender: Any) {
        
        if getCartData()?.count ?? 0 >  0{
            let shopId =  getCartData()?[0]["shop_id"] as? Int
            if self.parents == nil{
                if self.selectedEmployee?.branchId != shopId{
                    
                    let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cart_contains", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "do_continue", comment: ""), preferredStyle: .alert)
                                let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: ""), style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        clearCart()
                                        self.addToCart()
                                    }
                                    let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "no", comment: ""), style: UIAlertAction.Style.cancel) {
                                        UIAlertAction in
                                    }
                                    alertController.addAction(okAction)
                                    alertController.addAction(cancelAction)
                                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }else{
                if self.parents?.saloonId?.id != shopId{
                    
                    let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cart_contains", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "do_continue", comment: ""), preferredStyle: .alert)
                                let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: ""), style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        clearCart()
                                        self.addToCart()
                                    }
                                    let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "no", comment: ""), style: UIAlertAction.Style.cancel) {
                                        UIAlertAction in
                                    }
                                    alertController.addAction(okAction)
                                    alertController.addAction(cancelAction)
                                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }

            
        }
        
        addToCart()
        
//        else{
//            showSuccess(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "service_added", comment: ""), view: (searchView?.view)!)
//        }
       
    }
    
}

extension  ServiceDetailsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedService == nil{
            return selectedEmployee?.services.count ?? 0
        }else{
            return selectedService?.employees.count ?? 0

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: VCConst.cellId, for: indexPath) as! BarberColCell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        if selectedService == nil{
            cell.lblName.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? selectedEmployee?.services[indexPath.row].name_ar : selectedEmployee?.services[indexPath.row].name_en
            cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(selectedEmployee?.services[indexPath.row].amount ?? "")"
            cell.imgBarber.image = UIImage(named: "test_5")
            cell.viewRating.isHidden = true
            if selectedBarber == indexPath.item{
                cell.backgroundColor = UIColor(hexString: "1B263B")
                cell.lblName.textColor = UIColor.white
                cell.lblPrice.textColor = UIColor.white
                cell.layer.borderWidth = 0
                animationScaleEffectSingle(view: cell)
            }else{
                cell.layer.borderWidth = 0.5
                cell.backgroundColor = UIColor.white
                cell.lblName.textColor = UIColor.black
                cell.lblPrice.textColor = UIColor.black
            }
        }else{
            cell.viewRating.isHidden = true  //false
            cell.lblName.text = selectedService?.employees[indexPath.row].first_name
            cell.lblRating.text = selectedService?.employees[indexPath.row].employee_rating
            cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(selectedService?.amount ?? "")"
            setImage(imageView: cell.imgBarber, url: selectedService?.employees[indexPath.row].image ?? "")
            
            if selectedBarber == indexPath.item{
                cell.backgroundColor = UIColor(hexString: "1B263B")
                cell.lblName.textColor = UIColor.white
                cell.lblPrice.textColor = UIColor.white
                cell.layer.borderWidth = 0
                animationScaleEffectSingle(view: cell)
            }else{
                cell.layer.borderWidth = 0.5
                cell.backgroundColor = UIColor.white
                cell.lblName.textColor = UIColor.black
                cell.lblPrice.textColor = UIColor.black
            }
        }
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 114, height: 155)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedService == nil{
            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "add_basket", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
            //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
            let attributedString4 = NSMutableAttributedString(string:"\(selectedEmployee?.services[indexPath.row].amount ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))", attributes:attrs4 as [NSAttributedString.Key : Any])
            attributedString3.append(attributedString4)
            lblPrice.attributedText = attributedString3
        }
        selectedBarber = indexPath.item
        collectionView.reloadData()
    }
}

extension UILabel {
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}
