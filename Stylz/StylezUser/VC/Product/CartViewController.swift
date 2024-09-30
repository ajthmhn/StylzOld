//
//  CartViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 14/08/23.
//

import UIKit

class CartViewController: UIViewController {

    struct VCConst {
        static let cellId = "cart_cell_id"
    }
    
    @IBOutlet weak var btnCheckout: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var lblSub : UILabel!
    @IBOutlet var lblVat : UILabel!
    @IBOutlet var lblTotal : UILabel!
    @IBOutlet var lblCheckout : UILabel!
    @IBOutlet var tblCart : UITableView!
    @IBOutlet var lblHead : UILabel!
    @IBOutlet var lblServices : UILabel!
    @IBOutlet var lblSubHead : UILabel!
    @IBOutlet var lblVatHead : UILabel!
    @IBOutlet var lblTotalHead : UILabel!
    @IBOutlet var viewCalculation : UIView!

    
    var isFromBack = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCheckout.backgroundColor = getThemeColor()
        btnBack.tintColor = getThemeColor()
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cart", comment: "")
        
        
        
        if isFromBack == true{
            btnBack.isHidden = false
        }else{
            btnBack.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if getCartData() == nil{
            self.lblSub.text = ""
            let vat = ""
            self.lblVat.text = ""
            self.lblTotal.text = ""
            self.lblSubHead.text = ""
            self.lblVatHead.text = ""
            self.lblTotalHead.text = ""

            let label = UILabel()
            label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_cart", comment: "")
            label.textAlignment = .center
            label.textColor = UIColor.darkGray
            label.sizeToFit()
            label.frame = CGRect(x: self.tblCart.frame.width/2, y: self.tblCart.frame.height/2, width: self.tblCart.frame.width, height: 50)

            self.tblCart.backgroundView = label
            btnCheckout.isHidden = true
            self.tblCart.reloadData()
            self.viewCalculation.isHidden = true
            self.lblServices.isHidden = true

        }else{
            lblServices.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "services", comment: "")
            lblSubHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "sub_total", comment: "")
            lblVatHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "vat", comment: "") 
            lblTotalHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "order_total", comment: "")

            btnCheckout.isHidden = false
            self.tblCart.backgroundView = nil
            var totals = [Double]()
            for all in getCartData()!{
                totals.append(Double(all["price"] as? String ?? "0.0")!)
            }
            
            let sum = totals.reduce(0, +)
            let vat = (15 * sum) / 100
            
            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "place_order", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
            //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
            let attributedString4 = NSMutableAttributedString(string:"\(sum) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))", attributes:attrs4 as [NSAttributedString.Key : Any])
            attributedString3.append(attributedString4)
            lblCheckout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "choose_date", comment: "")

            
            self.lblVat.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: vat))"
            self.lblTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum))"
            self.lblSub.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum - vat))"
            self.viewCalculation.isHidden = false
            self.lblServices.isHidden = false

            self.tblCart.reloadData()
        }
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCheckout(_ sender: Any) {
        if getUserDetails() == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: stryBrdId.login) as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: false)
            return
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.selectDate) as! SelectDateViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }

}

extension CartViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCartData()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! ServiceListCell
        // cell.lblStar.textColor = getThemeColor()
        
        let data = getCartData()?[indexPath.row]
        
       // cell.lblName.text = data?["customer_name"] as? String ?? ""
        cell.lblService.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? data?["service_name_ar"] as? String ?? "" : data?["service_name_en"] as? String ?? ""
        cell.lblName.text = data?["customer_name"] as? String 
        cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(data?["price"] as? String ?? "")"
      
        if data?["customer_image"] as? String == ""{
            cell.imgProduct.image = UIImage(named: "scissor")
        }else{
            setImage(imageView: cell.imgProduct, url: data?["customer_image"] as? String ?? "")
        }
        
        cell.deleteTappedActions { aCell in
            let alertController = UIAlertController(title: "", message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "delete_item", comment: ""), preferredStyle: .alert)
                        let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: ""), style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                
                            var data = getCartData()
                            data?.remove(at: indexPath.row)
                            
                            let defaults = UserDefaults.standard
                            defaults.set(nil, forKey: "cart_details")
                            defaults.synchronize()
                            
                            for all in data!{
                                saveCart(details: all)
                            }
                            
                            if data!.count > 0{
                                var totals = [Double]()
                                for all in getCartData()!{
                                    totals.append(Double(all["price"] as? String ?? "0.0")!)
                                }
                                
                                let sum = totals.reduce(0, +)
                                let vat = (15 * sum) / 100
                                self.lblVat.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: vat))"
                                self.lblTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum))"
                                self.lblSub.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum - vat))"

                                let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
                                let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
                                let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "place_order", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
                                //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
                                let attributedString4 = NSMutableAttributedString(string:"\(sum) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))", attributes:attrs4 as [NSAttributedString.Key : Any])
                                attributedString3.append(attributedString4)
                                self.lblCheckout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "choose_date", comment: "")

                            }else{
                                self.lblSub.text = ""
                                let vat = ""
                                self.lblVat.text = ""
                                self.lblTotal.text = ""
                                self.lblSubHead.text = ""
                                self.lblVatHead.text = ""
                                self.lblTotalHead.text = ""
                                self.btnCheckout.isHidden = true
                                self.viewCalculation.isHidden = true
                                self.lblServices.isHidden = true
                                let label = UILabel()
                                label.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "no_cart", comment: "")
                                label.textAlignment = .center
                                label.textColor = UIColor.darkGray
                                label.sizeToFit()
                                label.frame = CGRect(x: self.tblCart.frame.width/2, y: self.tblCart.frame.height/2, width: self.tblCart.frame.width, height: 50)
                                self.tblCart.backgroundView = label
                                self.tblCart.reloadData()
                                
                                let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
                                let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
                                let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "place_order", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
                                //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
                                let attributedString4 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) 0.0", attributes:attrs4 as [NSAttributedString.Key : Any])
                                attributedString3.append(attributedString4)
                                self.lblCheckout.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "choose_date", comment: "")
                            }
                            
                            tableView.reloadData()
                                
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
        return 90
    }
}
