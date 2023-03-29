//
//  CommentCell.swift
//  Haftaa
//
//  Created by Najeh on 27/07/2022.
//

import UIKit
import Cosmos
protocol DeleteCommentProtocol {
    func deleteComment(tag:Int)
    func showParent(tag:Int)
    func replay(tag:Int)
}
class CommentCell: UICollectionViewCell {

    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var commentLbl: UITextView!
    @IBOutlet weak var replayBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var deletBtn: UIButton!
    @IBOutlet weak var parentLbl: UIButton!
    @IBOutlet weak var showParentBtn: UIButton!
    
    var delegate:DeleteCommentProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
         super.prepareForReuse()
        parentLbl.setTitle("", for: .normal)
     }
    
    @IBAction func deleteCommentAction(_ sender: UIButton) {
        self.delegate?.deleteComment(tag: sender.tag)
    }
    
    @IBAction func showParent(_ sender: UIButton) {
        self.delegate?.showParent(tag: sender.tag)
    }
    
    @IBAction func replayBtnPressed(_ sender: UIButton) {
        self.delegate?.replay(tag: sender.tag)
    }
    
}
