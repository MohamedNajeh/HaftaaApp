//
//  AddsInCity.swift
//  Haftaa
//
//  Created by Apple on 01/08/2022.
//

import UIKit

class AddsInCity: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var addsInCityList:[AddsDetails] = []
    var cityID:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        getAddsInCity()
        // Do any additional setup after loading the view.
    }
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "adsCell", bundle: nil), forCellReuseIdentifier: "adsCell")
    }
    
    func getAddsInCity(){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "ads_city?city_id=\(cityID ?? 0)&lat=\(UserInfo.userLat)&lng=\(UserInfo.userLat)", decodable: MyAds.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let addInCity):
                print(addInCity)
                self.addsInCityList = addInCity.data?.data ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension AddsInCity:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addsInCityList.count == 0 {
            // noFavLBl.isHidden = false
        }else{}//noFavLBl.isHidden = true}
            return addsInCityList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell", for: indexPath) as! adsCell
        if addsInCityList[indexPath.row].isType ?? false {
            cell.configureCell(isLast: true, add: addsInCityList[indexPath.row])
        }else{
            cell.configureCell(isLast: false, add: addsInCityList[indexPath.row])
        }
        cell.title.text = addsInCityList[indexPath.row].title ?? ""
        cell.adImage.setImage(with: addsInCityList[indexPath.row].image ?? "")
        cell.userName.text = addsInCityList[indexPath.row].user?.name ?? ""
        cell.sinceLbl.text = addsInCityList[indexPath.row].since
        if addsInCityList[indexPath.row].lat == "0" || addsInCityList[indexPath.row].lng == "0"{
            cell.countryLbl.text = addsInCityList[indexPath.row].city?.name ?? ""
        }else{
            cell.countryLbl.text = addsInCityList[indexPath.row].distance ?? ""
        }
        
        if addsInCityList[indexPath.row].user?.trusted == 1 {
            cell.userIcon.image = UIImage(named: "verify")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
        vc.addID = addsInCityList[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
