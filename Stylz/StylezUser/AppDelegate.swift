//
//  AppDelegate.swift
//  StylezUser
//
//  Created by Ajith Mohan on 10/08/23.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import FirebaseMessaging
import FirebaseCore



@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
 
    let googleApiKey = "AIzaSyANGQ1CPazPTtTo9IwDvwm_ESG09EKi7Vk"
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
       
        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
 
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

        UIView.appearance().semanticContentAttribute =   LocalizationSystem.sharedInstance.getLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight

        return true
    }

    // MARK: UISceneSession Lifecycle
    
    private func application(application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
  }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           // handler for Push Notifications
         //  Branch.getInstance().handlePushNotification(userInfo)
          
           
        if let messageID = userInfo[gcmMessageIDKey] {
                   print("Message ID: \(messageID)")
        }
        
           // Print full message.
           print(userInfo)
           
           
           
           completionHandler(UIBackgroundFetchResult.newData)
       }
    

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


extension AppDelegate  {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        print("HANDLING")

        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    //check point ::::
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        guard let window = UIApplication.shared.keyWindow else { return }

//        var body = ""
//        if let data = userInfo["aps"] as? [String: Any] {
//            if let alert = data["alert"] as? [String: String]{
//                body = alert["body"] ?? ""
//            }
//        }
//
//        if let payment = userInfo["payment"] as? String {
//            if payment == "1"{
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
//                let messageView = mainStoryboard.instantiateViewController(withIdentifier: stryBrdId.peymentSumm) as! PaymentSummeryViewController
//                let id = userInfo["notification_id"] as? String
//                messageView.notId = Int(id ?? "0") ?? 0
//                messageView.content = body
//                    if let nav = window.rootViewController as? UINavigationController{
//                        nav.pushViewController(messageView, animated: true)
//                }
//            }else{
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
//                let messageView = mainStoryboard.instantiateViewController(withIdentifier: stryBrdId.notification) as! NotificationViewController
//                    if let nav = window.rootViewController as? UINavigationController{
//                        nav.pushViewController(messageView, animated: true)
//                }
//
//               }
//            }
//        else{
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "SideMenu", bundle: nil)
//            let messageView = mainStoryboard.instantiateViewController(withIdentifier: stryBrdId.notification) as! NotificationViewController
//                if let nav = window.rootViewController as? UINavigationController{
//                    nav.pushViewController(messageView, animated: true)
//            }
//        }
       
    }
}


extension AppDelegate  {
    // [START refresh_token]



    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.

}
