//
//  Address.swift
//  BiendWebkit
//
//  Created by Ajith Mohan on 27/08/23.
//

import UIKit
import SwiftyJSON


    

public class Addresss: JSONAble {
  
    public var id : Int?
    public var flat : String?
    public var building : String?
    public var street : String?
    public var area : String?
    public var latitude : String?
    public var longitude : String?
    public var is_default : Int?
    public var address : String?
    public var nick_name : String?
    
    
    public init(json:JSON) {
        id = json["id"].int
        building = json["building"].string
        flat = json["flat"].string
        street = json["street"].string
        area = json["area"].string
        latitude = json["latitude"].string
        longitude = json["longitude"].string
        address = json["address"].string
        nick_name = json["nick_name"].string
        is_default = json["is_default"].int
    }
}
