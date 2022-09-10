//
//  ReviesCell.swift
//  Haftaa
//
//  Created by Najeh on 30/07/2022.
//

import UIKit
import Cosmos
class ReviesCell: UITableViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var commentTV: UITextView!
    @IBOutlet weak var ratingVieq: CosmosView!
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
