//
//  SideMenuCell.swift
//  Haftaa
//
//  Created by Najeh on 03/05/2022.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Background
        self.backgroundColor = .clear
        
        // Icon
        self.imgV.tintColor = .white
        
        // Title
        self.titleLbl.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
