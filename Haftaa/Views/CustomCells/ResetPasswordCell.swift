//
//  ResetPasswordCell.swift
//  Haftaa
//
//  Created by Najeh on 11/06/2022.
//

import UIKit

class ResetPasswordCell: UICollectionViewCell {

    @IBOutlet weak var phoneTF: UITextField!
    var delegate:LoginProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func creatAcountBtnPressed(_ sender: Any) {
        self.delegate?.changeReigisterState(index: 1)
    }
    @IBAction func backToLogin(_ sender: Any) {
        self.delegate?.changeReigisterState(index: 0)
    }
    
    @IBAction func newPassword(_ sender: Any) {
        NetworkManager.shared.forgetPass(url: "new_password", phone: phoneTF.text) { resp in
            switch resp {
            case .success(let log):
                print(log)
                //AlertsManager.showAlert(withTitle: "تم بنجاح", message: log.message, viewController: UIApplication.topViewController())
                UserInfo.setUserPhone(name: log.data?.phone)
                self.delegate?.changeReigisterState(index: 3)
            case .failure(let error):
                print(error)
                AlertsManager.showAlert(withTitle: "تم ", message: error.localizedDescription, viewController: UIApplication.topViewController())
            }
        }
    }
}
