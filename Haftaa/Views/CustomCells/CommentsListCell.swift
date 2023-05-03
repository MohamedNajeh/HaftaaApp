//
//  CommentsListCell.swift
//  Haftaa
//
//  Created by Najeh on 31/07/2022.
//

import UIKit

class CommentsListCell: UICollectionViewCell,handleDeleteAndReplayProtocol {
    
    

    @IBOutlet weak var noCommentsLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var details:AddsDetails?{
        didSet{
            collectionView.reloadData()
        }
    }
    var comments:[Comment] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionV()
    }
    
    
    func configureCollectionV(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        collectionView.register(CommentsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommentsHeaderCollectionReusableView")
        collectionView.register(CommentsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CommentsHeaderCollectionReusableView")
    }
    
    func deleteComment(tag: Int) {
        //showLoadingView()
        AlertsManager.showAlert(withTitle: "هل انت متآكد", message: "هل انت متاكد من حذف هذا التعليق", viewController: UIApplication.topViewController(), showingCancelButton: true, showingOkButton: true, cancelHandler:nil, actionTitle: "نعم", actionStyle: .default) { action in
            
            NetworkManager.shared.deleteComment(url: "delete_comment", comment_id: self.comments[tag].id) { response in
                // self.removeLoadingView()
                switch response {
                case .success(let resp):
                    AlertsManager.showAlert(withTitle: "تم بنجاح", message: resp.message, viewController: UIApplication.topViewController())
                    
                    DispatchQueue.main.async {
                        self.comments.remove(at: tag)
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    AlertsManager.showAlert(withTitle: "تنبيه", message: error.localizedDescription, viewController: UIApplication.topViewController())
                }
            }
        }
    }
    
    func replayComment(tag: Int) {
        let alert = UIAlertController(title: "اضافة رد", message: "اضف رد على هذا التعليق", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            //textField.text = "Some default text"
            textField.textAlignment = .right
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "اضافة", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            NetworkManager.shared.addCommentToAdd(url: "add_comment", chat_id: self.details?.id, comment: textField?.text, parent_id: self.comments[tag].id) { response in
                switch response {
                case .success(let add):
                    AlertsManager.showAlert(withTitle: "تم بنجاح", message: add.message, viewController:UIApplication.topViewController())
                case .failure(let error):
                    AlertsManager.showAlert(withTitle: "حدث خطآ", message: error.localizedDescription, viewController:UIApplication.topViewController())
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel, handler: nil))

        // 4. Present the alert.
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
      
    }
}

extension CommentsListCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , DeleteCommentProtocol{
    

    func showParent(tag: Int) {
        guard let parent = comments[tag].parents else {
            print("couldn't get parent at tag \(tag)")
            return
        }
        print("parent id is\(parent.id ?? 0)")
        if let index = comments.firstIndex(where: { $0.id == parent.id }) {
            print("Index of element with id: \(index)  \(comments[index].id ?? 0)")
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        } else {
            print("Element with id not found")
        }
    }

    func replay(tag: Int) {
        //self.commentTF.becomeFirstResponder()
        
        let alert = UIAlertController(title: "اضافة رد", message: "اضف رد على هذا التعليق", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            //textField.text = "Some default text"
            textField.textAlignment = .right
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "اضافة", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            NetworkManager.shared.addCommentToAdd(url: "add_comment", chat_id: self.details?.id, comment: textField?.text, parent_id: self.comments[tag].id) { response in
                switch response {
                case .success(let add):
                    AlertsManager.showAlert(withTitle: "تم بنجاح", message: add.message, viewController:UIApplication.topViewController())
                case .failure(let error):
                    AlertsManager.showAlert(withTitle: "تم بنجاح", message: error.localizedDescription, viewController:UIApplication.topViewController())
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel, handler: nil))

        // 4. Present the alert.
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
      
        //self.parentID = parent ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if comments.count == 0 {
            noCommentsLbl.isHidden = false
        }else{
            noCommentsLbl.isHidden = true
        }
        return comments.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userLbl.text = comments[indexPath.row].users?.userName
        cell.timeLbl.text = comments[indexPath.row].since
        cell.commentLbl.text = comments[indexPath.row].comment
        
        cell.replayBtn.tag = indexPath.row
        cell.showParentBtn.tag = indexPath.row
        cell.deletBtn.tag = indexPath.row
        cell.deletBtn.isHidden = comments[indexPath.row].deleteComment == 1 ? false : true
        cell.delegate = self
        
        if let _ = comments[indexPath.row].parents {
            cell.parentLbl.setTitle("#\(comments[indexPath.row].parents?.comment ?? "") @\(comments[indexPath.row].parents?.users?.name ?? "")", for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 100.0)
    }
    
    
    
}
