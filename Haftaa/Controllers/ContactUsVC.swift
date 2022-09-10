//
//  ContactUsVC.swift
//  Haftaa
//
//  Created by Apple on 04/08/2022.
//

import UIKit
import IQKeyboardManagerSwift
class ContactUsVC: UIViewController {

    @IBOutlet weak var mesageTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.shared.enable = true
        // Do any additional setup after loading the view.
    }
    

   func callPhone(){
        let phoneNumber =  "966500785590"
       if let url = URL(string: "tel://\(phoneNumber)") {
             UIApplication.shared.open(url)
         }
    }
    
    func openTwitter(){
        let screenName =  "saud05007s"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    func openSnap(){
        let username = "saud05005"
        let appURL = URL(string: "snapchat://add/\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)

        } else {
            // if Snapchat app is not installed, open URL inside Safari
            let webURL = URL(string: "https://www.snapchat.com/add/\(username)")!
            application.open(webURL)

        }
    }
    
    @IBAction func callBtnPressed(_ sender: Any) {
        callPhone()
    }
    
    @IBAction func twitterBtnPressed(_ sender: Any) {
        openTwitter()
    }
    
    
    @IBAction func snapBtnPressed(_ sender: Any) {
        openSnap()
    }
    @IBAction func sendBtnPressed(_ sender: Any) {
        showLoadingView()
        NetworkManager.shared.contactUS(url: "contact_us", name: nameTF.text, phone: phoneTF.text, email: mesageTF.text) { response in
            self.removeLoadingView()
            switch response {
            case .success(let resp):
                AlertsManager.showAlert(withTitle: "تم بنجاح", message: resp.message, viewController: self)
                DispatchQueue.main.async {
                    self.nameTF.text = ""
                    self.phoneTF.text = ""
                    self.mesageTF.text = ""
                }
            case .failure(let error):
                AlertsManager.showAlert(withTitle: "تنبيه", message: error.localizedDescription, viewController: self)
            }
        }
    }
}
