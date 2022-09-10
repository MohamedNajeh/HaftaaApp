//
//  ChatCell.swift
//  Haftaa
//
//  Created by Najeh on 08/06/2022.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var chatStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
