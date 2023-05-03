//
//  UserDetailsVC + CollectionExt.swift
//  Haftaa
//
//  Created by Najeh on 30/07/2022.
//

import Foundation
import UIKit

extension UserDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, DeleteCommentProtocol {
    
    func deleteComment(tag: Int) {
        
    }

    func showParent(tag: Int) {
        guard let parent = comments[tag].parents else {
            print("couldn't get parent at tag \(tag)")
            return
        }
        print("parent id is\(parent.id ?? 0)")
        if let index = comments.firstIndex(where: { $0.id == parent.id }) {
            print("Index of element with id: \(index)  \(comments[index].id ?? 0)")
            let indexPath = IndexPath(item: index, section: 0)
            commentsCollectionV.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        } else {
            print("Element with id not found")
        }
    }

    func replay(tag: Int) {
        //self.commentTF.becomeFirstResponder()
        guard let parent = comments[tag].id else {
            print("couldn't get parent at tag \(tag)")
            return
        }
        //self.parentID = parent ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = commentsCollectionV.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userLbl.text = comments[indexPath.row].users?.userName
        cell.timeLbl.text = comments[indexPath.row].since
        cell.commentLbl.text = comments[indexPath.row].comment
        
        cell.deletBtn.tag = indexPath.row
        cell.replayBtn.tag = indexPath.row
        cell.showParentBtn.tag = indexPath.row
        
        cell.delegate = self
        
        if let _ = comments[indexPath.row].parents {
            cell.parentLbl.setTitle("#\(comments[indexPath.row].parents?.comment ?? "") @\(comments[indexPath.row].parents?.users?.name ?? "")", for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: commentsCollectionV.frame.width - 20, height: 100.0)
    }
}
