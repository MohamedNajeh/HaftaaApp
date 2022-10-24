//
//  RegisterCell.swift
//  Haftaa
//
//  Created by Najeh on 11/06/2022.
//

import UIKit
import DropDown

class RegisterCell: UICollectionViewCell {
    
    var delegate:LoginProtocol?
    var dropDown = DropDown()
    var countryID:Int?
    @IBOutlet weak var btnCheckFirst: UIButton!
    @IBOutlet weak var btnCheckPrivacy: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var userNAmeTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var agreementBtn: UILabel!
    
    var firsrCheck = false
    var privacyCheck = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        agreementBtn.attributedText = UserInfo.appSettings?.data.section.htmlToAttributedString
        agreementBtn.textAlignment = .right
        // Initialization code
    }

    @IBAction func backToLogin(_ sender: Any) {
        self.delegate?.changeReigisterState(index: 0)
    }
    
    @IBAction func agreeCheckFirst(_ sender: Any) {
        firsrCheck = !firsrCheck
        if firsrCheck {
            btnCheckFirst.setImage(UIImage(named: "check-box"), for: .normal)
        }else{
            btnCheckFirst.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        
    }
    
    
    @IBAction func agreeCheckPrivacy(_ sender: Any) {
        privacyCheck = !privacyCheck
        if privacyCheck {
            btnCheckPrivacy.setImage(UIImage(named: "check-box"), for: .normal)
        }else{
            btnCheckPrivacy.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        self.delegate?.registerAction(name: nameTF.text ?? "", country: "\(countryID ?? 1)", phone: phoneTF.text ?? "", userName: userNAmeTF.text ?? "", password: passwordTF.text ?? "", agreemnet: "1", policy: "1",firstCheck: firsrCheck,privacyCheck:privacyCheck)
    }
    
    @IBAction func chooseCountry(_ sender: UIButton) {
        let allContries:[Country] = UserInfo.countries!
        var names:[String] {allContries.map(\.name!)}
        dropDown.dataSource = names
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
        dropDown.direction = .bottom
        dropDown.show()
        dropDown.selectionAction = {[weak self] (index: Int , item: String) in
            guard let _ = self else {return}
            sender.setTitle(item, for: .normal)
            self?.countryID = index
        }
    }
}
