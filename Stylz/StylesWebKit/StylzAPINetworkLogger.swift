//
//  StylzAPINetworkLogger.swift
//  Party
//
//  Created by Isletsystems on 22/09/16.
//  Copyright © 2016 Party. All rights reserved.
//

import UIKit
import Moya
import Result

class StylzAPINetworkLogger:  PluginType {
    
    public typealias Comparison = (TargetType) -> Bool
    
    let whitelist: Comparison
    let blacklist: Comparison
    
    public init(whitelist: @escaping Comparison = { _ -> Bool in return true }, blacklist: @escaping Comparison = { _ -> Bool in  return true }) {
        self.whitelist = whitelist
        self.blacklist = blacklist
    }
    
    public func willSendRequest(_ request: RequestType, target: TargetType){
        // If the target is in the blacklist, don't log it.
        //guard blacklist(target) == false else { return }
        guard let req = request.request else { return }
        // DEBUG CODE
        logger.log("Req.Url: \(req.httpMethod!) \(req.url?.absoluteString ?? String())")
        logger.log("Req.Headers: \(String(describing: req.allHTTPHeaderFields))")
        if let body = req.httpBody {
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "NO BODY"
            logger.log("Req.Body: \(bodyString)")
        }
    }
    
    public func didReceiveResponse(_ result: Result<Moya.Response, Moya.MoyaError>, target: TargetType) {
        // If the target is in the blacklist, don't log it.
        //guard blacklist(target) == false && result.value != nil else { return }
        
        if 200..<400 ~= (result.value?.statusCode ?? 0) && whitelist(target) == false {
            // If the status code is OK, and if it's not in our whitelist, then don't worry about logging its response body.
            logger.log("Res.body: (\(result.value!.statusCode)) from \(target.baseURL.absoluteString ).")
        } else {
            // Otherwise, log everything.
            
            let dataString: NSString?
            if let data = result.value?.data {
                dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "Encoding error"
            } else {
                dataString = "No response body"
            }
            
            logger.log("Res.body: (\(String(describing: result.value?.statusCode ))) from \(target.baseURL.absoluteString): \(String(describing: dataString))")
        }
    }
}
