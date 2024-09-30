//
//  AppointmentService.swift
//  StylzWebkit
//
//  Created by WC_Macmini on 14/03/23.
//

import UIKit
import SwiftyJSON

public class AppointmentService: JSONAble {
    public var id : Int?
    public var appointment_id : Int?
    public var date : String?
    public var start_time : String?
    public var end_time : String?
    public var appointment_status : Int?
    public var service_id : Int?
    public var service_name_en : String?
    public var service_name_ar : String?
    public var service_duration : String?
    public var service_amount : String?
    public var employee_id : Int?
    public var employee_first_name : String?
    public var employee_service_price : String?
    public var employee_image : String?
    

    
    public init(json:JSON) {
        id = json["id"].int
        appointment_id = json["appointment_id"].int
        date = json["date"].string
        start_time = json["start_time"].string
        end_time = json["end_time"].string
        appointment_status = json["appointment_status"].int
        service_id = json["service_id"].int
        service_name_en = json["service_name_en"].string
        service_name_ar = json["service_name_ar"].string
        service_duration = json["service_duration"].string
        service_amount = json["service_amount"].intToSafeString()
        employee_id = json["employee_id"].int
        employee_first_name = json["employee_first_name"].string
        employee_image = json["employee_image"].string
        employee_service_price = json["employee_service_price"].intToSafeString()
    }
}
