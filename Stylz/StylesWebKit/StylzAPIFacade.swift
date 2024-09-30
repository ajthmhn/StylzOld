//
//  StylzAPIFacade.swift
//  PartyManager
//
//  Created by islet on 14/12/16.
//  Copyright © 2016 islet. All rights reserved.
//

//
//  StylzAPIFacade.swift
//  Party
//
//  Created by Isletsystems on 22/09/16.
//  Copyright © 2016 Party. All rights reserved.
//

import UIKit
import SwiftyJSON

public typealias StylzAPICompletion = (StylzAPIResponse?) -> Void

public class StylzAPIFacade: NSObject {
    struct StylzAPIFacadeConst{
        static let clientId = 2
        static let clientKey = "FEZbPoNvx3vMxP2H1UsP1kCTTVmbxaNlbSuqo7J0"
    }
    public var session : StylzAPISession?
    public class var shared : StylzAPIFacade {
        struct Singleton {
            static let instance = StylzAPIFacade()
        }
        return Singleton.instance
    }
    
    override init() {
        
        StylzAPIProviderFactory.offlineMode = false
        session = StylzAPISession.init()
    }
    
    public func setOfflineMode(_ flag:Bool) {
        StylzAPIProviderFactory.offlineMode = flag
    }
    
    
    public func deleteAccount(completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.deletAccount) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    //MARK: - discount
    public func getDiscount(completion:StylzAPICompletion?) {
        
        StylzAPIProviderFactory.sharedProvider.request(.getDiscount) { result in
            
            switch result {
          
            case let .success(moyaResponse):
             
                let jsonData = moyaResponse.data
                
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    
                    if YKRes.json?["detail"].stringValue == "Authentication credentials were not provided."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    
                    return
                }
                
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
                
            }
        }
    }
    
    public func signUp(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.signUp(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
        
    public func login(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.login(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    if YKRes.json?["status"].boolValue == true {
                        if let data = YKRes.json?["data"].dictionary{
                            let verified = data["email_verification_status"]?.boolValue
                            if verified == true{
                                if YKRes.json != nil{
                                    self.extractUserSession(YKRes.json!)
                                    self.extractUserDetails(YKRes.json!)
                                }
                            }
                        }
                    }
                    
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func loginPhone(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.loginPhone(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func logout(completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.logout) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func verifyOtp(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.verifyOtp(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    if YKRes.json?["status"].boolValue == true {
                        if YKRes.json != nil{
                            self.extractUserSession(YKRes.json!)
                            self.extractUserDetails(YKRes.json!)
                        }
                    }
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getCountry(completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getCountry) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func verifyLoginOtp(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.verifyLoginOtp(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    if YKRes.json?["status"].boolValue == true {
                        if YKRes.json != nil{
                            self.extractUserSession(YKRes.json!)
                            self.extractUserDetails(YKRes.json!)
                        }
                    }
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func sendOtpLogin(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.sendOtpLogin(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getCategory( profDet:[String:Any] , completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getCategory(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func searchAll(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.searchAll(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getServices(id:Int ,gender: Int , completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getservices(shopId: id, gender: gender)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getEmployees(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getEmployees(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getOffers(id:Int ,  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getOffers(shopId: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func checkAvailability(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.checkAvailability(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func top10Salons(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.top10Slons(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func allBarbers(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.allBarber(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func orderHIstory(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.orderHIstory(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getAppointments(date:String,gender : Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getAppointMents(date: date,gender: gender)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getAllAppointments(gender : Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getAllAppointmnents(gender: gender)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func resceduleAppointment(id : Int,date:String, startTime: String, endTime : String, salonId : Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.resceduleAppoint(id: id, date: date, startTime: startTime, endTime: endTime, salonId: salonId)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func cancelAppointment(id:Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.cancelAppointment(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func updateProfile(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.updateProfile(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    if YKRes.json?["status"].boolValue == true {
                        if YKRes.json != nil{
                            self.extractUserDetails(YKRes.json!)
                        }
                    }
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getNotifications(page : Int,gender : Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getNotifications(page: page, gender: gender)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func createAddress(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.createAddress(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func addressList(completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.addressList) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func deleteAddress(id:Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.deleteAddress(page: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func updatePhone(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.updatePhone(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func updateEmail(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.updateEmail(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func lockTimeSlote(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.lockTimeSlote(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func unlockTime(id:String, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.unlockTime(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func placeOrder(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.placeOrder(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func createCard(profDet:[String:Any], completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.createCard(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getCard(completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getCard) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func deleteCard(id : Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.deleteCard(id: id)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func applyPrmo(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.applyPromo(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func forgotPassword(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.forgotPassword(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func updatePassword(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.updatePassword(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func getBranches(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.getBranches(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func changePassword(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.changePassword(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func makeFavourite(id : Int, status : Int , gender: Int,  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.makeFavourite(id: id, status: status, gender: gender)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func mySalons(gender : Int, completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.mySalons(gender: gender)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    
    public func checkFavourite(id: Int,gender: Int,  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.checkFaourite(shopid: id, gender: gender)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func updateToken(profDet:[String:Any],  completion:StylzAPICompletion?) {
        StylzAPIProviderFactory.sharedProvider.request(.updateToken(profDetails: profDet)) { result in
            switch result {
            case let .success(moyaResponse):
                let jsonData = moyaResponse.data
                if let YKRes = StylzAPIResponse.fromJSONData(jsonData) as? StylzAPIResponse {
                    YKRes.statusCode = moyaResponse.statusCode
                    completion?(YKRes)
                    if YKRes.json?["detail"].stringValue == "Invalid token."{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("session_reset"), object: nil)
                    }
                    return
                }
            case .failure(_):
                completion?(StylzAPIResponse(success:false, data: nil, json: nil))
            }
        }
    }
    
    public func resetSession() {
        self.session?.token = nil
    }
    
    public func extractUserSession(_ json:JSON) {
            if let data = json["data"].dictionary{
                self.session?.token = data["token"]?.stringValue
                self.session?.UserId = data["user_id"]?.intValue
            }
        }
        
        public func extractUserDetails(_ json:JSON) {
            if let data = json["data"].dictionary{
                if let user = data["user_details"]{
                    let users = User(json: user)
                    self.session?.currentUser = users
                }
            }
        }

    
    public func extractUserDetailsFromPofile(_ json:JSON) {
        let user = User(json:json["data"])
        self.session?.currentUser = user
    }

    // MARK: - image path
    public func urlForImage(imagePath:String) -> URL?{
        let path = StylzAPIConfig.BaseUrl.baseServerpath + "uploads/" + imagePath
        return URL(string: path)
    }
}


