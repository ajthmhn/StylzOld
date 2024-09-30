//
//  Services.swift
//  StylesWebKit
//
//  Created by Ajith Mohan on 12/09/23.
//

import UIKit
import SwiftyJSON

public class Services: JSONAble {
    public var id : Int?
    public var service : Int?
    public var name_en : String?
    public var name_ar : String?
    public var description_en : String?
    public var description_ar : String?
    public var duration : String?
    public var amount : String?
    public var service_status : Int?
    
    public var service__name_en : String?
    public var service__name_ar : String?
    public var total_amount : String?
    public var discount_coupon : String?
    public var discount_value : Double?
    
    
    public var employees = [ Employee]()

    
    public init(json:JSON) {
        id = json["id"].int
        service = json["service"].int
        name_en = json["name_en"].string
        name_ar = json["name_ar"].string
        description_en = json["description_en"].string
        description_ar = json["description_ar"].string
        duration = json["duration"].string
        amount = json["amount"].intToSafeString()
        service_status = json["service_status"].int
        
        service__name_en = json["service__name_en"].string
        service__name_ar = json["service__name_ar"].string
        total_amount = json["total_amount"].intToSafeString()
        discount_coupon = json["discount_coupon"].string
        discount_value = json["discount_value"].double
        
        if let choice = json["service_employees"].array {
            for prodtJson in choice {
                let item = Employee(json: prodtJson)
                employees.append(item)
            }
        }
        
    }
}
