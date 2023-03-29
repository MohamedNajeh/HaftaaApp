//
//  DiscussionsCell.swift
//  Haftaa
//
//  Created by Najeh on 02/08/2022.
//

import UIKit

protocol navigateToDetails {
    func navigateToDetailsScreen(sender:Int)
}

class DiscussionsCell: UITableViewCell {

    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var dislikeCountLbl: UILabel!
    @IBOutlet weak var likesCountLbl: UILabel!
    @IBOutlet weak var commentsCountLbl: UILabel!
    @IBOutlet weak var sinceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var btnShowAndHide: UIButton!
    @IBOutlet weak var viewToHide: UIView!
    var delegate:navigateToDetails?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data:Discussions){
        btnTitle.setTitle(data.title, for: .normal)
        descriptionLbl.attributedText = data.datumDescription?.htmlToAttributedString
        commentsCountLbl.text = "\(data.countComment)"
        likesCountLbl.text = "\(data.countLike)"
        dislikeCountLbl.text = "\(data.countDisLike)"
        timeLbl.text = data.listUpdate
        sinceLbl.text = data.since
    }
    
    @IBAction func btnTitleAction(_ sender: UIButton) {
        self.delegate?.navigateToDetailsScreen(sender: sender.tag)
    }
    @IBAction func showHide(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.viewToHide.isHidden = !self.viewToHide.isHidden
            self.btnShowAndHide.transform = self.viewToHide.isHidden ? CGAffineTransform(scaleX: 1.0, y: 1.0) : CGAffineTransform(scaleX: 1.0, y: -1.0)
        }
    }
}
