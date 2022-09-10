//
//  NotificationsVC.swift
//  Haftaa
//
//  Created by Apple on 31/07/2022.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noNotificationsLbl: UILabel!
    var notifications:[NotificationItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        getAllNotifications()

        // Do any additional setup after loading the view.
    }
    
    func setupTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    
    func getAllNotifications(){
        NetworkManager.shared.fetchData(url: "get_notification", decodable: NotificationModel.self) { response in
            switch response {
            case .success(let notifications):
                print(notifications)
                self.notifications = notifications.data ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
extension NotificationsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.count == 0 {
            noNotificationsLbl.isHidden = false
        }else{
            noNotificationsLbl.isHidden = true
        }
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.titleLbl.text = notifications[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notifications[indexPath.row].type == "debates_user" {
            let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DiscussionDetailsVC") as! DiscussionDetailsVC
            vc.idID = Int(notifications[indexPath.row].modelID ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }else if notifications[indexPath.row].type == "ads" {
            let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
            vc.addID = Int(notifications[indexPath.row].modelID ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
