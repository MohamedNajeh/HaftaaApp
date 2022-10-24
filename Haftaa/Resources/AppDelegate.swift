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
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate {

              // applinks:hvps.exdezign.com

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared.enable = true
        
        
        GMSServices.provideAPIKey("ba2fdde4e9431e42")
        //GMSPlacesClient.provideAPIKey("AIzaSyA9UBKQHciVMSJZEoM640mtwKkTXavjrD4")
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert,.badge,.sound]) { granted, error in
                if granted {
                    print("Permitted")
                }
            }
        UNUserNotificationCenter.current().delegate = self
        // Override point for customization after application launch.
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        
        completionHandler( [.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
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
//    func presentDetailViewController(_ computer: Computer) {
//      let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//      guard
//        let detailVC = storyboard
//          .instantiateViewController(withIdentifier: "DetailController")
//            as? ComputerDetailController,
//        let navigationVC = storyboard
//          .instantiateViewController(withIdentifier: "NavigationController")
//            as? UINavigationController
//      else { return }
//
//      detailVC.item = computer
//      navigationVC.modalPresentationStyle = .formSheet
//      navigationVC.pushViewController(detailVC, animated: true)
//    }



}

