//
//  adsDetailsVC.swift
//  Haftaa
//
//  Created by Apple on 03/07/2022.
//

import UIKit
import AVKit
import AVFoundation
import Cosmos
import DropDown
import Alamofire
class
adsDetailsVC: UITableViewController {
    
    var details:AddsDetails?
    var related:[AddsDetails]?
    var images:[Image]?
    var reasons:[reasonElement] = []
    var isRate = true
    var dropDown = DropDown()
    var reasonID = 0 , displayesImage = 1
    var addID:Int?
    var selectedImage:UIImage?
    
    
    @IBOutlet weak var tabll: UITableView!
    @IBOutlet weak var adImagesCollection: UICollectionView!
    @IBOutlet weak var vedioImgV: UIImageView!
    @IBOutlet weak var btnImages: UIButton!
    @IBOutlet weak var btnVedio: UIButton!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblSince: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblReportNum: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var rateView: UIView!
    
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnPlayVedio: UIButton!
    
    
    @IBOutlet weak var noPhotosImgV: UIImageView!
    @IBOutlet weak var likeImg: UIImageView!
    
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var arrowDonOutlet: UIImageView!
    
    @IBOutlet weak var rateStarsView: CosmosView!
    @IBOutlet weak var notesTV: UITextField!
    @IBOutlet weak var commentsAndAdTable: UICollectionView!
    
    @IBOutlet weak var commentsBtn: UIButton!
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var relatedAdsBtn: UIButton!
    
    
    @IBOutlet weak var commentTF: UITextView!
    @IBOutlet weak var btnSendComment: UIButton!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var imagesAndVedioView: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var stackDeleteAndEdit: UIStackView!
    
    @IBOutlet weak var imagesCountLbl: UILabel!
    
    
    @IBOutlet weak var productPriceTV: UITextView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var transactionNumberTF: UITextField!
    @IBOutlet weak var selectionFileLbl: UILabel!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var lblCommision: UILabel!
    @IBOutlet weak var firstBankNameOutlet: UILabel!
    @IBOutlet weak var fistBankNumber: UILabel!
    @IBOutlet weak var firstBankIBAN: UILabel!
    @IBOutlet weak var seconBankTitle: UILabel!
    @IBOutlet weak var secondBankNumber: UILabel!
    @IBOutlet weak var secondBankIBAN: UILabel!
    
    
    let view1 = UIView()
    let stackView = UIStackView()
    let btnWhatsApp = UIButton()
    let btnTwitter = UIButton()
    let btnFaceBook = UIButton()
    let btnSnapChat = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getReasons()
        configureCommentsTable()
        AttachmentHandler.shared.delegate = self
        commentsAndAdTable.register(CommentsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CommentsHeaderCollectionReusableView")
        commentsAndAdTable.register(CommentsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CommentsHeaderCollectionReusableView")
        configureUI()
        commentTF.text = "اكتب تعليقك"
        commentTF.textColor = UIColor.lightGray
        commentTF.delegate = self
        
        productPriceTV.text = "ادخل سعر المنتج"
        productPriceTV.textColor = UIColor.lightGray
        productPriceTV.delegate = self
        observeNewComment()
        
        lblCommision.text = "دفع نسبة السوق \(UserInfo.appSettings?.data.commission ?? 1) %، لحساب نسبة السوق ادخل قيمة البيع"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAddDetails(id: self.addID ?? 0)
    }
    
    func observeNewComment(){
        SocketHelper.shared.getAddComment { messageInfo in
            self.getAddDetails(id: self.addID ?? 0)
        }
    }
    

    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    func setVedioImage(){
        guard let url = URL(string: details?.video ?? "") else {
            return
        }
        AVAsset(url: url).generateThumbnail { [weak self] (image) in
            DispatchQueue.main.async {
                guard let image = image else { return }
                self?.vedioImgV.image = image
            }
        }
    }
    
    func configureAdPrperties(){
        lblType.text = details?.adsType
        lblCity.text = details?.city?.name ?? ""
        lblArea.text = details?.area?.name ?? ""
        lblCategory.text = details?.category?.name ?? ""
        lblNumber.text = "\(details?.id ?? 0)"
        lblSince.text = details?.since
        lblName.text = details?.user?.name ?? ""
        lblRate.text = details?.rate ?? ""
        lblReportNum.text = "0"
    }
    
    func hideViewsIfNoImagesAndVedio(){
        if images?.count == 0 && details?.video == "" {
            imagesAndVedioView.isHidden = true
            btnImages.isHidden = true
            imagesCountLbl.isHidden = true
            btnVedio.isHidden = true
        }else if images?.count != 0 && details?.video == "" {
            btnVedio.isHidden = true
        }else if images?.count == 0 && details?.video != "" {
            btnImages.isHidden = true
            imagesCountLbl.isHidden = true
        }
            
        
        
    }
    
    func configureCommentsTable(){
        commentsAndAdTable.delegate = self
        commentsAndAdTable.dataSource = self
        commentsAndAdTable.register(UINib(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        
    }
    
    func configureUI(){
        adImagesCollection.register(UINib(nibName: "adImagesCell", bundle: nil), forCellWithReuseIdentifier: "adImagesCell")
        commentsAndAdTable.register(UINib(nibName: "CommentsListCell", bundle: nil), forCellWithReuseIdentifier: "CommentsListCell")
        commentsAndAdTable.register(UINib(nibName: "CustomersReviewsCell", bundle: nil), forCellWithReuseIdentifier: "CustomersReviewsCell")
        commentsAndAdTable.register(UINib(nibName: "RelatedAddsListCell", bundle: nil), forCellWithReuseIdentifier: "RelatedAddsListCell")
        adImagesCollection.delegate = self
        adImagesCollection.dataSource = self
        self.btnVedio.setImage(UIImage(named: "zoom")?.tinted(with: .white), for: .normal)
        self.btnImages.setImage(UIImage(named: "insert-picture-icon")?.tinted(with: .black), for: .normal)
        if images?.count == 0 {
            noPhotosImgV.image = UIImage(named: "box")
        }
    }
    
    func configureViewShare(){
        view1.backgroundColor = .clear
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.cornerRadius = 20
        view1.tag = 222
        view1.backgroundColor = .clear
        self.view.addSubview(view1)
        NSLayoutConstraint.activate([
            view1.topAnchor.constraint(equalTo: btnShare.bottomAnchor , constant: 5.0),
            view1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor ,constant: 0.0),
            view1.heightAnchor.constraint(equalToConstant: 50.0),
            view1.widthAnchor.constraint(equalToConstant: 200.0)
        ])
    }
    
    func configureShareStackView(){
        
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view1.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view1.topAnchor , constant: 0.0),
            stackView.leadingAnchor.constraint(equalTo: view1.leadingAnchor , constant: 0.0),
            stackView.trailingAnchor.constraint(equalTo: view1.trailingAnchor , constant: 0.0),
            stackView.bottomAnchor.constraint(equalTo: view1.bottomAnchor , constant: 0.0)
        ])
    }
    
    func configureBtns(){
        btnWhatsApp.setImage(UIImage(named: "whatsapp"), for: .normal)
        btnWhatsApp.addTarget(self, action: #selector(openWhatsApp), for: .touchUpInside)
        btnTwitter.setImage(UIImage(named: "chat-bubble"), for: .normal)
        btnTwitter.addTarget(self, action: #selector(chatUser), for: .touchUpInside)
        btnFaceBook.setImage(UIImage(named: "telephone"), for: .normal)
        btnFaceBook.addTarget(self, action: #selector(callPhone), for: .touchUpInside)
        btnSnapChat.setImage(UIImage(named: "snapchat"), for: .normal)
        btnWhatsApp.translatesAutoresizingMaskIntoConstraints = false
        btnTwitter.translatesAutoresizingMaskIntoConstraints = false
        btnFaceBook.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(btnWhatsApp)
        stackView.addArrangedSubview(btnTwitter)
        stackView.addArrangedSubview(btnFaceBook)
        //stackView.addArrangedSubview(btnSnapChat)
    }
    
    @objc func openWhatsApp(){
        let phoneNumber =  details?.phone//"+201030778096" // you need to change this number
        let message = "السلام عليكم بخصوص اعلانك في سوق الهفتاء رقم (\(details?.id ?? 0)) حول \(details?.title ?? "")"
        var sample = URLComponents(string: "https://api.whatsapp.com/send")
        sample?.queryItems = [URLQueryItem(name: "phone", value: phoneNumber),URLQueryItem(name: "text", value: message)]
        guard let appURL = sample?.url else { return }
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }
    }
    
    @objc func callPhone(){
        let phoneNumber =  details?.phone
        if let url = URL(string: "tel://\(phoneNumber ?? "000")") {
             UIApplication.shared.open(url)
         }
    }
    
    @objc func chatUser(){
        let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.id = details?.user?.id ?? 0
        vc.title = details?.user?.name
        vc.defaultMessage = "رسالة خاصة بخصوص الاعلان \(details?.title ?? "")"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addRateToAdd(){
    
        NetworkManager.shared.addRate(url: "add_rate", addID: details?.id, rate: Int(rateStarsView.rating), description: notesTV.text) { response in
            switch response {
            case .success(let res):
                AlertsManager.showAlert(withTitle: "تم بنجاح", message: "تم اضافة تقييمك بنجاح", viewController: self)
                print(res)
            case .failure(let error):
                AlertsManager.showAlert(withTitle: "حدث خطأ", message: error.localizedDescription, viewController: self)
                print(error)
            }
        }
    }
    
    func reportAd(){

        NetworkManager.shared.reportAd(url: "add_report", addID: details?.id, reasonID: reasonID, comment: notesTV.text) { response in
            switch response {
            case .success(let add):
                AlertsManager.showAlert(withTitle: "تم بنجاح", message: "تمت اضافة بلاغك بنجاح", viewController: self)
                print(add)
            case .failure(let error):
                AlertsManager.showAlert(withTitle: "حدث خطأ", message: error.localizedDescription, viewController: self)
                print(error)
            }
        
        }
    }
    
    func getReasons(){
        NetworkManager.shared.fetchData(url: "get_reason", decodable: ReportReason.self) { response in
            switch response {
            case .success(let resp):
                print(resp)
                self.reasons = resp.data ?? []
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAddDetails(id:Int){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "show_ads/\(id)", decodable: AddDetailsModel.self) { [weak self] response in
            guard let `self` = self else { return }
            self.removeLoadingView()
            switch response {
            case .success(let adDetails):
                print(adDetails)
                self.details = adDetails.data?.ads
                self.related = adDetails.data?.related
                DispatchQueue.main.async {
                    self.images = self.details?.images
                    self.imagesCountLbl.text = "\(self.displayesImage)/\(self.images?.count ?? 0)"
                    self.lblTitle.text = self.details?.title
                    self.tvDescription.text = self.details?.detail
                    self.configureAdPrperties()
                    self.setVedioImage()
                    self.commentsAndAdTable.reloadData()
                    self.adImagesCollection.reloadData()
                    self.likeImg.image = self.details?.favorit == 1 ? self.likeImg.image?.tinted(with: .red) : self.likeImg.image?.tinted(with: .blue)
                    self.firstBankNameOutlet.text = self.details?.bankAccounts?[0].name
                    self.fistBankNumber.text = self.details?.bankAccounts?[0].number_account
                    self.firstBankIBAN.text       = self.details?.bankAccounts?[0].iban
                    
                    self.seconBankTitle.text      = self.details?.bankAccounts?[1].name
                    self.secondBankNumber.text    = self.details?.bankAccounts?[1].number_account
                    self.secondBankIBAN.text      = self.details?.bankAccounts?[1].iban
                    
                    self.hideViewsIfNoImagesAndVedio()
                    if self.details?.commentAllow == 0 {
                        self.commentTF.isHidden = true
                        self.btnSendComment.isHidden = true
                    }
                    if self.details?.user?.allowPhone == 0 {
                        self.btnFaceBook.isHidden = true
                    }
                    
                    if self.details?.user?.whatsapp == 0 {
                        self.btnWhatsApp.isHidden = true
                    }
                    if self.details?.edit == 1 {
                        self.btnEdit.isHidden = false
                    }
                    
                    if self.details?.delete == 1 {
                        self.btnDelete.isHidden = false
                    }
                    
                    if self.details?.user?.id == UserInfo.getUserID() {
                        self.paymentView.isHidden = false
                    }
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func vedioBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0) {
            self.adImagesCollection.isHidden = true
            self.vedioImgV.isHidden = false
            self.btnVedio.backgroundColor = UIColor.lightSkyColor
            self.btnVedio.setImage(UIImage(named: "zoom")?.tinted(with: .black), for: .normal)
            
            self.btnImages.backgroundColor = UIColor.darkSkyColor
            self.btnImages.setImage(UIImage(named: "insert-picture-icon")?.tinted(with: .white), for: .normal)
            
            guard let _ = URL(string: self.details?.video ?? "") else {
                self.btnPlayVedio.isHidden = true
                self.vedioImgV.image = UIImage(named: "no-video")
                return
            }
            self.btnPlayVedio.isHidden = false
            
        }
        
    }
    
    
    @IBAction func imagesBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0) {
            self.adImagesCollection.isHidden = false
            self.vedioImgV.isHidden = true
            self.btnPlayVedio.isHidden = true
            self.btnImages.backgroundColor = UIColor.lightSkyColor
            self.btnImages.setImage(UIImage(named: "insert-picture-icon")?.tinted(with: .black), for: .normal)
            
            self.btnVedio.backgroundColor = UIColor.darkSkyColor
            self.btnVedio.setImage(UIImage(named: "zoom")?.tinted(with: .white), for: .normal)
            
            
        }
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        let sharePath = "https://alhfta.com/show_ads/ads/\(details?.id ?? 0)"
        let message = "قد يهمك هذا الاعلان"
        if let name = URL(string: sharePath), !name.absoluteString.isEmpty {
            let objectsToShare = [message,name] as [Any]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
            AlertsManager.showAlert(withTitle: "خطأ", message: "حدث خطأ غي مشاركة الاعلان", viewController: self)
        }
        
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        if !UserInfo.getUserLogin(){
            AlertsManager.showAlert(withTitle: "عفوا", message: "هذه الميزة تحتاج تسجيل دخول ", viewController: self)
            return
        }
        showLoadingView()
        NetworkManager.shared.addFavorite(url: "add_favorites", addID: details?.id ) { response in
            self.removeLoadingView()
            switch response {
            case .success(let fav):
                DispatchQueue.main.async {
                    self.likeImg.image = self.likeImg.image?.tinted(with: .red)
                }
                AlertsManager.showAlert(withTitle: "تمت", message: "تمت اضافة الاعلان الى المفضلة بنجاح", viewController: self)
            case .failure(let error):
                //print(error)
                AlertsManager.showAlert(withTitle: "خطأ", message: error.localizedDescription, viewController: self)
            }
        }
    }
    @IBAction func rateBtnPressed(_ sender: Any) {
        if !UserInfo.getUserLogin(){
            AlertsManager.showAlert(withTitle: "عفوا", message: "هذه الميزة تحتاج تسجيل دخول ", viewController: self)
            return
        }
        if let _ = self.view.viewWithTag(222) {
            self.view.viewWithTag(222)?.removeFromSuperview()
        }
        isRate = true
        rateView.isHidden = !rateView.isHidden
        reportBtn.isHidden = true
        arrowDonOutlet.isHidden = true
        rateStarsView.isHidden = false
    }
    
    @IBAction func reportBtnPressed(_ sender: Any) {
        if !UserInfo.getUserLogin(){
            AlertsManager.showAlert(withTitle: "عفوا", message: "هذه الميزة تحتاج تسجيل دخول ", viewController: self)
            return
        }
        if let _ = self.view.viewWithTag(222) {
            self.view.viewWithTag(222)?.removeFromSuperview()
        }
        isRate = false
        rateView.isHidden = !rateView.isHidden
        reportBtn.isHidden = false
        arrowDonOutlet.isHidden = !arrowDonOutlet.isHidden
        rateStarsView.isHidden = true
        
    }
    
    @IBAction func playVedio(_ sender: Any) {
        guard let url = URL(string: details?.video ?? "") else {return}
        playVideo(url: url)
    }
    
    @IBAction func contactBtnPressed(_ sender: Any) {
        if !UserInfo.getUserLogin(){
            AlertsManager.showAlert(withTitle: "عفوا", message: "هذه الميزة تحتاج تسجيل دخول ", viewController: self)
            return
        }
        if !rateView.isHidden {rateView.isHidden = true}
        if let _ = self.view.viewWithTag(222) {
            self.view.viewWithTag(222)?.removeFromSuperview()
        }else{
            configureViewShare()
            configureShareStackView()
            configureBtns()
        }
    }
    
    @IBAction func reportReason(_ sender: UIButton) {
        
        var reasonsList:[String] {reasons.map(\.reason!)}
        dropDown.dataSource = reasonsList
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
        dropDown.direction = .bottom
        dropDown.show()
        dropDown.selectionAction = {[weak self] (index: Int , item: String) in
            guard let _ = self else {return}
            sender.setTitle(item, for: .normal)
            self?.reasonID = self?.reasons[index].id ?? 0
        }
    }
    
    
    @IBAction func sendRateAndReportButton(_ sender: Any) {
        if isRate {
            self.addRateToAdd()
        }else{
            self.reportAd()
        }
    }
    
    @IBAction func showCommentsBtn(_ sender: Any) {
        commentsBtn.backgroundColor = .link
        commentsBtn.setTitleColor(.white, for: .normal)
        reviewsBtn.backgroundColor = .lightSkyColor
        relatedAdsBtn.backgroundColor = .lightSkyColor
        reviewsBtn.setTitleColor(.black, for: .normal)
        relatedAdsBtn.setTitleColor(.black, for: .normal)
        commentTF.isHidden = false
        btnSendComment.isHidden = false
        changeCollectionStat(index: 2)
    }
    
    @IBAction func showReviewsBtn(_ sender: Any) {
        reviewsBtn.backgroundColor = .link
        reviewsBtn.setTitleColor(.white, for: .normal)
        commentsBtn.backgroundColor = .lightSkyColor
        relatedAdsBtn.backgroundColor = .lightSkyColor
        commentsBtn.setTitleColor(.black, for: .normal)
        relatedAdsBtn.setTitleColor(.black, for: .normal)
        commentTF.isHidden = true
        btnSendComment.isHidden = true
        changeCollectionStat(index: 1)
        
    }
    @IBAction func showRelatedAds(_ sender: Any) {
        relatedAdsBtn.backgroundColor = .link
        relatedAdsBtn.setTitleColor(.white, for: .normal)
        commentsBtn.backgroundColor = .lightSkyColor
        reviewsBtn.backgroundColor = .lightSkyColor
        commentsBtn.setTitleColor(.black, for: .normal)
        reviewsBtn.setTitleColor(.black, for: .normal)
        commentTF.isHidden = true
        btnSendComment.isHidden = true
        changeCollectionStat(index: 0)
    }
    
    
    @IBAction func sendCommentBtnPressed(_ sender: Any) {
        showLoadingView()
        if commentTF.text.count == 0 {
            AlertsManager.showAlert(withTitle: "تنبيه", message: "برجاء كتابة تعليق", viewController: self)
        }else{
            NetworkManager.shared.addCommentToAdd(url: "add_comment", chat_id: details?.id, comment: commentTF.text, parent_id: 0) { response in
                self.removeLoadingView()
                switch response {
                case .success(let add):
                    print(add)
                    AlertsManager.showAlert(withTitle: "تم بنجاح", message: "تم اضافة تعليقك بنجاح", viewController: self)
                case .failure(let error):
                    print(error)
                }
            }
        }
      
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewAddVC") as! AddNewAddVC
        vc.isEdit = true
        vc.details = self.details
        vc.imagess = self.images
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        AlertsManager.showAlert(withTitle: "هل انت متأكد من حذف هذا الاعلان؟", message: "سيتم حذف بيانات هذا الاعلان بالكامل", viewController:self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "نعم متأكد احذف", actionStyle: .default) { _ in
            let id = self.details?.id
            self.showLoadingView()
            NetworkManager.shared.fetchData(url: "delete_ads/\(id ?? 0)", decodable: AddGeneralComment.self) { response in
                self.removeLoadingView()
                switch response {
                case .success(let data):
                    print(data)
                    UserInfo.navigateToTabBarBYIndex(index: 0, vc: self)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    @IBAction func openAdsinCityLbl(_ sender: Any) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "AddsInCity") as! AddsInCity
        vc.cityID = details?.city?.id ?? 0
        vc.title = details?.city?.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openUserInfo(_ sender: Any) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsVC
        
        vc.userDetails = details?.user
        vc.title = details?.user?.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chooseTransactionFileBtn(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    
    
    @IBAction func sendTransactionInfo(_ sender: Any) {
        guard let image = self.selectedImage else {
            AlertsManager.showAlert(withTitle: "عفوا", message: "يرجى اختيار صورة الحوالة", viewController: self)
            return
        }
        
        self.payForAdd(File: image.jpegData(compressionQuality: 0.5) ?? Data(), url: "https://hvps.exdezign.com/api/send_transaction", transactionID: self.transactionNumberTF.text ?? "", WithName: "image", adsID: "\(self.details?.id ?? 0)") { data in
            //print(data)
            AlertsManager.showAlert(withTitle: "تم", message: data?.message, viewController: self)
        } isError: { error in
            print(error)
            AlertsManager.showAlert(withTitle: "معذرة", message: error, viewController: self)
        }

    }
    
    @IBAction func archiveAdd(_ sender: Any) {
        print("archive")
        AlertsManager.showAlert(withTitle: "تنبيه", message: "هل انت متاكد من ارشفة واخفاء الاعلان", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "ارشفة", actionStyle: .default) { _ in
            NetworkManager.shared.archiveAdd(url: "archive_ads/\(self.details?.id ?? 0)") { response in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {
                        AlertsManager.showAlert(withTitle: "تم", message: data.message, viewController: self, showingCancelButton: false, showingOkButton: true, cancelHandler: nil, actionTitle: "حسنا", actionStyle: .default) { ـ in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case .failure(let error):
                    AlertsManager.showAlert(withTitle: "معذرة", message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
}

extension adsDetailsVC:UITextViewDelegate, imageUpload {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentTF.textColor == UIColor.lightGray {
            commentTF.text = nil
            commentTF.textColor = UIColor.black
        }
        
        if productPriceTV.textColor == UIColor.lightGray {
            productPriceTV.text = nil
            productPriceTV.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTF.text.isEmpty {
            commentTF.text = "اكتب تعليقك"
            commentTF.textColor = UIColor.lightGray
        }
        
        if productPriceTV.textColor == UIColor.lightGray {
            productPriceTV.text = "ادخل سعر المنتج"
            productPriceTV.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == productPriceTV {
            let amount  = Double(productPriceTV.text) ?? 0
            let percent = UserInfo.appSettings?.data.commission ?? 1
            totalPriceLbl.text = "اجمالي عمولة السوق\(amount * Double(percent) / 100) ريال"
        }
    }
    
    func handleImageSelection(image: UIImage) {
        self.selectedImage = image
        self.selectionFileLbl.text = "تم اختيار ملف بنجاح"
    }
    
    func setImgID(id: Int) {
        
    }
    
    
    func payForAdd(File fileData: Data ,url:String,transactionID:String ,WithName fileName:String , adsID : String, isSucess : @escaping(PayTransaction?) -> Void , isError : @escaping (String) -> Void ){
        
        var urlComps = URLComponents(string: url)!
        let queryItems = [URLQueryItem(name: "transaction_id", value: transactionID),URLQueryItem(name: "ads_id", value: adsID)]
        urlComps.queryItems = queryItems

        let headers:HTTPHeaders = ["Authorization": "Bearer \(UserInfo.getUserToken())","Content-Type":"multipart/form-data","Accept":"application/json"]
    
        let result = urlComps.url!
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(fileData, withName: fileName, fileName: "\(fileName).jpg", mimeType: "image/jpg")
            multipartFormData.append(transactionID.data(using: .utf8) ?? Data(), withName: "transaction_id")
            multipartFormData.append(adsID.data(using: .utf8) ?? Data(), withName: "ads_id")
            
        }, to: result,method: .post, headers: headers).uploadProgress(closure: { (progress) in
            
           // AddLabDataSource.delegate?.updateProgressViewWith(fractions: progress.fractionCompleted)
            
        }) .responseDecodable { (response: DataResponse<PayTransaction, AFError>) in
            
            switch response.result {
                
            case .failure(let error):
                
                print(error)
                isError(error.localizedDescription)
                break
                
            case .success(let model):
                
                print(response.response!.statusCode)
                
                print(model.message ?? "")
                
                //   if model.success == true {
                
                print("-----------------")
                
                print(model.message ?? "Success")
                
                print("-----------------")
                
                isSucess(model)
                
                //                } else {
                //
                //                    print("Error loading attachment")
                //
                //                }
                
            }
        }
    }
}
