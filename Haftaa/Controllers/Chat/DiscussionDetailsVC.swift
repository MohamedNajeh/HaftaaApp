//
//  DiscussionDetailsVC.swift
//  Haftaa
//
//  Created by Apple on 02/08/2022.
//

import UIKit

class DiscussionDetailsVC: UIViewController {
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var dislikesCountLbl: UILabel!
    @IBOutlet weak var likesCountLbl: UILabel!
    @IBOutlet weak var commentsCountLbl: UILabel!
    @IBOutlet weak var sinceLbl: UILabel!
    @IBOutlet weak var commentTF: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var idID:Int?
    var details:OneDiscussionDetails?
    var comments:[DiscussComment]?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        
        getDetails(id: idID ?? 0)
        commentTF.text = "اكتب مشاركتك"
        commentTF.textColor = UIColor.lightGray
        commentTF.delegate = self
        observeNewComment()
        
    }
    
    func configureCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
    }
    
    func setDataInView(data:Discussions){
        detailsLbl.attributedText = data.datumDescription.htmlToAttributedString
        dislikesCountLbl.text = "\(data.countDisLike)"
        likesCountLbl.text = "\(data.countLike)"
        commentsCountLbl.text = "\(data.countComment)"
        sinceLbl.text = data.since
        titleLbl.text = data.title
    }
    
    func observeNewComment(){
        SocketHelper.shared.getGeneralComment { messageInfo in
            //print(messageInfo)
            let user = User(id: messageInfo?[0].user_id, userName: messageInfo?[0].name, name: messageInfo?[0].name, phone: "", photoPath: "", photoID: "", nationalIdentityPath: "", nationalIdentity: 0, commercialRegisterPath: "", commercialRegister: 0, favourPath: "", favour: 0, workPermitPath: "", workPermit: 0, sajalMadaniun: "", allowPhone: 0, whatsapp: 0, email: "", city: nil, newPassword: 0, country: nil, step: 0, trusted: 0)
            let newComment = DiscussComment(id: messageInfo?[0].id, user: user, comment: messageInfo?[0].comment, date: messageInfo?[0].since)
            self.comments?.append(newComment)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                if self.comments?.count ?? 0 > 2 {
                    let indexPath = NSIndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
            //self.details?.data?.comments.append(newComment)
        }
    }
    
    func getDetails(id:Int){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "general_chat/\(id)", decodable: OneDiscussionDetails.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let resp):
                print(resp)
                self.details = resp
                self.comments = resp.data?.comments ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.setDataInView(data: resp.data!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addComment(id:Int,message:String){
        showLoadingView()
        NetworkManager.shared.addCommentToGeneral(url: "comment_chat", chat_id: id, message: message) { response in
            self.removeLoadingView()
            switch response {
            case .success(let resp):
                print("Done")
               // AlertsManager.showAlert(withTitle: "تم بنجاح", message: resp.message, viewController: self)
            case .failure(let error):
                AlertsManager.showAlert(withTitle: "تنبيه", message: error.localizedDescription, viewController: self)
            }
        }
    }
    
    func deleteCommentFromList(comment_id:Int){
        showLoadingView()
        NetworkManager.shared.deleteComment(url: "delete_debate", comment_id: comment_id) { response in
            self.removeLoadingView()
            switch response {
            case .success(let resp):
                AlertsManager.showAlert(withTitle: "تم بنجاح", message: resp.message, viewController: self)
            case .failure(let error):
                AlertsManager.showAlert(withTitle: "تنبيه", message: error.localizedDescription, viewController: self)
            }
        }
    }
    
    @IBAction func backToDiscussionsBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendComment(_ sender: Any) {
        if commentTF.text == "اكتب مشاركتك" {
            AlertsManager.showAlert(withTitle: "تنبيه", message: "الرجاء كتابة تعليق", viewController: self)
        }else{
            addComment(id: self.idID ?? 0, message: commentTF.text)
        }
    }
}

extension DiscussionDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,DeleteCommentProtocol {
    func deleteComment(tag: Int) {
        AlertsManager.showAlert(withTitle: "هل انت متآكد", message: "هل انت متاكد من حذف هذا التعليق", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler:nil, actionTitle: "نعم", actionStyle: .default) { action in
            self.deleteCommentFromList(comment_id: self.comments?[tag].id ?? 0)
            self.comments?.remove(at: tag)
            self.collectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userLbl.text = comments?[indexPath.row].user?.name
        cell.timeLbl.text = comments?[indexPath.row].date
        cell.commentLbl.text = comments?[indexPath.row].comment
        cell.delegate = self
        cell.deletBtn.tag = indexPath.row
        if UserInfo.getUserID() == comments?[indexPath.row].user?.id {
            cell.deletBtn.isHidden = false
        }else{
            cell.deletBtn.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100.0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTF.textColor == UIColor.lightGray {
            commentTF.text = nil
            commentTF.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTF.text.isEmpty {
            commentTF.text = "اكتب مشاركتك"
            commentTF.textColor = UIColor.lightGray
        }
    }
}

