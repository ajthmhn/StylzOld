////
////  SummeryViewController.swift
////  StylezUser
////
////  Created by Ajith Mohan on 13/09/23.
////
//
//import UIKit
//import Urway
//import StylesWebKit
//import PassKit
//
//class SummeryViewController: UIViewController {
//    
//    //    DISCOUNT_SOURCE_OPTIONS = (
//    //        (1, 'Discount'),
//    //        (2, 'PayNow'),
//    //        (3, 'Subscription'),
//    //    )
//    
//    struct VCConst {
//        static let cellId = "cart_cell_id"
//        static let cardCellId = "cards_cell_id"
//        static let Disocunt = "Discount"
//        static let Paynow = "PayNow"
//    }
//    
//    @IBOutlet weak var btnCheckout: UIView!
//    @IBOutlet weak var btnBack: UIButton!
//    @IBOutlet var lblSub : UILabel!
//    @IBOutlet var lblVat : UILabel!
//    @IBOutlet var lblTotal : UILabel!
//    @IBOutlet var lblCheckout : UILabel!
//    @IBOutlet var lblDiscount : UILabel!
//    @IBOutlet var btnApply : UIButton!
//    @IBOutlet var tblCards : UITableView!
//    @IBOutlet var viewCards : UIView!
//    @IBOutlet var txtPromo : UITextField!
//    
//    @IBOutlet var lblHead : UILabel!
//    @IBOutlet var lblSubHead : UILabel!
//    @IBOutlet var lblVatHead : UILabel!
//    @IBOutlet var lblTotalHead : UILabel!
//    @IBOutlet var lblDiscountTitle : UILabel!
//    @IBOutlet var lblSelectCard : UILabel!
//    @IBOutlet var btnNewCard : UIButton!
//    @IBOutlet var imgTypes : [UIImageView]!
//    @IBOutlet var viewSummary : UIView!
//    @IBOutlet var lblPaidTotal : UILabel!
//    @IBOutlet var lblPrepaidTotal : UILabel!
//    @IBOutlet var lblPaidDiscount : UILabel!
//    @IBOutlet var lblSummary : UILabel!
//    @IBOutlet var btnsubmit : UIButton!
//    @IBOutlet var lblSelectOptions : UILabel!
//    @IBOutlet var lblBook : UILabel!
//    @IBOutlet var lblBook15 : UILabel!
//    @IBOutlet var viewPayment : UIView!
//    @IBOutlet var btnApple : UIButton!
//    @IBOutlet var btnCard : UIButton!
//    @IBOutlet var lblSelectPayment : UILabel!
//    
//    
//    var paymentController: UIViewController? = nil
//    var date = ""
//    var time = ""
//    var referanceId = ""
//    var dateView : SelectDateViewController?
//    var seletedCard = -1
//    var discountApplied = -1
//    var promoApplied = false
//    var cards = [Cards]()
//    var discountValue = 0.0
//    var appointments : Appointments?
//    var isReorde = false
//    var isApplePayPaymentTrxn = false
//    var isSucessStatus: Bool = false
//    
//    var paymentString = ""
//    var discount_source = ""
//    
//    var discountObj:Discount?
//    
//    var payNowDiscountedAmount = 0.0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewPayment.isHidden = true
//        btnCheckout.backgroundColor = getThemeColor()
//        btnBack.tintColor = getThemeColor()
//        btnApply.tintColor = getThemeColor()
//        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "payment", comment: "")
//        lblSubHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "sub_total", comment: "")
//        lblTotalHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "order_total", comment: "")
//        lblDiscountTitle.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "discount", comment: "")
//        txtPromo.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enter_promo", comment: "")
//        btnApply.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "apply", comment: ""), for: .normal)
//        lblSelectCard.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_card", comment: "")
//        btnNewCard.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "use_new_card", comment: ""), for: .normal)
//        lblSummary.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "summary", comment: "")
//        btnsubmit.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "one", comment: ""), for: .normal)
//        btnApple.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "pay_apple", comment: ""), for: .normal)
//        btnCard.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "pay_card", comment: ""), for: .normal)
//        lblSelectPayment.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "seelct_payment", comment: "")
//        lblVatHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "vat", comment: "")
//        
//        self.lblDiscount.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) 0.0"
//        
//        if isReorde == true{
//            var totals = [Double]()
//            for all in appointments?.services ?? []{
//                totals.append(Double(all.service_amount ?? "0.0")!)
//            }
//            
//            let total = totals.reduce(0, +)
//            
//            let discount = (paynowDicountValue * total) / 100 // 15 - dynamic
//            payNowDiscountedAmount = discount
//            
//            let sum = total -  discount
//            
//            let vat = (15 * sum) / 100
//            
//           
//            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
//            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
//            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "place_order", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
//            //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
//            let attributedString4 = NSMutableAttributedString(string:"\(sum)", attributes:attrs4 as [NSAttributedString.Key : Any])
//            attributedString3.append(attributedString4)
//            lblCheckout.attributedText = attributedString3
//            
//            lblSub.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum - vat) )"
//            lblTotal.text =  "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum))"
//            lblVat.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: vat))"
//            
//            lblPaidTotal.textColor = getThemeColor()
//            lblPrepaidTotal.textColor = getThemeColor()
//            lblPrepaidTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: total))"
//            lblPaidTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum))"
//            
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(total)")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
//            
//            lblPaidDiscount.attributedText = attributeString
//            
//        }else{
//            var totals = [Double]()
//            for all in getCartData()!{
//                totals.append(Double(all["price"] as? String ?? "0.0")!)
//            }
//            
//         
//            let total = totals.reduce(0, +)
//           
//            let discount = (paynowDicountValue * total) / 100 //15 to dynamic
//         
//            payNowDiscountedAmount = discount
//            
//            let sum = total -  discount
//            
//            let vat = (15 * sum) / 100
//            
//            
//           // let total = totals.reduce(0, +)
//        //            let discount = (15 * total) / 100
//        //
//        //            let sum = total -  discount
//        //
//        //            let vat = (15 * sum) / 100
//        //
//            
//            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
//            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
//            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "place_order", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
//            //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
//            let attributedString4 = NSMutableAttributedString(string:"\(sum) \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))", attributes:attrs4 as [NSAttributedString.Key : Any])
//            attributedString3.append(attributedString4)
//            lblCheckout.attributedText = attributedString3
//            
//            lblSub.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum - vat) )"
//            lblTotal.text =  "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum))"
//            lblVat.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: vat))"
//            
//            lblPaidTotal.textColor = getThemeColor()
//            lblPrepaidTotal.textColor = getThemeColor()
//            lblPrepaidTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: total))"
//            lblPaidTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum))"
//            
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(total)")
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
//            
//            lblPaidDiscount.attributedText = attributeString
//            
//        }
//        
//        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
//            txtPromo.textAlignment = .right
//        }else{
//            txtPromo.textAlignment = .left
//        }
//        
//        getCard()
//        viewCards.isHidden = true
//        
//        viewSummary.clipsToBounds = true
//        viewSummary.layer.cornerRadius = 20
//        viewSummary.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        
//        discountApplied = 1
//        imgTypes[1].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
//        imgTypes[0].image = UIImage(named: "circle_unsel")
//        
//        
//        lblSelectOptions.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "select_options", comment: "")
//        lblBook.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_appoint", comment: "")
//        
//        //lblBook15.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_15", comment: "")
//        
//        
//        lblBook15.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "book_15", comment: "")) \(paynowDicountValue)% \(LocalizationSystem.sharedInstance.localizedStringForKey(key: "discount", comment: ""))"
//        
//        
//    }
//    
//    
//    
//    fileprivate func initializeSDK() {
//        UWInitialization(self) { (controller , result) in
//            self.paymentController = controller
//            guard let nonNilController = self.paymentController else {
//                self.presentAlert(resut: result)
//                return
//            }
//            print("initialSDK")
//            self.navigationController?.pushViewController(nonNilController, animated: true)
//        }
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.viewPayment.isHidden = true
//    }
//    
//    func initilizeApplePayment(){
//      
//        isApplePayPaymentTrxn = true
//       
//        //test
//        //        let terminalId = "stylz"
//        //        let password = "stylz@URWAY"
//        //        let merchantKey = "4d41678c4b6309ca358e689be3db9cf3ec33c0e317b4d9c737846d38ff3565fe"
//        //        let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
//        
//        
//        //live
//        let terminalId = "stylz"
//        let password = "st_9878@URWAY"
//        let merchantKey = "03f296706cb7cae42eab87823a6741508b39a01cf7ae326350b7da27fd76acc0"
//        let url = "https://payments.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
//        
//        
//        
//        UWConfiguration(password: password , merchantKey: merchantKey , terminalID: terminalId , url: url )
//        
//        isSucessStatus = false
//        
//        UWInitialization(self)
//        {
//            (controller , result) in
//            self.paymentController = controller
//            guard let _ = self.paymentController
//            else {
//                self.presentAlert(resut: result)
//                return
//            }
//        }
//        
//        isSucessStatus = false
//        
//        let amount = self.lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: "") ?? "0"
//        
//        
//        let floatAmount = Double(amount ) ?? .zero
//        
//        let request = PKPaymentRequest()
//        // change the name here to your merchant identifer name
//        request.merchantIdentifier = "merchant.me.stylz.app"
//        request.supportedNetworks = [.quicPay, .masterCard, .visa , .amex , .discover , .mada ]
//        request.merchantCapabilities = .capability3DS
//        
//        request.countryCode = "SA"
//        request.currencyCode = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: ""))"
//        
//        request.paymentSummaryItems = [PKPaymentSummaryItem(label: " urway ",amount: NSDecimalNumber(floatLiteral: floatAmount) )]
//        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
//        if controller != nil
//        {
//            controller!.delegate = self
//            present(controller!, animated: true, completion: nil)
//        }
//    }
//    
//    func initilizePayment(){
//        isApplePayPaymentTrxn = false
//        //test
//        //        let terminalId = "stylz"
//        //        let password = "stylz@URWAY"
//        //        let merchantKey = "4d41678c4b6309ca358e689be3db9cf3ec33c0e317b4d9c737846d38ff3565fe"
//        //        let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
//        
//        
//        //live
//        let terminalId = "stylz"
//        let password = "st_9878@URWAY"
//        let merchantKey = "03f296706cb7cae42eab87823a6741508b39a01cf7ae326350b7da27fd76acc0"
//        let url = "https://payments.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
//        
//        
//        
//        UWConfiguration(password: password , merchantKey: merchantKey , terminalID: terminalId , url: url )
//        
//        
//        UWInitialization(self) { (controller , result) in
//            self.paymentController = controller
//            self.viewCards.isHidden = true
//            guard let nonNilController = self.paymentController else {
//                self.presentAlert(resut: result)
//                return
//            }
//            print("initialSDK")
//            self.navigationController?.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(nonNilController, animated: true)
//        }
//    }
//    
//    func getCard(){
//        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.large
//        loadingIndicator.startAnimating();
//        
//        self.view.addSubview(loadingIndicator)
//        self.cards.removeAll()
//        
//        //  appointments.removeAll()
//        
//        StylzAPIFacade.shared.getCard{ (aRes) in
//            
//            
//            DispatchQueue.main.async {
//                loadingIndicator.removeFromSuperview()
//            }
//            
//            if aRes?.statusCode == 200{
//                
//                if let data = aRes?.json?["data"].array{
//                    
//                    
//                    for m in data{
//                        let booking = Cards(json: m)
//                        self.cards.append(booking)
//                    }
//                    
//                }
//                
//                DispatchQueue.main.async {
//                    self.tblCards.reloadData()
//                }
//                
//            }
//        }
//    }
//    
//    
//    func lockTimeSlote(){
//        
//        //
//        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.large
//        loadingIndicator.startAnimating();
//        
//        self.view.addSubview(loadingIndicator)
//        
//        var details = [String:Any]()
//        var branchId = 0
//        
//        self.discount_source = ""
//        
//        if promoApplied{
//            setDiscoutSourceString(discountType: VCConst.Disocunt)
//        }
//        if discountApplied != 0{
//            setDiscoutSourceString(discountType: VCConst.Paynow)
//        }
//        
//        
//        if isReorde == true{
//            var appointment = [[String:Any]]()
//            
//            for all in appointments?.services ?? []{
//                var data = [String:Any]()
//                data["service_id"] = all.service_id
//                data["employee_id"] = all.employee_id
//                appointment.append(data)
//            }
//            
//            details["date"] = date
//            details["start_time"] = time
//            details["appointment_details"] = appointment
//            details["branch_id"] = appointments?.salon_id
//
//            details["total_amount"] = Double(lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: "") ?? "0.0")
//     
//        //    details["total_amount"] = getTotalAmount()
//     
//            details["discount_source"] = discount_source
//            
//        }
//        else{
//            var appointment = [[String:Any]]()
//            
//            for all in getCartData()!{
//                var data = [String:Any]()
//                data["service_id"] = all["service_id"] as? Int
//                data["employee_id"] = all["customer_id"] as? Int
//                branchId = all["shop_id"] as? Int ?? 0
//                appointment.append(data)
//            }
//            
//            details["date"] = date
//            details["start_time"] = time
//            details["appointment_details"] = appointment
//            details["branch_id"] = branchId
//         
////            details["total_amount"] = lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: "")
////  
//           details["total_amount"] = Double(lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: "") ?? "0.0")
//      
//        
//            
//      //      details["total_amount"] = getTotalAmount()
//            
//            details["discount_source"] = discount_source
//            
//        }
//        
//        var _discountObj = [String:Any]()
//        
//        if let discountObj{
//            _discountObj["discount_id"] = discountObj.discountID
//            _discountObj["name_en"] = discountObj.name_en
//            _discountObj["name_ar"] = discountObj.name_ar
//            _discountObj["discount_type"] = discountObj.discountType
//            _discountObj["discount_value"] = discountObj.discountValue
//            
//            if discountApplied != 0 {
//                let  discountedAmount = payNowDiscountedAmount + (discountObj.discountedAmount ?? 0.0)
//                _discountObj["discounted_amount"] = discountedAmount
//            }
//            else
//            {
//                _discountObj["discounted_amount"] = discountObj.discountedAmount ?? 0.0
//            }
//        }
//        else{
//            _discountObj["discounted_amount"] = payNowDiscountedAmount
//        }
//        
//        
//        if promoApplied == true || discountApplied != 0{
//            details["discount_details"] = _discountObj
//        }
//        
//        
//        print("details \(details)")
//        
//        
//        StylzAPIFacade.shared.lockTimeSlote(profDet: details) { (aRes) in
//            DispatchQueue.main.async {
//                loadingIndicator.removeFromSuperview()
//            }
//            
//            print("lock time slot \(aRes?.json)")
//            
//            if aRes?.statusCode == 200{
//                if aRes?.json?["status"].stringValue == "true"{
//                    self.referanceId = aRes?.json?["reference_id"].stringValue ?? ""
//                    
//                    if self.discountApplied == 0{
//                        self.placeOrder(paymentID: "", transactionId: "")
//                    }else{
//                        //                        if self.cards.count > 0{
//                        //                            self.viewCards.isHidden = false
//                        //                            animationScaleEffectSingle(view: self.viewCards)
//                        //                        }else{
//                        //                            self.initilizePayment()
//                        //                        }
//                        
//                        self.viewPayment.isHidden = false
//                        animationScaleEffectSingle(view: self.btnApple)
//                        animationScaleEffectSingle(view: self.btnCard)
//                        animationScaleEffectSingle(view: self.lblSelectCard)
//                        
//                        
//                        //                        self.initilizePayment()
//                    }
//                    
//                    
//                }else{
//                    if let error = aRes?.json?["error"].array{
//                        if error.count > 0{
//                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
//                        }else{
//                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                        }
//                    }else if let error = aRes?.json?["error"].dictionary{
//                        showAlert(title: "", subTitle:  error["employee_id"]?.stringValue ?? "" , sender: self)
//                    }
//                    else{
//                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                        
//                    }
//                }
//            }else{
//                if let error = aRes?.json?["error"].array{
//                    if error.count > 0{
//                        showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
//                    }else{
//                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                    }
//                }else{
//                    showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                }
//            }
//        }
//    }
//    
//    func applyPromo(){
//        
//        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.large
//        loadingIndicator.startAnimating();
//        
//        self.view.addSubview(loadingIndicator)
//        
//        var details = [String:Any]()
//        var appointment = [[String:Any]]()
//        var branchId = 0
//        
//        if isReorde == true{
//           
//            var appointment = [[String:Any]]()
//            
//            for all in appointments?.services ?? []{
//                var data = [String:Any]()
//                data["service_id"] = all.service_id
//                data["employee_id"] = all.employee_id
//                appointment.append(data)
//            }
//            
//            details["date"] = date
//            details["start_time"] = time
//            details["appointment_details"] = appointment
//            details["branch_id"] = appointments?.salon_id
//            details["discount_coupon"] = self.txtPromo.text ?? ""
//        }
//        else{
//          
//            for all in getCartData()!{
//                var data = [String:Any]()
//                data["service_id"] = all["service_id"] as? Int
//                data["employee_id"] = all["customer_id"] as? Int
//                branchId = all["shop_id"] as? Int ?? 0
//                appointment.append(data)
//            }
//            
//            details["date"] = date
//            details["start_time"] = time
//            details["appointment_details"] = appointment
//            details["branch_id"] = branchId
//            details["discount_coupon"] = self.txtPromo.text ?? ""
//        }
//        
//        
//        print(details)
//        
//        txtPromo.text = ""
//        
//        
//        StylzAPIFacade.shared.applyPrmo(profDet: details) { [self] (aRes) in
//            DispatchQueue.main.async {
//                loadingIndicator.removeFromSuperview()
//            }
//            
//            if aRes?.statusCode == 200{
//                if aRes?.json?["status"].stringValue == "true"{
//                    if let data = aRes?.json?["discount_details"].dictionary{
//                        
//                        discountValue =  data["discount_value"]?.doubleValue ?? 0.0
//                        
//                        if discountValue != 0.0{
//                            
//                            let total = Double((lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: ""))!)
//                            
//                           // let vat = (discountValue * total!) / 100
//                            
//                            let vat = data["discounted_amount"]?.doubleValue ?? 0.0
//                            
//                            //print(" discount: \(discountValue) , total : \(total)")
//                           
//                            self.lblDiscount.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(vat)"
//                            
//                            
//                            let totals = total! - vat
//                            
//                            self.lblTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: totals))"
//                            
//                            self.promoApplied = true
//                            
//                            
//                            print("~ dataa: \(data)")
//                            
//                            discountObj = Discount(json: aRes?.json?["discount_details"])
//                            
//                            showAlert(title: "", subTitle: aRes?.json?["message"].stringValue ?? "" , sender: self)
//                            
//                        }
//                        else{
//                            showAlert(title: "", subTitle: aRes?.json?["message"].stringValue ?? "" , sender: self)
//                            
//                        }
//                    }
//                }else{
//                    if let error = aRes?.json?["error"].array{
//                        if error.count > 0{
//                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
//                        }else{
//                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                        }
//                    }else if let error = aRes?.json?["error"].dictionary{
//                        showAlert(title: "", subTitle:  error["employee_id"]?.stringValue ?? "" , sender: self)
//                    }
//                    else{
//                        showAlert(title: "", subTitle: aRes?.json?["message"].stringValue ?? "" , sender: self)
//                        
//                    }
//                }
//            }else{
//                if let error = aRes?.json?["error"].array{
//                    if error.count > 0{
//                        showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
//                    }else{
//                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                    }
//                }else{
//                    showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                }
//            }
//        }
//    }
//    
//    
//    func placeOrder(paymentID : String , transactionId : String){
//        
//        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
//        
//        DispatchQueue.main.async {
//            loadingIndicator.hidesWhenStopped = true
//            loadingIndicator.style = UIActivityIndicatorView.Style.large
//            loadingIndicator.startAnimating();
//            self.view.addSubview(loadingIndicator)
//            
//        }
//        
//        
//        var details = [String:Any]()
//        
//        details["reference_id"] = self.referanceId
//        details["paid_amount"] = lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: "")
//        
//        if paymentID != ""{
//            details["payment_id"] = paymentID
//        }
//        if transactionId != ""{
//            details["transaction_id"] = transactionId
//        }
//        
//        
//        details["payment_type"] = 1
//        
//        print(details)
//      
//        StylzAPIFacade.shared.placeOrder(profDet: details) { (aRes) in
//           
//            DispatchQueue.main.async {
//                loadingIndicator.removeFromSuperview()
//            }
//            print("place order - \(aRes?.json)")
//            
//            if aRes?.statusCode == 200{
//                if aRes?.json?["status"].stringValue == "true"{
//                  
//                    DispatchQueue.main.async {
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.thanks) as! ThanksViewController
//                        self.navigationController?.pushViewController(vc, animated: false)
//                        
//                    }
//                }else{
//                    if let error = aRes?.json?["error"].array{
//                        if error.count > 0{
//                            DispatchQueue.main.async {
//                                showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
//                            }
//                        }else{
//                            DispatchQueue.main.async {
//                                showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                            }
//                        }
//                    }else if let error = aRes?.json?["error"].dictionary{
//                        DispatchQueue.main.async {
//                            showAlert(title: "", subTitle:  error["employee_id"]?.stringValue ?? "" , sender: self)
//                        }
//                    }
//                    else{
//                        DispatchQueue.main.async {
//                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                        }
//                        
//                    }
//                }
//            }
//            else{
//                if let error = aRes?.json?["error"].array{
//                    if error.count > 0{
//                        DispatchQueue.main.async {
//                            showAlert(title: "", subTitle:  error[0].stringValue , sender: self)
//                        }
//                    }else{
//                        DispatchQueue.main.async {
//                            showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                        }
//                    }
//                }else{
//                    DispatchQueue.main.async {
//                        showAlert(title: "", subTitle:  aRes?.json?["error"].stringValue ?? "" , sender: self)
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    func createCard(cardToken : String , cardNumber : String, cardBrand : String){
//        var details = [String:Any]()
//        details["card_token"] = cardToken
//        details["card_number"] = cardNumber
//        details["card_brand"] = cardBrand
//        
//        StylzAPIFacade.shared.createCard(profDet: details) { (aRes) in
//            
//            if aRes?.statusCode == 200{
//                
//            }
//        }
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//    
//    @IBAction func btnBack(_ sender: Any) {
//        if referanceId != ""{
//            dateView?.unlockTime(id: self.referanceId)
//            self.navigationController?.popViewController(animated: false)
//        }else{
//            self.navigationController?.popViewController(animated: false)
//            
//        }
//    }
//    
//    @IBAction func btnPromo(_ sender: Any) {
//        if txtPromo.text == "" || self.promoApplied == true{
//            showAlert(title: "", subTitle: LocalizationSystem.sharedInstance.localizedStringForKey(key: "promoAplied", comment: ""), sender: self)
//            return
//        }
//        
//        applyPromo()
//    }
//    
//    @IBAction func btnAddNewCard(_ sender: Any) {
//        seletedCard = -1
//        // initilizePayment()
//        viewPayment.isHidden = false
//    }
//    
//    @IBAction func btnPayment(_ sender: UIButton) {
//        
//        if sender.tag == 0{
//            DispatchQueue.main.async {
//                self.initilizePayment()
//            }
//            
//        }else if sender.tag == 1{
//            DispatchQueue.main.async {
//                self.initilizeApplePayment()
//            }
//            
//        }else{
//            viewPayment.isHidden = true
//        }
//        //        seletedCard = -1
//        //       // initilizePayment()
//        //        viewPayment.isHidden = false
//    }
//    
//    @IBAction func btnCheckout(_ sender: Any) {
//        lockTimeSlote()
//        //        let vc = self.storyboard?.instantiateViewController(withIdentifier:  stryBrdId.payment) as! PaymentViewController
//        //        vc.amount = self.lblTotal.text?.replacingOccurrences(of: " SAR", with: "") ?? "0"
//        //        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
//    
//    
//    @IBAction func btnTypes(_ sender: UIButton) {
//        if sender.tag == 0{
//            btnsubmit.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "two", comment: ""), for: .normal)
//            
//            discountApplied = 0
//            imgTypes[0].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
//            imgTypes[1].image = UIImage(named: "circle_unsel")
//            
//            var totals = [Double]()
//            
//            if isReorde == true{
//                for all in appointments?.services ?? []{
//                    totals.append(Double(all.service_amount ?? "0.0")!)
//                }
//            }else{
//                for all in getCartData()!{
//                    totals.append(Double(all["price"] as? String ?? "0.0")!)
//                }
//            }
//          
//            let total = totals.reduce(0, +)
//            
//            let sum = totals.reduce(0, +)
//           
//            let vat = (15 * sum) / 100
//            
//            self.lblTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(sum)"
//            self.lblVat.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(vat)"
//            
//          //  let discount = (paynowDicountValue * total) / 100 // 15 to dyamic
//            
//         //   print("discoinnt value: \(paynowDicountValue), disoucnt: \(discount)")
//            
//          //  lblSub.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum - discount) )"
//            
//            lblSub.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum - vat))"
//            
//            //            let sum = total -  discount
//            //
//            //            let vat = (15 * sum) / 100
//            
//            
//            //            let attrs3 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
//            //            let attrs4 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
//            //            let attributedString3 = NSMutableAttributedString(string:"\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "place_order", comment: "")) - ", attributes:attrs3 as [NSAttributedString.Key : Any])
//            //            //let price = String.init(format: "%.2f", trensingProducts[indexPath.item].offer_price ?? 0.0)
//            //            let attributedString4 = NSMutableAttributedString(string:"\(sum) SAR", attributes:attrs4 as [NSAttributedString.Key : Any])
//            //            attributedString3.append(attributedString4)
//            //            lblCheckout.attributedText = attributedString3
//            
//            //            lblSub.text = "\(formatPrice(price: sum - discount) ) SAR"
//            //            lblTotal.text =  "\(formatPrice(price: sum)) SAR"
//            //            lblVat.text = "\(formatPrice(price: vat)) SAR"
//            
//            
//            
//            
//            
//            
//        }else{
//            btnsubmit.setTitle( LocalizationSystem.sharedInstance.localizedStringForKey(key: "one", comment: ""), for: .normal)
//            
//            discountApplied = 1
//            imgTypes[0].image = UIImage(named: "circle_unsel")
//            imgTypes[1].image = UIImage(named: checkIfNotMale() == true ? "circle_sel_girl" : "circle_sel_boy")
//            //            self.lblTotal.text = lblPaidTotal.text
//            //            self.lblVat.text = "\(0.0) SAR"
//            
//            var totals = [Double]()
//            
//            if isReorde == true{
//                for all in appointments?.services ?? []{
//                    totals.append(Double(all.service_amount ?? "0.0")!)
//                }
//            }else{
//                for all in getCartData()!{
//                    totals.append(Double(all["price"] as? String ?? "0.0")!)
//                }
//            }
//            
//            
//            
//            let total = totals.reduce(0, +)
//            let discount = (paynowDicountValue * total) / 100  // 15 to dynamic
//            let sum = total -  discount
//            let vat = (15 * sum) / 100
//            
//            print("discoinnt value: \(paynowDicountValue), disoucnt: \(discount)")
//            
//            payNowDiscountedAmount = discount
//            
//            lblSub.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum - vat) )"
//            lblTotal.text =  "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: sum))"
//            lblVat.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: vat))"
//            
//            
//            //            lblSub.text = "\(formatPrice(price: sum - vat) ) SAR"
//            //            lblTotal.text =  "\(formatPrice(price: sum)) SAR"
//            //            lblVat.text = "\(formatPrice(price: vat)) SAR"
//            
//            
//        }
//        
//        if promoApplied == true, let discountObj{
//            if discountValue != 0.0{
//                
//                let total = Double((lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: ""))!)
//                
//                // let total = Double(discountObj.d)
//                
//                //  let vat = (discountValue * total!) / 100
//                
//                let vat = discountObj.discountedAmount ?? 0.0 // 16th May
//                
//                print("!! vat discount \(vat)")
//                
//                self.lblDiscount.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(vat)"
//                
//                let totals = total! - vat
//                
//                self.lblTotal.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(formatPrice(price: totals))"
//                
//                self.promoApplied = true
//                
//            }
//            
//        }
//        
//    }
//    
//    
//    
//    
//}
//
//extension SummeryViewController : UITableViewDataSource, UITableViewDelegate{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return  1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView.tag == 10{
//            return cards.count
//        }else{
//            if isReorde == true{
//                return appointments?.services.count ?? 0
//            }else{
//                return getCartData()?.count ?? 0
//            }
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView.tag == 10{
//            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cardCellId) as! SalonListCell
//            // cell.lblStar.textColor = getThemeColor()
//            
//            cell.lblName.text =  cards[indexPath.row].card_brand
//            cell.lblService.text =  cards[indexPath.row].masked_pan
//            
//            if seletedCard == indexPath.row{
//                cell.imgStar.isHidden = false
//            }else{
//                cell.imgStar.isHidden = true
//            }
//            return cell
//            
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cellId) as! ServiceListCell
//            // cell.lblStar.textColor = getThemeColor()
//            
//            if isReorde == true{
//                let data = appointments?.services[indexPath.row]
//                
//                // cell.lblName.text = data?["customer_name"] as? String ?? ""
//                cell.lblService.text = LocalizationSystem.sharedInstance.getLanguage() == "ar"  ? data?.service_name_ar : data?.service_name_en
//                
//                cell.lblName.text =  data?.employee_first_name
//                cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(data?.service_amount ?? "0.0")"
//                if data?.employee_image != ""{
//                    cell.imgProduct.backgroundColor = UIColor.clear
//                    setImage(imageView: cell.imgProduct, url: data?.employee_image ?? "")
//                }else{
//                    cell.imgProduct.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
//                }
//                
//            }else{
//                let data = getCartData()?[indexPath.row]
//                
//                // cell.lblName.text = data?["customer_name"] as? String ?? ""
//                cell.lblService.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? data?["service_name_ar"] as? String ?? "" : data?["service_name_en"] as? String ?? ""
//                cell.lblName.text =  data?["customer_name"] as? String
//                
//                cell.lblPrice.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) \(data?["price"] as? String ?? "")"
//                
//                if data?["customer_image"] as? String == ""{
//                    cell.imgProduct.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
//                }else{
//                    cell.imgProduct.backgroundColor = UIColor.clear
//                    setImage(imageView: cell.imgProduct, url: data?["customer_image"] as? String ?? "")
//                }
//                
//            }
//            
//            return cell
//            
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView.tag == 10{
//            return 90
//        }else{
//            return 100
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        if tableView.tag == 10{
//            seletedCard = indexPath.row
//            tableView.reloadData()
//            viewPayment.isHidden = false
//            //initilizePayment()
//        }
//    }
//}
//
//
//extension SummeryViewController {
//    func presentAlert(resut: paymentResult) {
//        var displayTitle: String = ""
//        var key: mandatoryEnum = .amount
//        
//        switch resut {
//        case .mandatory(let fields):
//            key = fields
//        default:
//            break
//        }
//        
//        switch  key {
//        case .amount:
//            displayTitle = "Amount"
//        case.country:
//            displayTitle = "Country"
//        case.action_code:
//            displayTitle = "Action Code"
//        case.currency:
//            displayTitle = "Currency"
//        case.email:
//            displayTitle = "Email"
//        case.trackId:
//            displayTitle = "TrackID"
//        case .tokenID:
//            displayTitle = "TokenID"
//        case .cardOperation:
//            displayTitle = "Token Operation"
//        }
//        
//        let alert = UIAlertController(title: "Alert", message: "Check \(displayTitle) Field", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//}
//
//extension SummeryViewController : PKPaymentAuthorizationViewControllerDelegate {
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true, completion: nil)
//        if isSucessStatus == true{
//            DispatchQueue.main.async {
//                self.initializeSDK()
//            }
//        }
//    }
//    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        self.paymentString = UWInitializer.generatePaymentKey(payment: payment) as String
//        isSucessStatus = true
//        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
//}
//
//extension SummeryViewController: Initializer {
//    
//    func prepareModel() -> UWInitializer {
//        
//        let amount = self.lblTotal.text?.replacingOccurrences(of: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: "sar", comment: "")) ", with: "") ?? "0"
//        let model = UWInitializer.init(amount: amount,
//                                       
//                                       email: getUserDetails()?["email"] as? String ?? "",
//                                       zipCode: "",
//                                       currency: "SAR",
//                                       country: "SA",//12
//                                       actionCode: seletedCard == -1 ? "1" : "1" ,
//                                       trackIdCode: referanceId,
//                                       udf1: "",
//                                       udf2: "",
//                                       //isApplePayPaymentTrxn ? "ApplePay" : ""
//                                       udf3:  "" ,
//                                       //isApplePayPaymentTrxn ? paymentString : ""
//                                       //                                     udf5: paymentString,
//                                       udf4: isApplePayPaymentTrxn ? "ApplePay" : "" ,
//                                       udf5: isApplePayPaymentTrxn ? paymentString as NSString : "",
//                                       city: "",
//                                       address: "",
//                                       createTokenIsEnabled: true ,
//                                       merchantIP: "" ,
//                                       cardOper: seletedCard == -1 ? "A" : "A/U/D", merchantidentifier : "merchant.me.stylz.app",
//                                       tokenizationType: "1")
//        
//        
//        return model
//        
//    }
//    
//    func didPaymentResult(result: paymentResult, error: Error?, model: PaymentResultData?) {
//        switch result {
//            
//        case .sucess:
//            
//            self.placeOrder(paymentID: model?.paymentID ?? "", transactionId: model?.transID ?? "")
//            
//            //            DispatchQueue.global(qos: .userInitiated).async {
//            //                self.createCard(cardToken: model?.tokenID ?? "", cardNumber: model?.maskedPan ?? "", cardBrand: model?.cardBrand ?? "")
//            //            }
//        case.failure:
//            DispatchQueue.main.async {
//                
//                let alertController = UIAlertController(title: "Payment Failed!", message: "Please try again later", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
//                    UIAlertAction in
//                    self.navigationController?.popViewController(animated: true)
//                }
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//            
//            
//            
//            
//        case .mandatory(let fieldName):
//            print(fieldName)
//            break
//        }
//    }
//    
//    func navigateTOReceptPage(model: PaymentResultData?) {
//        //        self.paymentController?.navigationController?.popViewController(animated: true)
//        //        print("Navigate to receipt")
//        //        let controller = ReceptConfiguration.setup()
//        //        controller.model = model
//        //        controller.modalPresentationStyle = .overFullScreen
//        //        self.present(controller, animated: true, completion: nil)
//    }
//    
//}
//
//
//extension SummeryViewController{
//    
//    
//    func setDiscoutSourceString(discountType:String){
//        if discount_source == ""{
//            discount_source = discountType
//        }
//        else{
//            discount_source = "\(discount_source),\(discountType)"
//        }
//    }
//    
//    
//        func getTotalAmount() -> Double{
//            var totals = [Double]()
//    
//            if isReorde == true{
//                for all in appointments?.services ?? []{
//                    totals.append(Double(all.service_amount ?? "0.0")!)
//                }
//            }
//            else{
//                for all in getCartData()!{
//                    totals.append(Double(all["price"] as? String ?? "0.0")!)
//                }
//            }
//    
//            let total = totals.reduce(0, +)
//            return total
//        }
//    
//}
//
//
