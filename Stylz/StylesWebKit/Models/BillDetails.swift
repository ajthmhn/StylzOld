//
//  BillDetails.swift
//  StylzWebkit
//
//  Created by WC_Macmini on 15/03/23.
//
import UIKit
import SwiftyJSON

public class BillDetails: JSONAble {
    public var id : Int?
    public var invoice_number : String?
    public var payment_method : Int?
    public var total_amount : String?
    public var actual_amount : String?
    public var discounted_amount : String?
    public var invoice_encrypted : String?
    public var qr_image : String?
    
    
    public init(json:JSON) {
        id = json["id"].int
        invoice_number = json["invoice_number"].string
        payment_method = json["payment_method"].int
        total_amount = json["total_amount"].intToSafeString()
        actual_amount = json["actual_amount"].intToSafeString()
        discounted_amount = json["discounted_amount"].intToSafeString()
        invoice_encrypted = json["discounted_amount"].intToSafeString()
        qr_image = json["invoice_number"].string
        
    }
}

