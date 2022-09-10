//
//  SocketHelper.swift
//  SocketChatApp
//
//  Created by Najeh on 20/04/2022.
//

import UIKit
import Foundation
import SocketIO
import UserNotifications

//let kHost = "https://soket.hvps.exdezign.com?user_id=389&user_type=user"
//let kConnectUser = "connectUser"
//let kUserList = "userList"
//let kExitUser = "exitUser"
//
//struct Userr: Codable {
//
//    var id: String?
//    var isConnected: Bool?
//    var nickname: String?
//}


class SocketHelper {
    
    static let shared = SocketHelper()
    
    //private var manager: SocketManager?
   // let manager = SocketManager(socketURL: URL(string: "https://soket.hvps.exdezign.com?user_id=\(UserInfo.getUserID())&user_type=user")!, config: [.connectParams(["user_id":"\(UserInfo.getUserID())","user_type":"user"]),.log(true), .compress])
    let manager = SocketManager(socketURL: URL(string: "https://websocket.hvps.exdezign.com?user_id=\(UserInfo.getUserID())&user_type=user")!, config: [.connectParams(["user_id":"\(UserInfo.getUserID())","user_type":"user"]),.log(true), .compress])
    var socket: SocketIOClient?
    init() {
        //super.init()
        // configureSocketClient()
    }
    
    //    private func configureSocketClient() {
    //
    //        manager = SocketManager(socketURL: URL(string: kHost)!,
    //             config: [.log(true), .compress])
    //        socket = manager?.defaultSocket
    ////        guard let url = URL(string: kHost) else {
    ////            return
    ////        }
    ////
    ////        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
    ////
    ////
    ////
    ////        guard let manager = manager else {
    ////            return
    ////        }
    ////
    ////        socket = manager.defaultSocket
    ////        //socket = manager.socket(forNamespace: "/**********")
    //    }
    
    func establishConnection(){
        socket = manager.defaultSocket
        addHandlers()
        socket?.connect()
        //        getMessage { Message in
        //            print(Message)
        //        }
    }
    
    func addHandlers() {
        
        
        
        socket!.onAny {
            print("Got event: \($0.event), with items: \($0.items!)")
            
        }
        
        socket!.on("new_message") { data, ack in
            print(data)
            
            
            return
        }
        
        socket!.on("connection") { data, ack in
            print(data)
            return
        }
        
        socket!.on("new_notification") { data, ack in
            print(data)
            guard let data = UIApplication.jsonData(from: data) else {
                return
            }
            
            do {
                let messageModel = try JSONDecoder().decode([NotifyModel].self, from: data)
                print(messageModel[0].title)
                self.startNotification(body: messageModel[0].title ?? "" )
                NotificationCenter.default.post(name: .init("showNotifRedCircle"), object: nil )
            } catch let error {
                print("Something happen wrong here...\(error.localizedDescription)")
                
            }
           // self.startNotification()
            return
        }
        
        self.socket!.on(clientEvent: .error) {data, ack in
            print("error")
        }
        
        self.socket!.on(clientEvent: .disconnect){data, ack in
            
            print("disconnect")
            
        }
        
        
        
        self.socket!.emit("get_online", "0")
        //        socket.on(clientEvent: .connect) {data, ack in
        //            print("socket connected")
        //            print(data)
        //
        //            //self.socket.emit("send_message", ["":"hi from ios"])
        //
        //        }
        
    }
    
    func startNotification(body:String){
        print("Here")
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.body = body//"Your Order is about to arrive"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { error in
            if error != nil{
                print(error?.localizedDescription ?? "Error in notification")
            }
        }
        
        
    }
    func getNotification(){
        socket!.on("new_notification") {[weak self] data, ack in
            if let name = data[0] as? String {
                print("Ress\(name)")
            }
        }
    }
    
   
    
    //    func closeConnection() {
    //
    //        guard let socket = manager.defaultSocket else{
    //            return
    //        }
    //
    //        socket.disconnect()
    //    }

    struct MessageModel: Codable {
        let data: [ChatData]?
        let message: String?
        let success: Bool?
        let status: Int?
        let chat_id:Int?
        let reciver_id:String?
        let sender_id:Int?
    }
    
    struct NotifyModel:Codable {
        let id:Int?
        let title:String?
        let user_id:Int?
        let route:String?
    }
    
//    struct ccvv:Codable{
//        let data:CommentModel?
//    }
    
    struct CommentModel: Codable {
        let ads_id: Int?
        let route: String?
        let time: String?
        let id: Int?
        let since:String?
        let user_id:Int?
        let comment:String?
        let name:String?
        let route_user:String?
        let parent_id:Int?
    }
    func getMessage(completion: @escaping (_ messageInfo: [MessageModel]?) -> Void) {
        socket?.on("new_chat") { (dataArray, socketAck) -> Void in
            guard let data = UIApplication.jsonData(from: dataArray) else {
                return
            }
            
            do {
                let messageModel = try JSONDecoder().decode([MessageModel].self, from: data)
                completion(messageModel)
                NotificationCenter.default.post(name: .init("showChatRedCircle"), object: nil )
            } catch let error {
                print("Something happen wrong here...\(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func getGeneralComment(completion: @escaping (_ messageInfo: [CommentModel]?) -> Void) {
        socket?.on("new_comment_debate") { (dataArray, socketAck) -> Void in
            guard let data = UIApplication.jsonData(from: dataArray) else {
                return
            }
            do {
                let messageModel = try JSONDecoder().decode([CommentModel].self, from: data)
                completion(messageModel)
                
            } catch let error {
                print("Something happen wrong here...\(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func getAddComment(completion: @escaping (_ messageInfo: [CommentModel]?) -> Void) {
        socket?.on("new_comment") { (dataArray, socketAck) -> Void in
            guard let data = UIApplication.jsonData(from: dataArray) else {
                return
            }
            do {
                let messageModel = try JSONDecoder().decode([CommentModel].self, from: data)
                completion(messageModel)
                
            } catch let error {
                print("Something happen wrong here...\(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    
    struct onilneUsers:Codable {
        let socket:String?
        let status:Int?
        let id:Int?
        let created_at:String?
        let user_type:String?
        let user_id:Int?
        let updated_at:String?
        
    }
    
    func getOnlineUsers(completion: @escaping (_ messageInfo: [[onilneUsers]]?) -> Void){
        socket?.on("cpnnection_user"){ (dataArray, socketAck) -> Void in
            print(dataArray)
            guard let data = UIApplication.jsonData(from: dataArray) else {
                return
            }
            do {
                let messageModel = try JSONDecoder().decode([[onilneUsers]].self, from: data)
                completion(messageModel)
                
            } catch let error {
                print("Something happen wrong here...\(error.localizedDescription)")
                completion(nil)
            }
        }
        
}
    
//    func getNewComment(completion: @escaping (_ messageInfo: [[onilneUsers]]?) -> Void){
//        socket?.on("new_comment"){ (dataArray, socketAck) -> Void in
//            print(dataArray)
//            guard let data = UIApplication.jsonData(from: dataArray) else {
//                return
//            }
//            do {
//                let messageModel = try JSONDecoder().decode([[onilneUsers]].self, from: data)
//                completion(messageModel)
//
//            } catch let error {
//                print("Something happen wrong here...\(error.localizedDescription)")
//                completion(nil)
//            }
//        }
//
//}
    
    ////
    //    func sendMessage(message: String, withNickname nickname: String) {
    //
    //        guard let socket = manager?.defaultSocket else {
    //            return
    //        }
    //
    //        socket.emit("chatMessage", nickname, message)
    //    }
    
}


extension UIApplication {
    
    static func jsonString(from object:Any) -> String? {
        
        guard let data = jsonData(from: object) else {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func jsonData(from object:Any) -> Data? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        
        return data
    }
    
    
}

