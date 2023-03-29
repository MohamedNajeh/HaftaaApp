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
        // Initialization code
        observeNewComment()
    }
    
    func observeNewComment(){
        SocketHelper.shared.getAddComment { messageInfo in
            let user = User(id: messageInfo?[0].user_id, userName: messageInfo?[0].name, name: messageInfo?[0].name, phone: "", photoPath: "", photoID: "", nationalIdentityPath: "", nationalIdentity: 0, commercialRegisterPath: "", commercialRegister: 0, favourPath: "", favour: 0, workPermitPath: "", workPermit: 0, sajalMadaniun: "", allowPhone: 0, whatsapp: 0, email: "", city: nil, newPassword: 0, country: nil, step: 0, trusted: 0)
            let comment = Comment(id: messageInfo?[0].id ?? 0, users: user, since: messageInfo?[0].since ?? "", comment: messageInfo?[0].comment ?? "", childes: [], deleteComment: 0)
            
            if messageInfo?[0].parent_id != 0 {
                self.comments.enumerated().forEach { (index,value) in
                    if value.id == messageInfo?[0].parent_id{
                        self.comments[index].childes?.append(comment)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }else{
                self.comments.append(comment)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

            }
        }
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
                    AlertsManager.showAlert(withTitle: "تم بنجاح", message: error.localizedDescription, viewController:UIApplication.topViewController())
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel, handler: nil))

        // 4. Present the alert.
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
      
    }
}

extension CommentsListCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if comments.count == 0 {
            noCommentsLbl.isHidden = false
        }else{
            noCommentsLbl.isHidden = true
        }
        return comments.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments[section].childes?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userLbl.text = comments[indexPath.section].childes?[indexPath.row].users?.userName
        cell.timeLbl.text = comments[indexPath.section].childes?[indexPath.row].since
        cell.commentLbl.text = comments[indexPath.section].childes?[indexPath.row].comment
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:0.0)
    }
    
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentsHeaderCollectionReusableView", for: indexPath) as! CommentsHeaderCollectionReusableView
            header.label.text = comments[indexPath.section].users?.userName
            header.comment.text = comments[indexPath.section].comment
            header.timeLbl.text = comments[indexPath.section].since
            header.delegate = self
            header.replayButton.tag = indexPath.section
            header.deleteBtn.tag = indexPath.section
            if comments[indexPath.section].users?.id == UserInfo.getUserID(){
                header.deleteBtn.isHidden = false
            }else {
                header.deleteBtn.isHidden = true
            }
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CommentsHeaderCollectionReusableView", for: indexPath) as! CommentsHeaderCollectionReusableView
        footer.backgroundColor = UIColor.clear
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:120.0)
    }
    
}
