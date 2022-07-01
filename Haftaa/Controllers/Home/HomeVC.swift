//
//  ViewController.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var countryLbl: UIButton!
    @IBOutlet weak var cityLbl: UIButton!
    @IBOutlet weak var adsType: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var adsTableView: UITableView!
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var dataSource = [Data]()
    var allContries:[Data] = []
    var cities:[Cities] = []
    var types:[TypeData] = []
    var allAds:[Datu] = []
    var adsTypes = ["طلب","عرض"]
    var tableHeight = 0
    var searchController:UISearchController?
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureDropDownTV()
        configureCollectionView()
        configureAddsTableView()
        //fetchCountries()
        fetchAllTypes()
        configureNavBar()
        fetchAllads()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // Do any additional setup after loading the view.
    }
    
    func configureNavBar(){
        let color:UIColor = UIColor(red: 0/255, green: 117/255, blue: 68/255, alpha: 1)
        configureNavigationBar(largeTitleColor: color, backgoundColor: color, tintColor: .white, title: "سوق الهفتـــــاء", preferredLargeTitle: false)
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.searchBarStyle = .prominent
        searchController?.searchBar.barTintColor = .systemGray
        searchController?.searchBar.placeholder = "ابحث هنـــــا"
        searchController?.searchBar.semanticContentAttribute = .forceRightToLeft
        navigationItem.searchController = searchController
    }
    
    func fetchAllads(){
        NetworkManager.shared.fetchData(url: "https://hvps.exdezign.com/api/all_ads", decodable: Adss.self) { response in
            switch response {
            case .success(let ads):
                self.allAds = ads.data.data
                DispatchQueue.main.async {
                    self.adsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchAllTypes(){
        NetworkManager.shared.fetchData(url: "https://hvps.exdezign.com/api/get_categories", decodable: typeRoot.self) { response in
            switch response {
            case .success(let typesData):
                self.types = typesData.data!
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }

        }
//        NetworkManager.shared.fetchTypes(url: "http://hvps.exdezign.com/api/get_categories") { response in
//            switch response {
//            case .success(let typesData):
//                self.types = typesData.data!
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    
    //    @IBAction func countryFieldActn(_ sender: UIButton) {
    //        if sender.tag == 1 {
    //            //dataSource = allContries
    //            tableHeight = allContries.count
    //            selectedButton = countryLbl
    //            tableView.reloadData()
    //            addTransparentView(frames: countryLbl.frame)
    //        }else if sender.tag == 2 {
    //            //dataSource = ["الرياض", "ابها", "مكة"]
    //            tableHeight = cities.count
    //            selectedButton = cityLbl
    //            tableView.reloadData()
    //            addTransparentView(frames: cityLbl.frame)
    //        }else if sender.tag == 3 {
    //            //dataSource = ["عرض", "طلب"]
    //            tableHeight = adsTypes.count
    //            selectedButton = adsType
    //            addTransparentView(frames: adsType.frame)
    //        }
    //    }
    //    func configureDropDownTV(){
    //        tableView.delegate = self
    //        tableView.dataSource = self
    //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    //    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "productTypeCell", bundle: nil), forCellWithReuseIdentifier: "productTypeCell")
    }
    
        func configureAddsTableView(){
            adsTableView.delegate = self
            adsTableView.dataSource = self
            adsTableView.register(UINib(nibName: "adsCell", bundle: nil), forCellReuseIdentifier: "adsCell")
        }
    
    
    
    
    //    func addTransparentView(frames: CGRect) {
    //        let window = UIApplication.shared.keyWindow
    //        transparentView.frame = window?.frame ?? self.view.frame
    //        self.view.addSubview(transparentView)
    //
    //        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    //        self.view.addSubview(tableView)
    //        tableView.layer.cornerRadius = 5
    //
    //        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    //        tableView.reloadData()
    //        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    //        transparentView.addGestureRecognizer(tapgesture)
    //        transparentView.alpha = 0
    //        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
    //            self.transparentView.alpha = 0.5
    //            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.tableHeight * 50))
    //        }, completion: nil)
    //    }
    
    //    @objc func removeTransparentView() {
    //             let frames = selectedButton.frame
    //             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
    //                 self.transparentView.alpha = 0
    //                 self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    //             }, completion: nil)
    //         }
    
}

//extension HomeVC: UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if selectedButton == cityLbl{
//            return cities.count
//        }
//        else if selectedButton == adsType{
//            return adsTypes.count
//        }
//        return allContries.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//            if selectedButton == cityLbl{
//                cell.textLabel?.text = cities[indexPath.row].name
//                return cell
//            }
//            else if selectedButton == adsType{
//                cell.textLabel?.text = adsTypes[indexPath.row]
//                return cell
//            }
//            cell.textLabel?.text = allContries[indexPath.row].name
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 50
//        }
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            if selectedButton == cityLbl{
//                selectedButton.setTitle(cities[indexPath.row].name, for: .normal)
//                removeTransparentView()
//            }
//            else if selectedButton == adsType{
//                selectedButton.setTitle(adsTypes[indexPath.row], for: .normal)
//                removeTransparentView()
//
//            }else if selectedButton == countryLbl{
//                cities = allContries[indexPath.row].cities!
//                cityLbl.setTitle("اختر المنطقة", for: .normal)
//                selectedButton.setTitle(allContries[indexPath.row].name, for: .normal)
//                removeTransparentView()
//            }
//
//        }
//}

