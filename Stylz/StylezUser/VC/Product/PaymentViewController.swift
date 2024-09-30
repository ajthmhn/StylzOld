//
//  PaymentViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 18/09/23.
//


import UIKit
import Urway

class PaymentViewController: UIViewController {

    var paymentController: UIViewController? = nil
    var amount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let terminalId = "stylz"
        let password = "stylz@URWAY"
        let merchantKey = "4d41678c4b6309ca358e689be3db9cf3ec33c0e317b4d9c737846d38ff3565fe"
        let url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest"
     
        UWConfiguration(password: password , merchantKey: merchantKey , terminalID: terminalId , url: url )

        
        UWInitialization(self) { (controller , result) in
            self.paymentController = controller
            guard let nonNilController = self.paymentController else {
                self.presentAlert(resut: result)
                return
            }
            print("initialSDK")
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(nonNilController, animated: true)
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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

extension PaymentViewController {
    func presentAlert(resut: paymentResult) {
          var displayTitle: String = ""
          var key: mandatoryEnum = .amount

          switch resut {
          case .mandatory(let fields):
              key = fields
          default:
              break
          }
          
          switch  key {
          case .amount:
              displayTitle = "Amount"
          case.country:
              displayTitle = "Country"
          case.action_code:
              displayTitle = "Action Code"
          case.currency:
              displayTitle = "Currency"
          case.email:
              displayTitle = "Email"
          case.trackId:
              displayTitle = "TrackID"
          case .tokenID:
            displayTitle = "TokenID"
          case .cardOperation:
            displayTitle = "Token Operation"
        }
          
          let alert = UIAlertController(title: "Alert", message: "Check \(displayTitle) Field", preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
     
}

extension PaymentViewController: Initializer {

  func prepareModel() -> UWInitializer {
   
        let model = UWInitializer.init(amount: amount,

                                       email: getUserDetails()?["email"] as? String ?? "",
                                       zipCode: "",
                                       currency: "SAR",
                                       country: "SA",
                                       actionCode: "1" ,
                                       trackIdCode: "123",
                                       udf1: "",
                                       udf2: "",
                                       //isApplePayPaymentTrxn ? "ApplePay" : ""
                                       udf3:  "" ,
                                       //isApplePayPaymentTrxn ? paymentString : ""
                                       //                                     udf5: paymentString,
                                       udf4: "" ,
                                       udf5: "",
                                       city: "",
                                       address: "",
                                       createTokenIsEnabled: true ,
                                       merchantIP: "" ,
                                       cardToken: "",
                                       cardOper: "A", tokenizationType: "0")
//                                       ,
//                                       holderName: holderField.text)
        return model
    }

    func didPaymentResult(result: paymentResult, error: Error?, model: PaymentResultData?) {
        switch result {
            
        case .sucess:
            print("PAYMENT SUCESS",model)
            DispatchQueue.main.async {
                self.navigateTOReceptPage(model: model)
            }
            
        case.failure:
            
            print("PAYMENT FAILURE",model)
            DispatchQueue.main.async {
                self.navigateTOReceptPage(model: model)
            }
            
          
        case .mandatory(let fieldName):
            print(fieldName)
            break
        }
    }
    
    func navigateTOReceptPage(model: PaymentResultData?) {
//        self.paymentController?.navigationController?.popViewController(animated: true)
//        print("Navigate to receipt")
//        let controller = ReceptConfiguration.setup()
//        controller.model = model
//        controller.modalPresentationStyle = .overFullScreen
//        self.present(controller, animated: true, completion: nil)
        
       
     
       
    }
    
}
