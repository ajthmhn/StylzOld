//
//  JSONAble.swift
//  Zaska
//
//  Created by Isletsystems on 22/09/16.
//  Copyright © 2016 Zaska. All rights reserved.
//

import UIKit
import SwiftyJSON

public class JSONAble: NSObject {
    
    public class func fromJSON(_: [String:AnyObject]) -> JSONAble {
        return JSONAble()
    }
    
    public class func fromJSONData(_: Data) -> JSONAble {
        return JSONAble()
    }
}

extension JSON {
    
    func stringSafeInt() -> Int{
        if let str = self.string {
            return Int(str) ?? 0
        }else if let val = self.int {
            return val
        }
        return  0
    }
    
    func intToSafeString() -> String{
        if let str = self.int {
            return String(str)
        }else if let val = self.float {
            return  String(val)
        }else if let str = self.string{
            return str
        }
        return  "0.0"
    }
    
    func stringSafeBool() -> Bool{
        if let str = self.string {
            if let anInt = Int(str) {
                return anInt > 0
            }
            return self.boolValue
        }else if let val = self.int {
            return val > 0
        }
        return  false
    }
    
}
