//
//  StylzAPIProvider.swift
//  Party
//
//  Created by Isletsystems on 22/09/16.
//  Copyright © 2016 Party. All rights reserved.
//

import UIKit
import Moya
import Alamofire


public struct StylzAPIProviderFactory {
    
    
    static let endpointsClosure:(StylzAPI)->Endpoint = { (target: StylzAPI) -> Endpoint in
        
        var endpoint: Endpoint = Endpoint(
            url: url(target),
            sampleResponseClosure:{ .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
            //            task: target.task
        )
        
        // Sign all non-SignIn requests as they need the SessionID to proceed
        switch target {
        case .login(_),.signUp(_), .getCountry, .loginPhone(_),.verifyOtp(_), .sendOtpLogin(_), .verifyLoginOtp(_):
            return endpoint.adding(newHTTPHeaderFields: ["Accept":"*/*","Content-Type" : "application/json"])
        default:
            var header = ""
            if let token = StylzAPIFacade.shared.session?.token {
                header = "\(token)"
            }
            
            print(header)
            if header == ""{
                return endpoint.adding(newHTTPHeaderFields: ["Accept":"*/*","Content-Type" : "application/json"])

            }else{
               print(["Accept":"*/*","Content-Type" : "application/json","Authorization": "Token \(header)"])
                
                return endpoint.adding(newHTTPHeaderFields: ["Accept":"*/*","Content-Type" : "application/json","Authorization": "Token \(header)"])

            }
        }
    }
    
    public static var offlineMode : Bool = false
    
    static func stubOrNot(_: StylzAPI) -> Moya.StubBehavior {
        return offlineMode ? .immediate : .never //.delayed(seconds: 1.0)
    }
    
    public static func DefaultProvider() -> MoyaProvider<StylzAPI> {
        return MoyaProvider<StylzAPI>(endpointClosure: endpointsClosure,
                                      stubClosure: stubOrNot,
                                      plugins: StylzAPIProviderFactory.plugins)
    }
    
    public static func StubbingProvider() -> MoyaProvider<StylzAPI> {
        return MoyaProvider(endpointClosure: endpointsClosure, stubClosure: MoyaProvider.immediatelyStub)
    }
    
    fileprivate struct SharedProvider {
        static var instance = StylzAPIProviderFactory.DefaultProvider()
    }
    
    public static var sharedProvider: MoyaProvider<StylzAPI> {
        get {
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
    }
    
    static var plugins: [PluginType] {
        return [
            StylzAPINetworkLogger(whitelist: { (target:TargetType) -> Bool in
                switch target as! StylzAPI {
                case .login: return true
                default: return true
                }
            }, blacklist: { (target:TargetType) -> Bool in
                switch target as! StylzAPI {
                case .login(_): return true
                default: return false
                }
            })
        ]
    }
}
