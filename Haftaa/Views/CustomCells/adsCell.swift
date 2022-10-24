//
//  adsCell.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import UIKit

protocol locationAndDetailsActions {
    func locationPressed(tag:Int)
    func detailsPressed(tag:Int)
}

class adsCell: UITableViewCell {

    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var sinceLbl: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var userDtailBtn: UIButton!
    @IBOutlet weak var userDetailsStack: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblHtml: UILabel!
    @IBOutlet weak var sepretorView: UIView!
    
    var delegate:locationAndDetailsActions?
    override func awakeFromNib() {
        super.awakeFromNib()
        //contentView.layer.cornerRadius = 20
        adImage.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.cgColor
        userName.setContentHuggingPriority(. required, for: .horizontal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        adImage.kf.cancelDownloadTask() // first, cancel currenct download task
        adImage.kf.setImage(with: URL(string: "")) // second, prevent kingfisher from setting previous image
        adImage.image = nil
    }
    
    func configureCell(isLast:Bool,add:AddsDetails){
        if isLast {
            lblHtml.isHidden = false
            lblHtml.attributedText = add.title?.htmlToAttributedString
            userDetailsStack.isHidden = true
            onlineView.isHidden = true
            userName.isHidden = true
            title.isHidden = true
            adImage.isHidden = true
            containerView.backgroundColor = .clear
            containerView.borderWidth = 0
            adImage.setImage(with: add.image ?? "")
            sepretorView.backgroundColor = .clear
        }else{
            adImage.setImage(with: add.image ?? "")
            containerView.backgroundColor = .lightSkyColor
            sepretorView.backgroundColor = .lightGray
            containerView.borderWidth = 1
            lblHtml.isHidden = true
            adImage.isHidden = false
            userDetailsStack.isHidden = false
            title.isHidden = false
            onlineView.isHidden = false
            userName.isHidden = false
            title.text = add.title
            userName.text = add.user?.name ?? ""
            sinceLbl.text = add.since
            if add.user?.trusted == 1 {
                userIcon.image = UIImage(named: "verify")
            }else{
                userIcon.image = UIImage(systemName: "person.fill")
            }
        }
    }
    
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        self.delegate?.locationPressed(tag: sender.tag)
    }
    @IBAction func userDetailsBtnPressed(_ sender: UIButton) {
        self.delegate?.detailsPressed(tag: sender.tag)
    }
}
