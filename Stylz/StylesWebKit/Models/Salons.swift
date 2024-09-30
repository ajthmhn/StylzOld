//
//  Salons.swift
//  StylesWebKit
//
//  Created by Ajith Mohan on 12/09/23.
//

import UIKit
import SwiftyJSON

public class Salons: JSONAble {
    public var id : Int?
    public var name_en : String?
    public var name_ar : String?
    public var address_region : String?
    public var vat_reg_number : String?
    public var invoice_address : String?
    public var insta_link : String?
    public var salon_rating : Double?
    public var is_favorite : Int?
    public var latitude : String?
    public var longitude : String?
    
    public var salon_images = [String]()
    
    public init(json:JSON) {
        id = json["id"].int
        name_en = json["name_en"].string
        name_ar = json["name_ar"].string
        address_region = json["address_region"].string
        vat_reg_number = json["vat_reg_number"].string
        invoice_address = json["address_region"].string
        insta_link = json["insta_link"].string
        salon_rating = json["salon_rating"].double
        is_favorite = json["is_favorite"].int
        latitude = json["latitude"].string
        longitude = json["longitude"].string
        
        if let imagess = json["salon_images"].array {
                   for prodtJson in imagess {
                       let item = prodtJson["image"].stringValue
                       salon_images.append(item)
                   }
               }
    }
}
