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
        imgV.layer.cornerRadius = 20
        // Initialization code
    }

}
