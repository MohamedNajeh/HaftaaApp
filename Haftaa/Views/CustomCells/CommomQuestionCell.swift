//
//  CommomQuestionCell.swift
//  Haftaa
//
//  Created by Najeh on 21/05/2022.
//

import UIKit

class CommomQuestionCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.cornerRadius = 20
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
