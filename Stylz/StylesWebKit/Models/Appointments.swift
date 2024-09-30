//
//  Appointments.swift
//  StylzWebkit
//
//  Created by WC_Macmini on 14/03/23.
//

import UIKit
import SwiftyJSON

public class Appointments: JSONAble {
    public var id : Int?
    public var reference_id : String?
    public var appointment_status : Int?
    public var customer_prepaid : Int?
    public var salon_id : Int?
    public var salon_name_ar : String?
    public var salon_name_en : String?
    public var salon_address : String?
    public var salon_address_region : String?
    public var salon_latitude : Double?
    public var salon_longitude : Double?
    public var vat_reg_number : String?
    public var date : String?
    public var start_time : String?
    public var end_time : String?
    public var paid_amount : Double?
    public var service_amount : Double?
    
    
    public var customerId : Int?
    public var customerName : String?
    public var customerPhone : String?
    public var customerEmail : String?
    public var customerImage : String?
    
    public var services = [ AppointmentService ]()
    public var billDetails = [ BillDetails ]()

    
    public init(json:JSON) {
        id = json["id"].int
        reference_id = json["reference_id"].string
        appointment_status = json["appointment_status"].int
        customer_prepaid = json["customer_prepaid"].int
        salon_id = json["salon_id"].int
        salon_name_ar = json["salon_name_ar"].string
        salon_name_en = json["salon_name_en"].string
        salon_address = json["salon_address"].string
        salon_address_region = json["salon_address_region"].string
        salon_latitude = json["salon_latitude"].double
        salon_longitude = json["salon_longitude"].double
        vat_reg_number = json["vat_reg_number"].string
        date = json["date"].string
        start_time = json["start_time"].string
        end_time = json["end_time"].string
        paid_amount = json["paid_amount"].double
        service_amount = json["service_amount"].double
        
        if let choice = json["customer_details"].dictionary {
            customerId = choice["id"]?.int
            customerName = choice["first_name"]?.string
            customerPhone = choice["phone"]?.string
            customerEmail = choice["email"]?.string
            customerImage = choice["image"]?.string
        }
        
        if let choice = json["appointment_services"].array {
            for prodtJson in choice {
                let item = AppointmentService(json: prodtJson)
                services.append(item)
            }
        }
        
        if let choice = json["bill_details"].array {
            for prodtJson in choice {
                let item = BillDetails(json: prodtJson)
                billDetails.append(item)
            }
        }
    }
}
