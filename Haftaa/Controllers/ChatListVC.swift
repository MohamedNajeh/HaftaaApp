//
//  ChatListVC.swift
//  Haftaa
//
//  Created by Najeh on 05/08/2022.
//

import UIKit

class ChatListVC: UIViewController {

    @IBOutlet weak var noConversationsLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var chatList:[ChatData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getChatList()

        setUpTableView()

    }
    
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    
    func getChatList(){
        NetworkManager.shared.fetchData(url: "get_chat", decodable: AllChats.self) { response in
            switch response {
            case .success(let chats):
                print(chats)
                self.chatList = chats.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
extension ChatListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chatList.count == 0 {
            noConversationsLbl.isHidden = false
        }else{
            noConversationsLbl.isHidden = true
        }
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        if chatList[indexPath.row].receivedUserID == 0 {
            cell.titleLbl.text = "الادارة"
            return cell
        }
        if chatList[indexPath.row].receivedUserID == UserInfo.getUserID() {
            cell.titleLbl.text = chatList[indexPath.row].senderUser?.name
        }else{
            cell.titleLbl.text = chatList[indexPath.row].receivedUser?.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        if chatList[indexPath.row].receivedUserID == UserInfo.getUserID() {
            vc.id = (chatList[indexPath.row].senderUser?.id)!
            vc.title = chatList[indexPath.row].senderUser?.name
        }else if chatList[indexPath.row].senderUser?.id == UserInfo.getUserID(){
            vc.id = chatList[indexPath.row].receivedUser?.id ?? 0
            vc.title = chatList[indexPath.row].receivedUser?.name
        }else {
            vc.id = 0
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
