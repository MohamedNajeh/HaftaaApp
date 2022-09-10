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
}
class CommentCell: UICollectionViewCell {

    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var commentLbl: UITextView!
    @IBOutlet weak var replayBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var deletBtn: UIButton!
    var delegate:DeleteCommentProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteCommentAction(_ sender: UIButton) {
        self.delegate?.deleteComment(tag: sender.tag)
    }
}
