//
//  StylzAPIResponse.swift
//  Party
//
//  Created by Isletsystems on 22/09/16.
//  Copyright © 2016 Party. All rights reserved.
//

import UIKit
import SwiftyJSON

public class StylzAPIResponse: JSONAble {
    
    public var json: JSON?
    public var data: Data?
    public var success: Bool?
    public var statusCode: Int?
    
    override init() {
    }
    
    init(success: Bool?, data: Data?, json: JSON?) {
        self.success = success
        self.data = data
        if data != nil {
            do{
                self.json = try JSON(data:data!)
            }
            catch {/* error handling here */}
        }
    }
    
    convenience init(jsonData:Data?) {
        self.init(success:true, data: jsonData, json:nil)
    }
    
    convenience init(resp:StylzAPIResponse?) {
        self.init(success: resp?.success, data:resp?.data , json: resp?.json)
    }
    
    override public class func fromJSONData(_ jsonData:Data) -> JSONAble {
        var json = JSON()
        do{
            json = try JSON(data:jsonData)
            debugPrint(String.init(data: jsonData, encoding: .utf8) ?? "")
        }
        catch {/* error handling here */}
        return StylzAPIResponse(success:true, data:jsonData, json:json)
    }
    
    public func isSuccess()->Bool {
        return success ?? false
    }
    
    public func sessionIDExpired() -> Bool {
        return false
    }
    
}
