//
//  UIApplication+Ext.swift
//  Haftaa
//
//  Created by Najeh on 23/07/2022.
//


import Foundation
import UIKit

extension UIApplication {
    
    //=========================
    //MARK: Top View Controller
    //=========================
    
    /// Get an instance of the top view controller which appeares on screen.
    ///
    /// - Parameter baseViewController: parent class to start with it and make recursion operation to get top view controller
    /// - Returns: an instance of the top view controller
    
    class func topViewController(baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        guard let navigationController = baseViewController as? UINavigationController else {
            if let tabBarViewController = baseViewController as? UITabBarController {
                
                let moreNavigationController = tabBarViewController.moreNavigationController
                if let mostTopViewController = moreNavigationController.topViewController, mostTopViewController.view.window != nil {
                    return topViewController(baseViewController:mostTopViewController)
                } else if let selectedViewController = tabBarViewController.selectedViewController {
                    return topViewController(baseViewController: selectedViewController)
                }
            }
            
            guard let splitViewController = baseViewController as? UISplitViewController, splitViewController.viewControllers.count == 1 else {
                guard let presentedViewController = baseViewController?.presentedViewController else {
                    return baseViewController
                }
                return topViewController(baseViewController: presentedViewController)
            }
            return topViewController(baseViewController: splitViewController.viewControllers[0])
        }
        return topViewController(baseViewController: navigationController.visibleViewController)
        
    } // topViewController
    
    class var statusBarBackgroundColor: UIColor? {
        get {
            if #available(iOS 13.0, *) {
                let tag = 38482
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                
                if let statusBar = keyWindow?.viewWithTag(tag) {
                    return statusBar.backgroundColor
                }
            }else{
                return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
            }
            return nil
        } set {
            if #available(iOS 13.0, *) {
                let tag = 38482
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                
                if let statusBar = keyWindow?.viewWithTag(tag) {
                    statusBar.backgroundColor  = newValue
                }else{
                    
                    guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else {return
                    }
                    let statusBarView = UIView(frame: statusBarFrame)
                    statusBarView.tag = tag
                    keyWindow?.addSubview(statusBarView)
                    statusBarView.backgroundColor  = newValue
                }
                
            }else{
                (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
            }
        }
    }
    
    
    static var topSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.first!
            if #available(iOS 11.0, *) {
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            return safeFrame.minY
            } else {
                return window.frame.minY
        }
    }
    
    static var bottomSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.first!
        if #available(iOS 11.0, *) {
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            return window.frame.maxY - safeFrame.maxY
        } else {
            return 0
        }
    }
    
    func clearLaunchScreenCache() {
        do {
            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
        } catch {
            print("Failed to delete launch screen cache: \(error)")
        }
    }

} // UIApplication


