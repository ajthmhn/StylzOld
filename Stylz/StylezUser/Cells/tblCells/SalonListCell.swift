//
//  SalonListCell.swift
//  StylezUser
//
//  Created by Ajith Mohan on 10/08/23.
//

import UIKit
import StylesWebKit

class SalonListCell: UITableViewCell {

    @IBOutlet var lblStar : UILabel!
    @IBOutlet var imgStar : UIImageView!
    @IBOutlet var viewBg : UIView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var lblStatus : UILabel!
    @IBOutlet var lblService : UILabel!
    @IBOutlet var viewStatus : [UIView]!
    @IBOutlet var tblHeight : NSLayoutConstraint!
    
    @IBOutlet var lblEmploName : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var tblService: UITableView!
    @IBOutlet var lblPaid : UILabel!
    @IBOutlet var viewPaid : [UIView]!

    @IBOutlet var imgshop : UIImageView!

    var services = [ AppointmentService ]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SalonListCell : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "service_cell_id") as! SalonListCell
        cell.lblName.text = services[indexPath.row].employee_first_name
        cell.lblService.text = LocalizationSystem.sharedInstance.getLanguage() == "ar" ? services[indexPath.row].service_name_ar :  services[indexPath.row].service_name_en
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
