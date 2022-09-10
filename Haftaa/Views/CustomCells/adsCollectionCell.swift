//
//  adsCollectionCell.swift
//  Haftaa
//
//  Created by Najeh on 01/08/2022.
//

import UIKit

class adsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var adsImage: UIImageView!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var sinceLbl: UILabel!
    @IBOutlet weak var userLblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
