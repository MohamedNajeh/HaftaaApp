//
//  UserDetailsVC + CollectionExt.swift
//  Haftaa
//
//  Created by Najeh on 30/07/2022.
//

import Foundation
import UIKit

extension UserDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comments.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments[section].childes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = commentsCollectionV.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userLbl.text = comments[indexPath.section].childes?[indexPath.row].users?.userName
        cell.timeLbl.text = comments[indexPath.section].childes?[indexPath.row].since
        cell.commentLbl.text = comments[indexPath.section].childes?[indexPath.row].comment
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: commentsCollectionV.frame.width - 20, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: commentsCollectionV.frame.width, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: commentsCollectionV.frame.width, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = commentsCollectionV.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentsHeaderCollectionReusableView", for: indexPath) as! CommentsHeaderCollectionReusableView
            header.label.text = comments[indexPath.row].users?.userName
            header.comment.text = comments[indexPath.row].comment
            header.timeLbl.text = comments[indexPath.row].since
            header.deleteBtn.isHidden = true
            header.replayButton.isHidden = true
            return header
        }
        let footer = commentsCollectionV.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentsHeaderCollectionReusableView", for: indexPath) as! CommentsHeaderCollectionReusableView
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
}
