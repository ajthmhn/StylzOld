//
//  Categories.swift
//  StylesWebKit
//
//  Created by Ajith Mohan on 12/09/23.
//

import UIKit
import SwiftyJSON

public class Categories: JSONAble {
    public var id : Int?
    public var name_en : String?
    public var name_ar : String?
    public var service_category_icon : String?
    
    public var services = [ Services]()
    
    public init(json:JSON) {
        id = json["id"].int
        name_en = json["name_en"].string
        name_ar = json["name_ar"].string
        service_category_icon = json["service_category_icon"].string
        
        if let choice = json["services"].array {
            for prodtJson in choice {
                let item = Services(json: prodtJson)
                services.append(item)
            }
        }
    }
}
