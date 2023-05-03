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
    var parentID = 0
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
        detailsLbl.attributedText = data.datumDescription?.htmlToAttributedString
        dislikesCountLbl.text = "\(data.countDisLike ?? 0)"
        likesCountLbl.text = "\(data.countLike ?? 0)"
        commentsCountLbl.text = "\(data.countComment ?? 0)"
        sinceLbl.text = data.since
        titleLbl.text = data.title
    }
    
    func observeNewComment(){
        SocketHelper.shared.getGeneralComment { [weak self] messageInfo in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.getDetails(id: self?.idID ?? 0)
            }
        }
    }
    
    func getDetails(id:Int){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "general_chat/\(id)", decodable: OneDiscussionDetails.self) {[weak self] response in
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
                self?.removeLoadingView()
            }
            switch response {
            case .success(let resp):
                print(resp)
                self?.details = resp
                self?.comments = resp.data?.comments ?? []
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.setDataInView(data: resp.data!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addComment(id:Int,message:String,parentID:Int){
        showLoadingView()
        NetworkManager.shared.addCommentToGeneral(url: "comment_chat", chat_id: id, message: message,parentID:parentID) { response in
            self.removeLoadingView()
            switch response {
            case .success(let _):
                print("Done")
                self.parentID = 0
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
            addComment(id: self.idID ?? 0, message: commentTF.text, parentID: self.parentID)
        }
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let sharePath = details?.data?.route ?? ""
        let message = "يسعدنا انضمامك للمناقشة: \(details?.data?.title ?? "") في سوق الهفتاء"
        if let name = URL(string: sharePath), !name.absoluteString.isEmpty {
            let objectsToShare = [message,name] as [Any]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
            AlertsManager.showAlert(withTitle: "خطأ", message: "حدث خطأ غي مشاركة الاعلان", viewController: self)
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
    
    func showParent(tag: Int) {
        guard let parent = comments?[tag].parent else {
            print("couldn't get parent at tag \(tag)")
            return
        }
        print("parent id is\(parent.id ?? 0)")
        if let index = comments?.firstIndex(where: { $0.id == parent.id }) {
            print("Index of element with id: \(index)  \(comments?[index].id ?? 0)")
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
            print("Text field: \(textField?.text ?? "")")
            self.addComment(id: self.idID ?? 0, message: textField?.text ?? "", parentID: self.comments?[tag].id ?? 0)
        }))
        
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel, handler: nil))

        // 4. Present the alert.
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
      
        //self.parentID = parent ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.userLbl.text = comments?[indexPath.row].user?.name
        cell.timeLbl.text = comments?[indexPath.row].date
        cell.commentLbl.text = comments?[indexPath.row].comment
        
        if comments?[indexPath.row].parent ?? nil != nil {
            cell.parentLbl.setTitle("#\(comments?[indexPath.row].parent?.comment ?? "") @\(comments?[indexPath.row].parent?.user?.name ?? "")", for: .normal)
        }
        
        cell.delegate = self
        cell.deletBtn.tag      = indexPath.row
        cell.showParentBtn.tag = indexPath.row
        cell.replayBtn.tag     = indexPath.row
        cell.deletBtn.isHidden = comments?[indexPath.row].delete == 1 ? false : true
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

