//
//  adImagesCell.swift
//  Haftaa
//
//  Created by Apple on 04/07/2022.
//

import UIKit

class adImagesCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureImage(image:String){
        imageV.setImage(with: image)
    }

}
