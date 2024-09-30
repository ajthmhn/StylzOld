//
//  WalletViewController.swift
//  StylezUser
//
//  Created by Ajith Mohan on 19/09/23.
//

import UIKit
import StylesWebKit

class WalletViewController: UIViewController {

    struct VCConst {
        static let cardCellId = "cards_cell_id"
    }
    
    @IBOutlet var tblCards : UITableView!
    @IBOutlet var lblHead : UILabel!


    
    var cards = [Cards]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCard()
        lblHead.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "wallet", comment: "")
        
        
    }
    
    func deleteCard(id :Int ){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)

        StylzAPIFacade.shared.deleteCard(id: id) { (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
               if aRes?.json?["status"].stringValue == "true"{
                   self.getCard()
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
    
    func getCard(){
        let loadingIndicator = UIActivityIndicatorView(frame: self.view.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating();
        
        self.view.addSubview(loadingIndicator)
        self.cards.removeAll()
        
      //  appointments.removeAll()
        
        StylzAPIFacade.shared.getCard{ (aRes) in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()
            }
            if aRes?.statusCode == 200{
                    if let data = aRes?.json?["data"].array{
                            for m in data{
                                let booking = Cards(json: m)
                              self.cards.append(booking)
                            }
                    }
                DispatchQueue.main.async {
                    self.tblCards.reloadData()
                }
                
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension WalletViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCConst.cardCellId) as! ServiceListCell
        // cell.lblStar.textColor = getThemeColor()
        
        cell.lblName.text =  cards[indexPath.row].card_brand
        cell.lblService.text =  cards[indexPath.row].masked_pan
        
        cell.deleteTappedActions { aCell in
            let alertController = UIAlertController(title: "", message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "delete_card", comment: ""), preferredStyle: .alert)
                        let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "yes", comment: ""), style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                
                            self.deleteCard(id: self.cards[indexPath.row].id ?? 0)
                                
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
        return 100
    }
    
}
