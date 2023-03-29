//
//  DisscussionsVC.swift
//  Haftaa
//
//  Created by Apple on 02/08/2022.
//

import UIKit

class DisscussionsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var discussions:[Discussions]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "مناقشات عامة"
        configureTableView()
        getDiscussions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.getUserLogin() {
            
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    

  
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "DiscussionsCell", bundle: nil), forCellReuseIdentifier: "DiscussionsCell")
    }
    
    func getDiscussions(){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "general_chat", decodable: DiscussionModel.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let discussions):
                print(discussions)
                self.discussions = discussions.data?.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension DisscussionsVC:UITableViewDelegate,UITableViewDataSource,navigateToDetails {
    func navigateToDetailsScreen(sender: Int) {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DiscussionDetailsVC") as! DiscussionDetailsVC
        vc.idID = discussions?[sender].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionsCell", for: indexPath) as! DiscussionsCell
        cell.configureCell(data: (self.discussions?[indexPath.row])!)
        cell.btnTitle.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "DiscussionDetailsVC") as! DiscussionDetailsVC
        vc.idID = discussions?[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
