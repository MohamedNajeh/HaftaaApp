//
//  MyAdsVC.swift
//  Haftaa
//
//  Created by Najeh on 14/08/2022.
//

import UIKit

class MyAdsVC: UIViewController {

    @IBOutlet weak var lblNoAds: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var ads:[AddsDetails] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchMyAds()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "adsCell", bundle: nil), forCellReuseIdentifier: "adsCell")
    }
    
    func fetchMyAds(){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "my_ads", decodable: Ads.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let data):
                print(data)
                self.ads = data.data ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MyAdsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ads.isEmpty {
            lblNoAds.isHidden = false
        }else{
            lblNoAds.isHidden = true
        }
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell", for: indexPath) as! adsCell
        if ads[indexPath.row].isType ?? false {
            cell.configureCell(isLast: true, add: ads[indexPath.row])
        }else{
            cell.configureCell(isLast: false, add: ads[indexPath.row])
            cell.onlineView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
        vc.addID = ads[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
