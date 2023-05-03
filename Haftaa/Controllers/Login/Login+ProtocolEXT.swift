//
//  Login+ProtocolEXT.swift
//  Haftaa
//
//  Created by Najeh on 23/07/2022.
//

import Foundation
import Foundation
import UIKit
extension LoginVC:LoginProtocol{
    func resetPassword(phone: String, code: String) {
        showLoadingView()
        //NetworkManager.shared.sendCode(url: "", phone: "", code: "", completion: "")
    }
    
    
    func sendCode(phone: String, code: String) {
        showLoadingView()
        NetworkManager.shared.sendCode(url: "verify", phone: phone, code: code) { response in
            self.removeLoadingView()
            switch response {
            case .success(let user):
                if user.status == 200 {
                    UserInfo.setUserData(data: user.data)
                    NotificationCenter.default.post(name: .init("showChatAndNotification"), object: nil )
                    if UserInfo.isRegister == 1 {
                        UserInfo.navigateToTabBarBYIndex(index: 0, vc: self)
                    }else{
                        self.changeReigisterState(index: 4)
                    }
                    
                }else{
                    AlertsManager.showAlert(withTitle: "خطأ", message: user.message, viewController: self)
                }
                print(user)
            case.failure(let error):
                AlertsManager.showAlert(withTitle: "خطأ", message: error.localizedDescription, viewController: self)
                print(error)
            }
        }
    }
    
    func registerAction(name: String, country: String, phone: String, userName: String, password: String, agreemnet: String, policy: String,firstCheck:Bool,privacyCheck:Bool) {
        if firstCheck && privacyCheck {
            NetworkManager.shared.register(url: "register_phone", email: "", phoneNumber: phone, countryID: "1", privacy: policy, section: agreemnet, name: name, username: userName, password: "123456") { response in
                switch response {
                case .success(let user):
                    if user.status == 200 {
                        UserInfo.setUserData(data: user.data)
                        UserInfo.isRegister = 1
                        self.changeReigisterState(index: 3)
                    }else{
                        AlertsManager.showAlert(withTitle: "خطأ", message: user.message, viewController: self)
                    }
                    print(user)
                case.failure(let error):
                    AlertsManager.showAlert(withTitle: "خطأ", message: error.localizedDescription, viewController: self)
                    print(error.localizedDescription)
                }
            }
        }else{
            AlertsManager.showAlert(withTitle: " خطأ", message: "قم بالموافقة على التعهد وشروط الخصوصية اولاً", viewController: self)
        }
        
    }
    
    func loginAction(phone:String,password:String) {
        if phone.isEmpty || password.isEmpty{
            AlertsManager.showAlert(withTitle: "الرجاء ملئ الخانات", message: "قم بادخال رقم الهاتف والرقم السري", viewController: self)
        }else{
            showLoadingView()
            NetworkManager.shared.login(url: "login", phone: phone, password: password) { response in
                self.removeLoadingView()
                switch response{
                case .success(let response):
                    if response.status == 200 {
                        UserInfo.setUserData(data: response.data)
                        UserInfo.navigateToTabBarBYIndex(index: 0, vc: self)
                        NotificationCenter.default.post(name: .init("showChatAndNotification"), object: nil )
                    }else{
                        AlertsManager.showAlert(withTitle: "خطأ", message: response.message, viewController: self)
                    }
                   
                    print(response)
                case .failure(let error):
                    AlertsManager.showAlert(withTitle: "خطأ", message: error.localizedDescription, viewController: self)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func changeReigisterState(index: Int) {
        registrationStepsCollectionView.isScrollEnabled = true
        UIView.animate(withDuration: 0.5) {
            if index == 1 {
                self.containerBottomConstraint.constant = 20
                self.containerViewTopConstraint.constant = 100
                self.collectionHieghtConstraint.constant = 550
                self.registrationStepsCollectionView.reloadData()
            }else{
                self.containerBottomConstraint.constant = 100
                self.containerViewTopConstraint.constant = 140
                self.collectionHieghtConstraint.constant = 400
                self.registrationStepsCollectionView.reloadData()
            }
            self.registrationStepsCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .init(), animated: false)
            self.registrationStepsCollectionView.layoutIfNeeded()
        } completion: { _ in
            self.registrationStepsCollectionView.isScrollEnabled = false
        }
    }
}
