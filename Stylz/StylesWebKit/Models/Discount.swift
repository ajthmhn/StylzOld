//
//  Discount.swift
//  StylesWebKit
//
//  Created by abcd on 16/05/2024.
//

import Foundation
import SwiftyJSON

public class Discount:JSONAble{
        
        
    public var discountID:Int?
        public var name_en:String?
        public var name_ar:String?
        public var discountType:Int?

        public var discountValue:Double?
        public var discountedAmount:Double?
        
    
    public override init() {
        
    }
    
    public init(json:JSON?) {
        discountID = json?["discount_id"].int
        name_en = json?["name_en"].string
        name_ar = json?["name_ar"].string
        discountType = json?["discount_type"].intValue
        discountValue = json?["discount_value"].doubleValue
        discountedAmount = json?["discounted_amount"].doubleValue
     }
}
