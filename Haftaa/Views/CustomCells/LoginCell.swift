//
//  LoginCell.swift
//  Haftaa
//
//  Created by Najeh on 11/06/2022.
//

import UIKit

protocol LoginProtocol {
    func changeReigisterState(index:Int)
    func loginAction(phone:String,password:String)
    func registerAction(name:String,country:String,phone:String,userName:String,password:String,agreemnet:String,policy:String,firstCheck:Bool,privacyCheck:Bool)
    func sendCode(phone:String,code:String)
    func resetPassword(phone:String,code:String)
}

class LoginCell: UICollectionViewCell {

    @IBOutlet weak var phoneTXT: UITextField!
    
    @IBOutlet weak var registerBtnOutlet: UIButton!
    @IBOutlet weak var passwordTXT: UITextField!
    @IBOutlet weak var btnShwoPass: UIButton!
    var delegate:LoginProtocol?
    var showPass = false
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserInfo.appSettings?.data.activeRegister == 0 {
            registerBtnOutlet.isHidden = true
        }
        // Initialization code
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.delegate?.loginAction(phone: phoneTXT.text!, password: passwordTXT.text!)
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
        self.delegate?.changeReigisterState(index: 2)
    }
    
    @IBAction func creatNewAcountPressed(_ sender: Any) {
        self.delegate?.changeReigisterState(index: 1)
    }
    
    @IBAction func showPass(_ sender: Any) {
        showPass = !showPass
        if showPass {
            btnShwoPass.setImage(UIImage(named: "open-lock"), for: .normal)
            passwordTXT.isSecureTextEntry = false
        }else {
            btnShwoPass.setImage(UIImage(named: "lock"), for: .normal)
            passwordTXT.isSecureTextEntry = true
        }

        
    }
}
