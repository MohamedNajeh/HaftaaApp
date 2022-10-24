//
//  productTypeCell.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import UIKit

class productTypeCell: UICollectionViewCell {

    @IBOutlet weak var profuctName: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        imgV.layer.cornerRadius = 20
        contentView.layer.borderWidth = 3
        // Initialization code
    }

}
