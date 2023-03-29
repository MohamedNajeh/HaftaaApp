//
//  ChatVC.swift
//  Haftaa
//
//  Created by Najeh on 08/06/2022.
//

import UIKit
import IQKeyboardManagerSwift
class ChatVC: UIViewController {

    @IBOutlet weak var lblNoMessages: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTF: UITextField!
    var chatData:ChatData?
    var messages:[Message] = []
    var defaultMessage = ""
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
   // var id = 0 {
//        didSet {
//            showChatMessages(id: id)
//        }
//    }
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        self.tabBarController?.tabBar.isHidden = true
     //   IQKeyboardManager.shared.keyboardDistanceFromTextField = 50.0
        SocketHelper.shared.establishConnection()
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "cell")
        SocketHelper.shared.getNotification()
        observeNewChatMessage()
        showChatMessages(id: self.id)
        self.messageTF.text = defaultMessage
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        //getChatMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getChatMessages(){
        NetworkManager.shared.fetchData(url: "get_chat", decodable: ChatModel.self) { response in
            switch response {
            case .success(let chat):
                print(chat)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func observeNewChatMessage(){
        SocketHelper.shared.getMessage { messageInfo in
           // print(messageInfo)
//            var idd = 0
//            let reciever = Int(messageInfo?[0].reciver_id ?? "0")
//            if reciever == UserInfo.getUserID() {
//                idd = messageInfo?[0].sender_id ?? 0
//            }else{
//                idd = reciever ?? 0
//            }
//            self.id = idd
            //self.showChatMessages(id: id)
            let user = ChatUser(id: messageInfo?[0].sender_id, userName: "", name: "", phone: "", photoPath: "", photoID: "", nationalIdentityPath: "", nationalIdentity: 0, commercialRegisterPath: "", commercialRegister: 0, favourPath: "", favour: 0, workPermitPath: "", workPermit: 0, sajalMadaniun: "", allowPhone: 0, whatsapp: 0, email: "", city: nil, newPassword: 0, country: nil, step: 0, trusted: 0)
            let message = Message(id: messageInfo?[0].chat_id, message: messageInfo?[0].message, senderUser: user, senderID: user.id)
            self.messages.append(message)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func showChatMessages(id:Int){
        NetworkManager.shared.fetchData(url: "show_chat/\(id)", decodable: ChatModel.self) { response in
            switch response {
            case .success(let model):
                print(model)
                self.chatData = model.data
                self.messages = model.data?.messages ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func sendMessageBtn(_ sender: Any) {
        NetworkManager.shared.sendMessage(url: "send_message", id: self.id, message: messageTF.text) { response in
            switch response {
            case .success(let resonse):
                print(response)
                self.showChatMessages(id: self.id)
                DispatchQueue.main.async {
                    self.messageTF.text = ""
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.keyboardHeightLayoutConstraint?.constant = 0.0
        } else {
            self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
}



extension ChatVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count == 0{
            lblNoMessages.isHidden = false
        }else {
            lblNoMessages.isHidden = true
        }
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
        cell.textView.text = messages[indexPath.row].message
        if messages[indexPath.row].senderUser?.id == UserInfo.getUserID() {
            cell.chatStack.alignment = .trailing
            cell.textView.backgroundColor = .lightSkyColor
        }else{
            cell.chatStack.alignment = .leading
            cell.textView.backgroundColor = .darkSkyColor
        }
//        if indexPath.row % 2 == 0 {
//            cell.textView.text = "اختبار الشات جهة الارسال"
//            cell.chatStack.alignment = .leading
//        }
//        else {
//            cell.chatStack.alignment = .trailing
//            cell.textView.text = "   test reciver side message اختبار الشات جهة الاستقبال "
//        }
        return cell
    }
}
