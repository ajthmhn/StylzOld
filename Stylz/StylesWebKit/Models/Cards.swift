//
//  Cards.swift
//  StylesWebKit
//
//  Created by Ajith Mohan on 19/09/23.
//

import UIKit
import SwiftyJSON

public class Cards: JSONAble {
    public var id : Int?
    public var card_token : String?
    public var masked_pan : String?
    public var card_brand : String?
    
    public init(json:JSON) {
        id = json["id"].int
        card_token = json["card_token"].string
        masked_pan = json["masked_pan"].string
        card_brand = json["card_brand"].string
    }
    
}
