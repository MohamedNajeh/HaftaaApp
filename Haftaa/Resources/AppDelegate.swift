//
//  AppDelegate.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import UIKit
import SideMenu
import DropDown
import IQKeyboardManagerSwift
import UserNotifications
import GoogleMaps
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, MessagingDelegate {
    
    // applinks:hvps.exdezign.com
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        GMSServices.provideAPIKey("ba2fdde4e9431e42")
        registerRemoteNotifications(application: application)
        //getToken()
        // Override point for customization after application launch.
        return true
    }
    
    func registerRemoteNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions,
                                                                     completionHandler: {_, _ in })
        } else {
            UNUserNotificationCenter.current().delegate = self
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        // Remove all notifications
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
    }
    
    func getToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
            }
        }
    }
    
    
    // MARK: UISceneSession Lifecycle
    
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is SideMenuNavigationController {
            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "SideMenu") {
                tabBarController.present(newVC, animated: true)
                return false
            }
        }
        
        return true
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        //UserModel.shared.setFCM(token: fcmToken ?? "")
        // let dataDict:[String: String] = ["token": fcmToken ?? ""]
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        print("token firebase is " , fcmToken ?? "")
        UserInfo.setFCMToken(fcmToken: fcmToken ?? "")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Recieved Notification")
        
        if let userInfo = response.notification.request.content.userInfo as? [String : Any] {
            handleNotification(userInfo)
            if let type = userInfo["type"] as? String {
                print("didRecive recive notification with type: \(type)")
            }
        }
        completionHandler()
    }
    
    // Handle remote notification handling
    func handleNotification(_ userInfo: [AnyHashable: Any]) {
        if let notificationType = userInfo["type"] as? String {
            switch notificationType {
            case "user_notification":
                if let userId = userInfo["user_id"] as? String {
                    navigateToUserProfile(userId)
                }
            case "new_notification":
                if let adsId = userInfo["ads_id"] as? String {
                    navigateToAdDetails(adsId)
                }
            case "new_chat":
                if let chatId = userInfo["chat_id"] as? String {
                    openChatScreen(chatId)
                }
            case "new_comment_debate":
                // Handle new_comment_debate notification
                navigateToDiscussionScreen()
            case "my_account":
                // Handle my_account notification
                navigateToMyProfile()
            default:
                // Handle other notification types or log an error
                break
            }
        }
    }
    
    // Your navigation functions
    func navigateToUserProfile(_ userId: String) {
        // Implement navigation to user profile screen
    }
    
    func navigateToAdDetails(_ adsId: String) {
        // Implement navigation to ad details screen
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
        vc.addID = Int(adsId)
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    func openChatScreen(_ chatId: String) {
        // Implement opening chat screen
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.id = Int(chatId) ?? 0
        vc.title = ""
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    func navigateToDiscussionScreen() {
        // Implement navigation to discussion screen
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        UIApplication.topViewController()?.present(vc, animated: true)
    }
    
    func navigateToMyProfile() {
        // Implement navigation to my profile screen
    }
    
    //    func handelPushNotificationFor(type:String, message:String)
    //    {
    //        let infoDic = ["message":message, "type":type ]
    //
    //        switch type{
    //        case "user_notification":
    //            print("user profile") // user ID
    //        case "new_notification":
    //            print("new ads") // ads ID
    //        case "new_chat":
    //            print("chat") // chat ID
    //        case "new_comment_debate":
    //            print("discussions") // no need
    //        case "my_account":
    //            print("profile") // no need
    //        default:
    //            print("default")
    //        }
    //    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}
