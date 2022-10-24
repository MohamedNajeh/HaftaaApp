//
//  General.swift
//  Haftaa
//
//  Created by Najeh on 01/07/2022.
//

import Foundation
import UIKit

class UserInfo : NSObject {
    
    static let shared = UserInfo()
    static let userDefault = UserDefaults.standard
    static var appSettings:SettingsModel?
    static var countries:[Country]?
    static var allTypes:[Category] = []
    static var userLat:String = ""
    static var userLng:String = ""
    static var isRegister:Int = 0
   
    
    static var userData : loginData?
    static func setUserData(data:loginData?){       
        setLoginState(isLogin: true)
        setUserID(id: data?.id ?? 0)
        setUserName(userName: data?.userName ?? "")
        setName(name: data?.name ?? "")
        setPhone(userPhone: data?.phone ?? "")
        setUserToken(name: data?.accessToken ?? "")
        setUserPan(isPan: data?.ban ?? 0)
        setUserCountry(country: data?.country?.name ?? "")
        setUserCity(city: data?.city?.name ?? "")
       
    }
    
    static func navigateToTabBarBYIndex(index : Int,vc:UIViewController) {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        let tabBarController = keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = index
        vc.dismiss(animated: true, completion: {
            vc.navigationController?.popToRootViewController(animated: false)
        })
    }
    
    static func logOut(){
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        NotificationCenter.default.post(name: .init("hideChatAndNotification"), object: nil )
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
    }
    
    static func openLoginVC(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()!.present(vc, animated: true, completion: nil)
    }
    
    
    
    static func setLoginState(isLogin:Bool?){
        userDefault.set(isLogin ,forKey: "isLogin")
    }
    
    static func setUserPan(isPan:Int?){
        userDefault.set(isPan ,forKey: "isPan")
    }
    
    static func setUserID(id:Int?){
        userDefault.set(id ,forKey: "userID")
    }
    
    static func setUserName(userName:String?){
        userDefault.set(userName ,forKey: "userName")
    }
    
    static func setName(name:String?){
        userDefault.set(name ,forKey: "name")
    }
    
    static func setUserCountry(country:String?){
        userDefault.set(country ,forKey: "userCountry")
    }
    static func setUserCity(city:String?){
        userDefault.set(city ,forKey: "userCity")
    }
    
    static func setPhone(userPhone:String?){
        userDefault.set(userPhone ,forKey: "userPhone")
    }
    
    static func getUserLogin() -> Bool {
        return userDefault.value(forKey: "isLogin") as? Bool ?? false
    }
    
    static func getUserID() -> Int {
        return userDefault.value(forKey: "userID") as? Int ?? 0
    }
    static func getUserCountry() -> String {
        return userDefault.value(forKey: "userCountry") as? String ?? ""
    }
    static func getUserCity() -> String {
        return userDefault.value(forKey: "userCity") as? String ?? ""
    }
    
    static func getUserPan() -> Int {
        return userDefault.value(forKey: "isPAn") as? Int ?? 0
    }
    
    
    static func getUserNAme() -> String {
        return userDefault.value(forKey: "userName") as? String ?? ""
    }
    
    static func setUserPhone(name:String?){
        userDefault.set(name ,forKey: "userPhone")
    }
    
    static func getUserPhone() -> String {
        return userDefault.value(forKey: "userPhone") as? String ?? ""
    }
    
    static func setUserToken(name:String?){
        userDefault.set(name ,forKey: "userToken")
    }
    
    static func getUserToken() -> String {
        return userDefault.value(forKey: "userToken") as? String ?? ""
    }
    
    class func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = img!.jpegData(compressionQuality: compressionQuality)
        UIGraphicsEndImageContext();
        
        return imageData!
    }
    
}
