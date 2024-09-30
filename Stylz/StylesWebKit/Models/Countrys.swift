//
//  Countrys.swift
//  StylesWebKit
//
//  Created by Ajith Mohan on 12/09/23.
//

import UIKit
import SwiftyJSON

public class Countrys: JSONAble {
    public var id : Int?
    public var name : String?
    public var nicename : String?
    public var iso : String?
    public var phonecode : String?
    
    public init(json:JSON) {
        id = json["id"].int
        name = json["name"].string
        nicename = json["nicename"].string
        iso = json["iso"].string
        phonecode = json["phonecode"].string
    }
}
