//
//  verficationCodeCell.swift
//  Haftaa
//
//  Created by Najeh on 11/06/2022.
//

import UIKit

class verficationCodeCell: UICollectionViewCell {

    @IBOutlet weak var codeTF: UITextField!
    var delegate:LoginProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func backToLogin(_ sender: Any) {
        self.delegate?.changeReigisterState(index: 0)
    }
    @IBAction func sendCode(_ sender: Any) {
        self.delegate?.sendCode(phone: UserInfo.getUserPhone(), code: codeTF.text ?? "")
    }
    
    @IBAction func resendCode(_ sender: Any) {
        
    }
}
