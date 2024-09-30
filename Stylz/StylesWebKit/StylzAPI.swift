//
//  StylzAPI.swift
//  Party
//
//  Created by Isletsystems on 22/09/16.
//  Copyright © 2016 Party. All rights reserved.
//

import UIKit
import Moya

public enum StylzAPI {
    case signUp(profDetails:[String:Any])
    case login(profDetails:[String:Any])
    case loginPhone(profDetails:[String:Any])
    case verifyOtp(profDetails:[String:Any])
    case verifyLoginOtp(profDetails:[String:Any])
    case sendOtpLogin(profDetails:[String:Any])
    case logout
    case getCountry
    case getCategory(profDetails:[String:Any])
    case searchAll(profDetails:[String:Any])
    case getservices(shopId:Int, gender : Int)
    case getEmployees(profDetails:[String:Any])
    case getOffers(shopId:Int)
    case checkAvailability(profDetails:[String:Any])
    case top10Slons(profDetails:[String:Any])
    case allBarber(profDetails:[String:Any])
    case orderHIstory(profDetails:[String:Any])
    case getAppointMents(date:String, gender : Int)
    case getAllAppointmnents(gender: Int)
    case resceduleAppoint(id:Int, date:String, startTime:String, endTime:String, salonId: Int)
    case cancelAppointment(id:Int)
    case updateProfile(profDetails:[String:Any])
    case getNotifications(page:Int, gender : Int)
    case createAddress(profDetails:[String:Any])
    case addressList
    case deleteAddress(page:Int)
    case updatePhone(profDetails:[String:Any])
    case updateEmail(profDetails:[String:Any])
    case lockTimeSlote(profDetails:[String:Any])
    case unlockTime(id:String)
    case placeOrder(profDetails:[String:Any])
    case createCard(profDetails:[String:Any])
    case getCard
    case deleteCard(id : Int)
    case applyPromo(profDetails:[String:Any])
    case forgotPassword(profDetails:[String:Any])
    case updatePassword(profDetails:[String:Any])
    case changePassword(profDetails:[String:Any])
    case getBranches(profDetails:[String:Any])
    case makeFavourite(id : Int, status:Int, gender : Int)
    case mySalons(gender : Int)
    case checkFaourite(shopid : Int, gender: Int)
    case updateToken(profDetails:[String:Any])
    case deletAccount
    case getDiscount
}


extension StylzAPI: TargetType {
    
    public var headers: [String : String]? {
        return nil
    }
    
    var base: String {
        return  StylzAPIConfig.BaseUrl.baseServerpath + "api/"
        
    }
    
    public var baseURL: URL {
        return URL(string: base)!
    }

    public var path: String {
        switch self {
        case .signUp(_):
            return "user/registration"
        case .login(_):
            return "login"
        case .logout:
            return "logout"
        case .loginPhone(_):
            return "login/send-otp"
        case .verifyOtp(_):
            return "login/confirm-otp"
        case .getCountry:
            return "country/list"
        case .verifyLoginOtp:
            return "verify/account"
        case .sendOtpLogin(_):
            return "account/verify"
        case .getCategory:
            return "categories"
        case .searchAll:
            return "search-all"
        case .getservices:
            return "service-category/list"
        case .getEmployees:
            return "employee/list"
        case .getOffers:
            return "offer/list"
        case .checkAvailability:
            return "appointment/availability"
        case .top10Slons:
            return "top-salons"
        case .allBarber:
            return "salon/list"
        case .orderHIstory:
            return "customer-appointment/order-history"
        case .getAppointMents(_,_):
            return "customer-appointment/list"
        case .getAllAppointmnents(_):
            return "appointment/upcoming-list"
        case .resceduleAppoint(let id, _, _, _, _):
            return "appointment/reschedule/\(id)"
        case .cancelAppointment(let id):
            return "appointment/cancel/\(id)"
        case .updateProfile(_):
            return "profile/update"
        case .getNotifications:
            return "notification/list"
        case .createAddress(_):
            return "customer-address/create"
        case .addressList:
            return "customer-address/details"
        case .deleteAddress:
            return "customer-address/delete"
        case .updatePhone:
            return "customer-phone/update"
        case .updateEmail:
            return "customer-email/update"
        case .lockTimeSlote:
            return "appointment/create-request"
        case .unlockTime:
            return "appointment/delete-request"
        case .placeOrder:
            return "appointment/confirm-request"
        case .createCard:
            return "customer-card/create"
        case .getCard:
            return "customer-card/list"
        case .deleteCard:
            return "customer-card/delete"
        case .applyPromo:
            return "get_discount"
        case .forgotPassword:
            return "password/send_otp"
        case .updatePassword:
            return "password/update"
        case .getBranches(_):
            return "branches"
        case .changePassword(_):
            return "change-password"
        case .makeFavourite(_,_,_):
            return "favorite/shop"
        case .mySalons(_):
            return "mysalons"
        case .checkFaourite(_,_):
            return "favorite/shop/list"
        case .updateToken(_):
            return "fmctoken"
        case .deletAccount:
            return "customer/delete"
            
        case .getDiscount:
            return "global-settings"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case    .signUp(_),
                .login(_),
                .loginPhone(_),
                .verifyOtp(_),
                .verifyLoginOtp(_),
                .sendOtpLogin(_),
                .getCategory,
                .searchAll(_),
                .getservices(_,_),
                .getEmployees(_),
                .getOffers(_),
                .checkAvailability(_),
                .top10Slons(_),
                .allBarber(_),
                .orderHIstory(_),
                .getAppointMents(_,_),
                .getAllAppointmnents(_),
                .resceduleAppoint(_, _, _, _, _),
                .updateProfile(_),
                .getNotifications(_,_),
                .createAddress(_),
                .addressList,
                .deleteAddress(_),
                .updatePhone(_),
                .updateEmail(_),
                .lockTimeSlote(_),
                .unlockTime(_),
                .placeOrder(_),
                .createCard(_),
                .getCard,
                .deleteCard(_),
                .applyPromo(_),
                .forgotPassword(_),
                .updatePassword(_),
                .getBranches(_),
                .changePassword(_),
                .makeFavourite(_,_,_),
                .mySalons(_),
                .checkFaourite(_,_),
                .deletAccount,
                .updateToken(_):
        
            
            return .post
        case
                .logout,
                .getCountry,
                .getDiscount,
            
                .cancelAppointment(_):
               
           return .get

//            return .put
     
        }
    }
    
    public var parameters: [String:Any]? {
        switch self {
        case .signUp(let profDet):
            return profDet
        case .login(let profDet):
            return profDet
        case .logout:
            return nil
        case .loginPhone(let profDet):
            return profDet
        case .verifyOtp(let profDet):
            return profDet
        case .getCountry:
            return nil
        case .verifyLoginOtp(let profDet):
            return profDet
        case .sendOtpLogin(let profDet):
            return profDet
        case .getCategory(let profDet):
            return profDet
        case .searchAll(let profDet):
            return profDet
        case .getservices(let shopId, let gender):
            return ["branch_id":shopId]
        case .getEmployees(let details):
            return details
        case .getOffers(let shopId):
            return ["shop_id":shopId]
        case .checkAvailability(let profDet):
            return profDet
        case .top10Slons(let profDet):
            return profDet
        case .allBarber(let profDet):
            return profDet
        case .orderHIstory(let profDet):
            return profDet
        case .getAppointMents(let date, let gender):
            return ["date":date, "gender" : gender]
        case .getAllAppointmnents(let gender):
            return ["gender" : gender]
        case .resceduleAppoint(_,let date,let startTime, let endTime, let salonId):
            return ["date":date, "start_time":startTime, "end_time":endTime, "branch_id" : salonId]
        case .cancelAppointment:
            return nil
        case .updateProfile(let profDet):
            return profDet
        case .getNotifications(let page, let gender):
            return ["page":page, "gender" : gender]
        case .createAddress(let profDet):
            return profDet
        case .addressList:
            return nil
        case .deleteAddress(let page):
            return ["address_id":page]
        case .updatePhone(let profDet):
            return profDet
        case .updateEmail(let profDet):
            return profDet
        case .lockTimeSlote(let profDet):
            return profDet
        case .unlockTime(let date):
            return ["reference_id":date]
        case .placeOrder(let profDet):
            return profDet
        case .createCard(let profDet):
            return profDet
        case .getCard:
            return nil
        case .deleteCard(let date):
            return ["card_id":date]
        case .applyPromo(let profDet):
            return profDet
        case .forgotPassword(let profDet):
            return profDet
        case .updatePassword(let profDet):
            return profDet
        case .getBranches(let profDet):
            return profDet
        case .changePassword(let profDet):
            return profDet
        case .makeFavourite(let id, let status, let gender):
            return ["shop_id":id,"favorite_status":status, "gender" : gender]
        case .mySalons(let gender):
            return ["gender" : gender]
        case .checkFaourite(shopid: let status, let gender):
            return ["shop_id":status, "gender" : gender]
        case .updateToken(let profDet):
            return profDet
        case .deletAccount:
            return nil
            
        case .getDiscount:
            return nil
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .signUp:
            return stubbedResponse("")
        case .login:
            return stubbedResponse("")
        case .logout:
            return stubbedResponse("")
        case .loginPhone:
            return stubbedResponse("")
        case .verifyOtp:
            return stubbedResponse("")
        case .getCountry:
            return stubbedResponse("")
        case .verifyLoginOtp:
            return stubbedResponse("")
        case .sendOtpLogin:
            return stubbedResponse("")
        case .getCategory:
            return stubbedResponse("")
        case .searchAll:
            return stubbedResponse("")
        case .getservices:
            return stubbedResponse("")
        case .getEmployees:
            return stubbedResponse("")
        case .getOffers:
            return stubbedResponse("")
        case .checkAvailability:
            return stubbedResponse("")
        case .top10Slons:
            return stubbedResponse("")
        case .allBarber:
            return stubbedResponse("")
        case .orderHIstory:
            return stubbedResponse("")
        case .getAppointMents:
            return stubbedResponse("")
        case .getAllAppointmnents:
            return stubbedResponse("")
        case .resceduleAppoint:
            return stubbedResponse("")
        case .cancelAppointment:
            return stubbedResponse("")
        case .updateProfile:
            return stubbedResponse("")
        case .getNotifications:
            return stubbedResponse("")
        case .createAddress:
            return stubbedResponse("")
        case .addressList:
            return stubbedResponse("")
        case .deleteAddress:
            return stubbedResponse("")
        case .updatePhone:
            return stubbedResponse("")
        case .updateEmail:
            return stubbedResponse("")
        case .lockTimeSlote:
            return stubbedResponse("")
        case .unlockTime:
            return stubbedResponse("")
        case .placeOrder:
            return stubbedResponse("")
        case .createCard(_):
            return stubbedResponse("")
        case .getCard:
            return stubbedResponse("")
        case .deleteCard:
            return stubbedResponse("")
        case .applyPromo:
            return stubbedResponse("")
        case .forgotPassword:
            return stubbedResponse("")
        case .updatePassword:
            return stubbedResponse("")
        case .getBranches:
            return stubbedResponse("")
        case .changePassword:
            return stubbedResponse("")
        case .makeFavourite:
            return stubbedResponse("")
        case .mySalons:
            return stubbedResponse("")
        case .checkFaourite:
            return stubbedResponse("")
        case .updateToken:
            return stubbedResponse("")
        case .deletAccount:
            return stubbedResponse("")
        case .getDiscount:
            return stubbedResponse("")
        }
    }
    
    public var task: Task {
    switch self {
    case .updateProfile(let params):
        var formData = [MultipartFormData]()
        for (key, value) in params {
            if let imgData = value as? Data {
                formData.append(MultipartFormData(provider: .data(imgData), name: key, fileName: "testImage.jpg", mimeType: "image/jpeg"))
            } else {
                formData.append(MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key))
            }
        }
        return .uploadMultipart(formData)
        
   // case .cancelAppointment(let key):
       //         return .requestParameters(parameters: ["appointment_id" : key], encoding: URLEncoding.queryString)
        
      default:
            if(parameters != nil){
                return Task.requestParameters(parameters: (parameters)!, encoding: parameterEncoding)
            }else{
                return Task.requestPlain
            }
       }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case  .login(_):
            return JSONEncoding.prettyPrinted
        default:
            return JSONEncoding.prettyPrinted
        }
    }
}



func stubbedResponse(_ filename: String) -> Data! {
    let bundleURL = Bundle.main.bundleURL
    
    let path = bundleURL.appendingPathComponent("Frameworks/PartyAppKit.framework/\(filename).json") //bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: path))
}

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}


func mimeType(for data: Data) -> String {

    var b: UInt8 = 0
    data.copyBytes(to: &b, count: 1)

    switch b {
    case 0xFF:
        return "image/jpeg"
    case 0x89:
        return "image/png"
    case 0x47:
        return "image/gif"
    case 0x4D, 0x49:
        return "image/tiff"
    case 0x25:
        return "application/pdf"
    case 0xD0:
        return "application/vnd"
    case 0x46:
        return "text/plain"
    default:
        return "text/plain"
    }
}


