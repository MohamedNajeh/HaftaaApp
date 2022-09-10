//
//  UserDetailsVC.swift
//  Haftaa
//
//  Created by Najeh on 29/07/2022.
//

import UIKit

class UserDetailsVC: UIViewController {

    
    @IBOutlet weak var userImgV: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userCityLbl: UILabel!
    @IBOutlet weak var sinceLbl: UILabel!
    @IBOutlet weak var userRateLbl: UILabel!
    @IBOutlet weak var whatsStackView: UIStackView!
    
    @IBOutlet weak var phoneStack: UIStackView!
    @IBOutlet weak var messageStack: UIStackView!
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentsCollectionV: UICollectionView!
    var userDetails:User?
    var myAds:[AddsDetails] = []
    var comments:[Comment] = []
    var rates:[Rate] = []
    var totalPages = 0
    var page = 1
    var rateSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureDataInView()
        configureCollection()
        configureTable()
        getUserAds(page: page)

    }
    
    func configureCollection(){
        commentsCollectionV.delegate = self
        commentsCollectionV.dataSource = self
        commentsCollectionV.register(UINib(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        
        
        commentsCollectionV.register(CommentsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommentsHeaderCollectionReusableView")
        commentsCollectionV.register(CommentsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CommentsHeaderCollectionReusableView")
    }
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "adsCell", bundle: nil), forCellReuseIdentifier: "adsCell")
        tableView.register(UINib(nibName: "ReviesCell", bundle: nil), forCellReuseIdentifier: "ReviesCell")
    }
    
    func configureDataInView(){
        userImgV.setImage(with: userDetails?.photoPath ?? "")
        userNameLbl.text = userDetails?.name ?? ""
        userCityLbl.text = "\(userDetails?.country?.name ?? "")  \(userDetails?.city?.name ?? "")"
        //sinceLbl.text = userDetails.
        if userDetails?.allowPhone == 0 {
            phoneStack.isHidden = true
        }else{
            phoneStack.isHidden = false
        }
        if userDetails?.whatsapp == 0 {
            whatsStackView.isHidden = true
        }else{
            whatsStackView.isHidden = false
        }
        
    }
    
    func fetchAdsSuccessfully(addArray:[AddsDetails]){
        if self.myAds.count == 0
        {
            self.myAds = addArray
            if addArray.count == 0 {
            //self.lblNoData.isHidden = false
            }
            tableView.reloadData()
        }
        else
        {
            //self.lblNoData.isHidden = true

            if addArray.count > 0 {
                self.myAds.append(contentsOf: addArray)
                tableView.reloadData()
                
            }else
            {
                self.tableView.tableFooterView?.isHidden = true
            }
        }
    }
    
    func getUserAds(page:Int){
        let userID = userDetails?.id
        let lat = UserInfo.userLat
        let lng = UserInfo.userLng
        showLoadingView()
        NetworkManager.shared.fetchData(url: "ads_user?user_id=\(userID ?? 0)&lat=\(lat)&lng=\(lng)&page=\(page)", decodable: UserAdsModel.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let ads):
                self.comments = ads.data?.comments ?? []
                self.rates = ads.data?.rate ?? []
                self.totalPages = ads.data?.pages ?? 1
                self.fetchAdsSuccessfully(addArray: ads.data?.data ?? [])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.commentsCollectionV.reloadData()
                    self.userRateLbl.text = ads.data?.totleRate
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    @IBAction func whatsappMessage(_ sender: Any) {
        let phoneNumber =  userDetails?.phone//"+201030778096" // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber ?? "000")")!
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                }
                else {
                    UIApplication.shared.openURL(appURL)
                }
            }

    }
    @IBAction func phoneCall(_ sender: Any) {
        let phoneNumber =  userDetails?.phone
        if let url = URL(string: "tel://\(phoneNumber ?? "000")") {
             UIApplication.shared.open(url)
         }
    }
    @IBAction func chatMessage(_ sender: Any) {
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.id = self.userDetails?.id ?? 0
        vc.title = self.userDetails?.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func myAdsButton(_ sender: Any) {
        rateSelected = false
        tableView.reloadData()
        commentsButton.backgroundColor = .lightSkyColor
        commentsButton.setTitleColor(.black, for: .normal)
        reviewsButton.backgroundColor = .lightSkyColor
        reviewsButton.setTitleColor(.black, for: .normal)
        adsButton.backgroundColor = .link
        adsButton.setTitleColor(.white, for: .normal)
        commentsCollectionV.isHidden = true
        tableView.isHidden = false
        
    }
    @IBAction func myCommentsButton(_ sender: Any) {
        rateSelected = false
        tableView.reloadData()
        adsButton.backgroundColor = .lightSkyColor
        adsButton.setTitleColor(.black, for: .normal)
        reviewsButton.backgroundColor = .lightSkyColor
        reviewsButton.setTitleColor(.black, for: .normal)
        commentsButton.backgroundColor = .link
        commentsButton.setTitleColor(.white, for: .normal)
        commentsCollectionV.isHidden = false
        tableView.isHidden = true
    }
    @IBAction func reviewsAds(_ sender: Any) {
        rateSelected = true
        tableView.reloadData()
        adsButton.backgroundColor = .lightSkyColor
        adsButton.setTitleColor(.black, for: .normal)
        commentsButton.backgroundColor = .lightSkyColor
        commentsButton.setTitleColor(.black, for: .normal)
        reviewsButton.backgroundColor = .link
        reviewsButton.setTitleColor(.white, for: .normal)
        commentsCollectionV.isHidden = true
        tableView.isHidden = false
    }
}


extension UserDetailsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rateSelected {
            return rates.count
        }
        return myAds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if rateSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviesCell", for: indexPath) as! ReviesCell
            cell.timeLbl.text = rates[indexPath.row].date
            cell.commentTV.text = rates[indexPath.row].rateDescription
            cell.userLbl.text = rates[indexPath.row].user?.userName
            cell.ratingVieq.rating = Double(rates[indexPath.row].rate ?? 0)
            
            return cell
            //cell.rateView.rate = 5
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell", for: indexPath) as! adsCell
        if myAds[indexPath.row].isType ?? false {
            cell.configureCell(isLast: true, add: myAds[indexPath.row])
        }else{
            cell.configureCell(isLast: false, add: myAds[indexPath.row])
            cell.onlineView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = 0
        let lastRowIndex = myAds.count - 1
        
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && page < totalPages{
//            let spinner = UIActivityIndicatorView(style:.medium)
//               spinner.startAnimating()
//               spinner.frame = CGRect(x: CGFloat(0), y:CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            page += 1
            self.getUserAds(page: page)
           // self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    

}
