//
//  FavoritesVC.swift
//  Haftaa
//
//  Created by Apple on 01/08/2022.
//

import UIKit

class FavoritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFavLBl: UILabel!
    var favoritesList:[AddsDetails] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        getFavorites()

        // Do any additional setup after loading the view.
    }
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "adsCell", bundle: nil), forCellReuseIdentifier: "adsCell")
    }
    
    func getFavorites(){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "my_favorites", decodable: MyAds.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let favorites):
                print(favorites)
                self.favoritesList = favorites.data?.data ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension FavoritesVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoritesList.count == 0 {
            noFavLBl.isHidden = false
        }else{noFavLBl.isHidden = true}
        return favoritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell", for: indexPath) as! adsCell
        if favoritesList[indexPath.row].isType ?? false {
            cell.configureCell(isLast: true, add: favoritesList[indexPath.row])
        }else{
            cell.configureCell(isLast: false, add: favoritesList[indexPath.row])
        }

        if favoritesList[indexPath.row].lat == "0" || favoritesList[indexPath.row].lng == "0"{
            cell.countryLbl.text = favoritesList[indexPath.row].city?.name
        }else{
            cell.countryLbl.text = favoritesList[indexPath.row].distance
        }
        
        if favoritesList[indexPath.row].user?.trusted == 1 {
            cell.userIcon.image = UIImage(named: "verify")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
        vc.addID = favoritesList[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
