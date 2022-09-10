//
//  ViewController.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import DropDown
import UserNotifications
class HomeVC: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var countryLbl: UIButton!
    @IBOutlet weak var cityLbl: UIButton!
    @IBOutlet weak var adsType: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var adsTableView: UITableView!
    @IBOutlet weak var advancedSearchButtons: UIStackView!
    @IBOutlet weak var arrowsStack: UIStackView!
    @IBOutlet weak var notifNumberLbl: UILabel!
    @IBOutlet weak var chatsNumberLbl: UILabel!
    @IBOutlet weak var loginBarBtn: UIButton!
    @IBOutlet weak var chatsBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var dataSource = [Country]()
    var allContries:[Country] = []
    var cities:[City] = []
    var types:[Category] = []
    var allAds:[AddsDetails] = []
    var filterdAdds:[AddsDetails] = []
    var filterdByType:[AddsDetails] = []
    //var filteredAds:[Dataa] = []
    var adsTypes = ["طلب","عرض"]
    var tableHeight = 0
    var isSearching = false
    var isTypeFilter = false
    var searchController:UISearchController?
    var selectedType:Int?
    var page = 1
    var totalPages = 0
    let locationManager = CLLocationManager()
    var lat = 0.0
    var lng = 0.0
    let countryDropDown = DropDown()
    let cityDropDown = DropDown()
    let typeDropDown = DropDown()
    var countryID = 0,cityID = 0,categoryID = 0
    var searchAdsType = ""
    var onlineUsersIds:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIsIpad()
        startSocketConnection()
        AppUpdater.shared.showUpdate(withConfirmation: true)
        fetchSettings()
        addObservers()

        configureCollectionView()
        configureAddsTableView()
        observeOnlineUsers()

        configureNavBar()
        fetchCountries()
        
        setupLocation()
        setUpTabbar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        page = 1
        allAds = []
//        isSearching = false
//        isTypeFilter = false
//        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        isTypeFilter = false
        selectedType = -1
        collectionView.reloadData()
        fetchAllads(page: page)
        
        if Connectivity.isConnectedToInternet {
             print("Connected_Wifi")
         } else {
             print("No Internet")
        }
//        if UserInfo.getUserLogin() {
//            SocketHelper.shared.establishConnection()
//        }
        if UserInfo.appSettings?.data.maintenance == 1 {
            let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "MaintainanceVC") as! MaintainanceVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        //page = 1
//        fetchAllads(page: page)
        if UserInfo.getUserLogin() {
            loginBarBtn.isHidden = true
            chatsBtn.isHidden = false
            notificationBtn.isHidden = false
        }else{
            chatsBtn.isHidden = true
            notificationBtn.isHidden = true
            loginBarBtn.isHidden = false
        }
        self.startMarqueeLabelAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func checkIsIpad(){
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let items = self.tabBarController?.tabBar.items
            let tabItem = items![2]
            tabItem.title = ""
            tabItem.image = nil
        }
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(enableAdvancedSearch), name: .init("enableAdvancedSearch"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showChatICon), name: .init("showChatAndNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideChatICon), name: .init("hideChatAndNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNotifRedCircle), name: .init("showNotifRedCircle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showChatRedCircle), name: .init("showChatRedCircle"), object: nil)
    }
    
    func setUpTabbar(){
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func startSocketConnection(){
        if UserInfo.getUserLogin() {
            SocketHelper.shared.establishConnection()
        }
    }
    @objc func showChatICon(){
        chatsBtn.isHidden = false
        notificationBtn.isHidden = false
        loginBarBtn.isHidden = true
        SocketHelper.shared.establishConnection()
    }
    
    @objc func hideChatICon(){
        loginBarBtn.isHidden = false
        chatsBtn.isHidden = true
        notificationBtn.isHidden = true
    }
    
    func startMarqueeLabelAnimation() {

        UIView.animate(withDuration: 5.0, delay: 0.0, options: ([.curveEaseInOut, .repeat]), animations: {
             self.titleLbl.transform = CGAffineTransform(translationX: self.titleLbl.bounds.origin.x - 400, y: self.titleLbl.bounds.origin.y)
        }, completion: nil)
        
        UIView.animate(withDuration: 5.0, delay: 1.0, options: ([.curveEaseInOut, .repeat]), animations: {
            self.titleLbl.transform = .identity
        }, completion: nil)
//        DispatchQueue.main.async(execute: {
//
//            UIView.animate(withDuration: 5.0, delay: 2, options: ([.curveLinear, .repeat]), animations: {() -> Void in
//                self.titleLbl.center = CGPoint(x: 0 + (self.titleLbl.bounds.size.width / 2), y: self.titleLbl.center.y)
//
//
//            }, completion:  nil)
//
//        })
    }
    
    @objc func enableAdvancedSearch(){
        self.advancedSearchButtons.isHidden = false
        self.arrowsStack.isHidden = false
    }
    
    @objc func showNotifRedCircle(){
        notifNumberLbl.isHidden = false
    }
    
    @objc func showChatRedCircle(){
        chatsNumberLbl.isHidden = false
    }
    
    func setupLocation(){
       // if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
      //  }
    }
    
    func observeOnlineUsers(){
        SocketHelper.shared.getOnlineUsers { messageInfo in
            print(messageInfo)
            let arr = messageInfo![0]
            for i in arr {
                self.onlineUsersIds.append(i.user_id ?? 0)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func configureNavBar(){
        let color:UIColor = UIColor.lightSkyColor
        configureNavigationBar(largeTitleColor: color, backgoundColor: color, tintColor: .black, title: "سوق الهفتـــــاء", preferredLargeTitle: false)
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.searchBarStyle = .prominent
        searchController?.searchBar.barTintColor = .systemGray
        searchController?.searchBar.searchTextField.becomeFirstResponder()
        searchController?.searchBar.placeholder = "ابحث هنـــــا"
        searchController?.searchBar.semanticContentAttribute = .forceRightToLeft
        searchController?.searchBar.delegate = self
        searchController?.searchBar.searchTextField.textAlignment = .right
        searchController?.searchBar.setValue("الغاء", forKey: "cancelButtonText")
        //navigationItem.searchController = searchController
       // navigationItem.rightBarButtonItem = button
        notifNumberLbl.layer.masksToBounds = true
        chatsNumberLbl.layer.masksToBounds = true
       
    }
    
    @objc func printt(){
        print("dd")
    }
    
    func fetchSettings(){
        //showLoadingView()
        NetworkManager.shared.fetchData(url: "get_settings", decodable: SettingsModel.self) { response in
            //self.removeLoadingView()
            switch response {
            case .success(let settings):
                UserInfo.appSettings = settings
                DispatchQueue.main.async {
                    self.titleLbl.text = settings.data.notification
                }
                self.fetchAllTypes()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCountries(){
        NetworkManager.shared.fetchData(url: "get_country", decodable: countriesRoot.self) { response in
            switch response {
            case .success(let contries):
                self.allContries = contries.data ?? []
                UserInfo.countries = contries.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchAdsSuccessfully(addArray:[AddsDetails]?){
        if self.allAds.count == 0
        {
            self.allAds = addArray ?? []
            if addArray?.count == 0 {
            //self.lblNoData.isHidden = false
            }
            adsTableView.reloadData()
        }
        else
        {
            //self.lblNoData.isHidden = true

            if addArray?.count ?? 0 > 0 {
                //self.allAds.append(contentsOf: addArray)
                self.allAds.append(contentsOf: addArray ?? [])
                adsTableView.reloadData()
                
            }else
            {
                self.adsTableView.tableFooterView?.isHidden = true
            }
        }
    }
    
    func fetchAllads(page:Int){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "all_ads?lat=\(self.lat)&lng=\(self.lng)&page=\(page)", decodable: MyAds.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let ads):
                //self.allAds = ads.data.data
                self.totalPages = (ads.data?.pages)!
                self.fetchAdsSuccessfully(addArray: ads.data?.data ?? [])
                if DeeplinkManger.shared.homeViewingType == .shareAdd {
                    let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
                    vc.addID = Int(DeeplinkManger.addIDD ?? "0")
                    Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { _ in
                        self.navigationController?.pushViewController(vc, animated: true)
                        DeeplinkManger.shared.homeViewingType = HomeViewingType.none
                    }
          
                }
//                DispatchQueue.main.async {
//                    self.adsTableView.reloadData()
//                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchAllTypes(){
        NetworkManager.shared.fetchData(url: "get_categories", decodable: typeRoot.self) { response in
            switch response {
            case .success(let typesData):
                self.types = typesData.data ?? []
                UserInfo.allTypes = typesData.data ?? []
                if typesData.status == 401 {
                    AlertsManager.showAlert(withTitle: "عذرا", message:"لقد تم تسجيل الدخول من حساب اخر" , viewController: self, showingCancelButton: false, showingOkButton: true, cancelHandler: nil, actionTitle: "تسجيل الدخول", actionStyle: .default) { _ in
                        UserInfo.logOut()
                        UserInfo.openLoginVC()
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }

        }
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "productTypeCell", bundle: nil), forCellWithReuseIdentifier: "productTypeCell")
    }
    
    func configureAddsTableView(){
        adsTableView.delegate = self
        adsTableView.dataSource = self
        adsTableView.register(UINib(nibName: "adsCell", bundle: nil), forCellReuseIdentifier: "adsCell")
        adsTableView.register(UINib(nibName: "adsFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "adsFooterTableViewCell")
    }
    
    
    func searchByCategory(categoryID:Int?,cityID:Int?,countryID:Int?,adsType:String?,searchText:String?){
        showLoadingView()
        NetworkManager.shared.searchAdds(url: "search_ads", categoryID: categoryID, cityID: cityID, countryID: countryID, adsType: adsType, searchText: searchText){ result in
            self.removeLoadingView()
            switch result {
            case .success(let ads):
                DispatchQueue.main.async {
                    self.filterdByType = ads.data?.data ?? []
                    self.adsTableView.reloadData()
                    print(ads)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @IBAction func chooseCountryBtn(_ sender: UIButton) {
        var names:[String] {allContries.map(\.name!)}
        countryDropDown.dataSource = names
        countryDropDown.anchorView = sender
        countryDropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
        countryDropDown.direction = .bottom
        countryDropDown.show()
        countryDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .right
        }
        countryDropDown.selectionAction = {[weak self] (index: Int , item: String) in
            guard let _ = self else {return}
            sender.setTitle(item, for: .normal)
            self?.cities = self?.allContries[index].cities ?? []
            self?.countryID = self?.allContries[index].id ?? 0
            self?.searchByCategory(categoryID: self?.categoryID, cityID: self?.cityID, countryID: self?.countryID, adsType: self?.searchAdsType, searchText: "")
            self?.isTypeFilter = true
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    @IBAction func chooseCityLbl(_ sender: UIButton) {
        var names:[String] {cities.map(\.name!)}
        countryDropDown.dataSource = names
        countryDropDown.anchorView = sender
        countryDropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
        countryDropDown.direction = .bottom
        countryDropDown.show()
        countryDropDown.selectionAction = {[weak self] (index: Int , item: String) in
            guard let _ = self else {return}
            sender.setTitle(item, for: .normal)
            self?.cityID = self?.cities[index].id ?? 0
            self?.searchByCategory(categoryID: self?.categoryID, cityID: self?.cityID, countryID: self?.countryID, adsType: self?.searchAdsType, searchText: "")
            self?.isTypeFilter = true
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func chooseTypeBtn(_ sender: UIButton) {
        let names:[String] = ["طلب","عرض"]
        countryDropDown.dataSource = names
        countryDropDown.anchorView = sender
        countryDropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
        countryDropDown.direction = .bottom
        countryDropDown.show()
        countryDropDown.selectionAction = {[weak self] (index: Int , item: String) in
            guard let _ = self else {return}
            sender.setTitle(item, for: .normal)
            self?.searchAdsType = names[index]
            self?.searchByCategory(categoryID: self?.categoryID, cityID: self?.cityID, countryID: self?.countryID, adsType: self?.searchAdsType, searchText: "")
            self?.isTypeFilter = true
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
    }
    
    @IBAction func endAdvancedSearch(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            self.advancedSearchButtons.isHidden = true
            self.arrowsStack.isHidden = true
        }
    }
    
    
    @IBAction func notificationBtnPressed(_ sender: Any) {
        notifNumberLbl.isHidden = true
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func chatsBtnPressed(_ sender: Any) {
        chatsNumberLbl.isHidden = true
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func searchBtnPresssd(_ sender: Any) {
        if searchTF.text == "" {
            AlertsManager.showAlert(withTitle: "خطأ", message: "برجاء كتابة عنوان البحث", viewController: self)
        }else{
            
            isTypeFilter = true
            self.searchByCategory(categoryID: categoryID, cityID: cityID, countryID: countryID, adsType:searchAdsType, searchText: searchTF.text)
        }
        
    }
    
    
    @IBAction func refreshPage(_ sender: Any) {
        selectedType = -1
        page = 1
        allAds = []
        isTypeFilter = false
        collectionView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            self.fetchAllads(page: self.page)
        }
       // tableView.reloadData()
    }
}
extension HomeVC:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.lng = locValue.longitude
        UserInfo.userLat = "\(locValue.latitude)"
        UserInfo.userLng = "\(locValue.longitude)"
    }
}


