//
//  Employee.swift
//  StylzWebkit
//
//  Created by WC_Macmini on 06/03/23.
//


import UIKit
import SwiftyJSON

public class Employee: JSONAble {
    public var id : Int?
    public var employee : Int?
    public var price : String?
    public var first_name : String?
    public var last_name : String?
    public var reference_id : String?
    public var image : String?
    public var employee_rating : String?
    public var phone : String?
    public var email : String?
    public var branchNameEn : String?
    public var branchNameAr : String?
    public var branchId : Int?

    public var employee__first_name : String?
    public var employee__last_name : String?
    public var total_amount : String?
    
    
    public var services = [ Services ]()
    
    public init(json:JSON) {
        id = json["id"].int
        employee = json["employee"].int
        price = json["price"].intToSafeString()
        first_name = json["first_name"].string
        last_name = json["last_name"].string
        reference_id = json["reference_id"].string
        image = json["image"].string
        phone = json["phone"].string
        email = json["email"].string
        employee_rating = json["employee_rating"].intToSafeString()
        
        
        employee__first_name = json["employee__first_name"].string
        employee__last_name = json["employee__last_name"].string
        total_amount = json["total_amount"].intToSafeString()
        
        if let choice = json["employee_branch"].dictionary {
            branchNameEn = choice["name_en"]?.string
            branchNameAr = choice["name_ar"]?.string
            branchId = choice["id"]?.int
        }
        
        if let choice = json["employee_service"].array {
            for prodtJson in choice {
                let item = Services(json: prodtJson)
                services.append(item)
            }
        }
    }
}
