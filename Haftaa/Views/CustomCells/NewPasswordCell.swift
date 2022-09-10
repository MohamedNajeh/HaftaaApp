//
//  NewPasswordCell.swift
//  Haftaa
//
//  Created by Najeh on 06/08/2022.
//

import UIKit

class NewPasswordCell: UICollectionViewCell {

    @IBOutlet weak var passwordTF: UITextField!
    var delegate:LoginProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func resetBtn(_ sender: Any) {
        NetworkManager.shared.newPass(url: "rest_password", password: passwordTF.text) { resp in
            switch resp {
            case .success(let log):
                print(log)
                //AlertsManager.showAlert(withTitle: "تم بنجاح", message: log.message, viewController: UIApplication.topViewController())
                //self.delegate?.changeReigisterState(index: 0)
               
                UserInfo.navigateToTabBarBYIndex(index: 0, vc: UIApplication.topViewController()!)
            case .failure(let error):
                print(error)
                AlertsManager.showAlert(withTitle: "تم بنجاح", message: error.localizedDescription, viewController: UIApplication.topViewController())
            }
        }
    }
}
