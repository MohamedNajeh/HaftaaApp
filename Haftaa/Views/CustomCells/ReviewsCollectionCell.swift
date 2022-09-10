//
//  ReviewsCollectionCell.swift
//  Haftaa
//
//  Created by Najeh on 01/08/2022.
//

import UIKit
import Cosmos
class ReviewsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var reviewTV: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
