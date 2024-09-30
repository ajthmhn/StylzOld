//
//  Timings.swift
//  StylzWebkit
//
//  Created by WC_Macmini on 14/03/23.
//

import UIKit
import SwiftyJSON

public class Timings: JSONAble {
    public var start_time : String?
    public var end_time : String?
    public var formatted_start_time : String?
    public var formatted_end_time : String?
    
    public init(json:JSON) {
        start_time = json["start_time"].string
        end_time = json["end_time"].string
        formatted_start_time = json["formatted_start_time"].string
        formatted_end_time = json["formatted_end_time"].string
    }
}
