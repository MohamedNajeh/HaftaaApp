//
//  AddNewAddVC.swift
//  Haftaa
//
//  Created by Najeh on 14/05/2022.
//

import UIKit
import DropDown
import MapKit
import AssetsPickerViewController
import Photos
import BSImagePicker
import CoreLocation
import GoogleMaps

enum TypeImage {
    case img1
    case img2
    case img3
    case img4
    case img5
    case img6
}

class AddNewAddVC: UITableViewController {

    
    let dropDown = DropDown()
    var selectedButton = UIButton()
    var dataSource = [String]()
    var allContries:[Country] = []
    var cities:[City] = []
    var areas:[CityElement] = []
    var adsTypes = ["طلب","عرض"]
    var adTypeString = ""
    var tableHeight = 0
    let transparentView = UIView()
    var indexx = 0
    var images:[UIImage]?
    var SelectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
    var imagesIDs:[Int] = []
    let locationManager = CLLocationManager()
    var countryID = 0,cityID = 0,typeID = 0,videoID = 0,areaID = 0
    var accept = false , acceptTitle = false
    var selectedImage:UIImage?
    var type:TypeImage?
    var isEdit = false
    var details:AddsDetails?
    var imagess:[Image]?
    var img1ID = 0 , img2ID = 0,img3ID = 0,img4ID = 0,img5ID = 0,img6ID = 0
    var timer:Timer!
    var progress:Float = 0.0

    @IBOutlet weak var countryLbl: UIButton!
    @IBOutlet weak var cityLbl: UIButton!
    @IBOutlet weak var areaBtnLbl: UIButton!
    @IBOutlet weak var adsType: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var videoImgV: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var detailsTF: UITextField!
    @IBOutlet weak var allowCallSwitch: UISwitch!
    @IBOutlet weak var allowCommentsSwitch: UISwitch!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var acceptTitleBtn: UIButton!
    @IBOutlet weak var lblAgrrement: UILabel!
    
    
    @IBOutlet weak var imgV1: UIImageView!
    @IBOutlet weak var imgV2: UIImageView!
    @IBOutlet weak var imgV3: UIImageView!
    @IBOutlet weak var imgV4: UIImageView!
    @IBOutlet weak var imgV5: UIImageView!
    @IBOutlet weak var imgV6: UIImageView!
    @IBOutlet weak var btnImg1delete: UIButton!
    @IBOutlet weak var btnImage2Delete: UIButton!
    @IBOutlet weak var btnImage3delete: UIButton!
    @IBOutlet weak var btnImage4delete: UIButton!
    @IBOutlet weak var btnImg5delete: UIButton!
    @IBOutlet weak var btnimage6delete: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit {
            setDataInFields()
        }
        
       // configureDropDownTV()
        allContries = UserInfo.countries ?? []
        let color:UIColor = UIColor(red: 32/255, green: 187/255, blue: 255/255, alpha: 1)
        configureNavigationBar(largeTitleColor: color, backgoundColor: color, tintColor: .white, title: "", preferredLargeTitle: false)
        imagesCollectionView.register(UINib(nibName: "adImagesCell", bundle: nil), forCellWithReuseIdentifier: "adImagesCell")
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        lblAgrrement.attributedText = UserInfo.appSettings?.data.section.htmlToAttributedString
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AttachmentHandler.shared.delegate = self
        if UserInfo.getUserLogin() {
           // countryLbl.setTitle(UserInfo.getUserCountry(), for: .normal)
            //cityLbl.setTitle(UserInfo.getUserCity(), for: .normal)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
       
    }
    
    @objc func updateProgress(){
        progress += 0.1/2
        progressView.progress = progress
    }
    
    func setDataInFields(){
        titleTF.text = details?.title
        detailsTF.text = details?.detail
        countryLbl.setTitle(details?.country?.name, for: .normal)
        cityLbl.setTitle(details?.city?.name, for: .normal)
        adsType.setTitle(details?.adsType, for: .normal)
        adTypeString = details?.adsType ?? ""
        allowCallSwitch.isOn = details?.user?.allowPhone == 1 ? true : false
        allowCallSwitch.isOn = details?.commentAllow == 1 ? true : false
        if imagess?.count ?? 0 > 0 {
            imgV1.setImage(with: imagess?[0].image ?? "")
            imagesIDs.append(Int(imagess?[0].id ?? "") ?? 0)
            img1ID = Int(imagess?[0].id ?? "") ?? 0
            btnImg1delete.isHidden = false
        }
        if imagess?.count ?? 0 > 1 {
            imgV2.setImage(with: imagess?[1].image ?? "")
            imagesIDs.append(Int(imagess?[1].id ?? "") ?? 0)
            img2ID = Int(imagess?[1].id ?? "") ?? 0
            btnImage2Delete.isHidden = false
        }
        if imagess?.count ?? 0 > 2 {
            imgV3.setImage(with: imagess?[2].image ?? "")
            imagesIDs.append(Int(imagess?[2].id ?? "") ?? 0)
            img3ID = Int(imagess?[2].id ?? "") ?? 0
            btnImage3delete.isHidden = false
        }
        if imagess?.count ?? 0 > 3 {
            imgV4.setImage(with: imagess?[3].image ?? "")
            imagesIDs.append(Int(imagess?[3].id ?? "") ?? 0)
            img4ID = Int(imagess?[3].id ?? "") ?? 0
            btnImage4delete.isHidden = false
        }
        if imagess?.count ?? 0 > 4 {
            imgV5.setImage(with: imagess?[4].image ?? "")
            imagesIDs.append(Int(imagess?[4].id ?? "") ?? 0)
            img5ID = Int(imagess?[4].id ?? "") ?? 0
            btnImg5delete.isHidden = false
        }
        if imagess?.count ?? 0 > 5 {
            imgV6.setImage(with: imagess?[5].image ?? "")
            imagesIDs.append(Int(imagess?[5].id ?? "") ?? 0)
            img6ID = Int(imagess?[5].id ?? "") ?? 0
            btnimage6delete.isHidden = false
        }
        
//        imgV2.setImage(with: imagess?[1].image ?? "")
//        imgV3.setImage(with: imagess?[2].image ?? "")
//        imgV4.setImage(with: imagess?[3].image ?? "")
//        imgV5.setImage(with: imagess?[4].image ?? "")
//        imgV6.setImage(with: imagess?[5].image ?? "")
        
    }
    
    func clearViewContent(){
        titleTF.text = ""
        detailsTF.text = ""
        countryLbl.setTitle("اختر دولة", for: .normal)
        cityLbl.setTitle("اختر منطقة", for: .normal)
        adsType.setTitle("نوع العرض", for: .normal)
        allowCallSwitch.isOn = false
        allowCommentsSwitch.isOn = false
        photoArray = [UIImage]()
        imagesIDs = [Int]()
        videoID = 0
        accept = false
        acceptTitle = false
        imagesCollectionView.reloadData()
        imgV1.image = UIImage(named: "add-image")
        imgV2.image = UIImage(named: "add-image")
        imgV3.image = UIImage(named: "add-image")
        imgV4.image = UIImage(named: "add-image")
        imgV5.image = UIImage(named: "add-image")
        imgV6.image = UIImage(named: "add-image")
    }
    
    @IBAction func cntryBtnPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            var names:[String] {allContries.map(\.name!)}
            dropDown.dataSource = names
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
            dropDown.direction = .bottom
            dropDown.show()
            dropDown.selectionAction = {[weak self] (index: Int , item: String) in
                guard let _ = self else {return}
                sender.setTitle(item, for: .normal)
                self?.indexx = index
                self?.cities = self?.allContries[index].cities ?? []
                self?.countryID = self?.allContries[index].id ?? 0
            }
        }else if sender.tag == 2 {
            //var cities:[CityElement] = allContries[indexx].cities!
            var names:[String] {cities.map(\.name!)}
            if names.count == 0 {
                AlertsManager.showAlert(withTitle: "معذرة", message: "الرجاء اختيار الدولة اولا", viewController: self)
            }
            dropDown.dataSource = names
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
            dropDown.direction = .bottom
            dropDown.show()
            dropDown.selectionAction = {[weak self] (index: Int , item: String) in
                guard let _ = self else {return}
                sender.setTitle(item, for: .normal)
                self?.cityID = self?.cities[index].id ?? 0
                self?.areas = self?.cities[index].areas ?? []
            }
        }else if sender.tag == 3 {
            dropDown.dataSource = ["طلب","عرض"]
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
            dropDown.direction = .bottom
            dropDown.show()
            dropDown.selectionAction = {[weak self] (index: Int , item: String) in
                guard let _ = self else {return}
                sender.setTitle(item, for: .normal)
                self?.adTypeString = item
                
            }
        }else if sender.tag == 4 {
            var types:[String] {UserInfo.allTypes.map(\.name!)}
            dropDown.dataSource = types
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
            dropDown.direction = .bottom
            dropDown.show()
            dropDown.selectionAction = {[weak self] (index: Int , item: String) in
                guard let _ = self else {return}
                sender.setTitle(item, for: .normal)
                self?.typeID = UserInfo.allTypes[index].id ?? 0
            }
        }else if sender.tag == 5 {
            var areas:[String] {self.areas.map(\.name!)}
            if areas.count == 0 {
                AlertsManager.showAlert(withTitle: "معذرة", message: "الرجاء اختيار المنطقة اولا", viewController: self)
            }
            dropDown.dataSource = areas
            dropDown.anchorView = sender
            dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
            dropDown.direction = .bottom
            dropDown.show()
            dropDown.selectionAction = {[weak self] (index: Int , item: String) in
                guard let _ = self else {return}
                sender.setTitle(item, for: .normal)
                self?.areaID = self?.areas[index].id ?? 0
            }
        }
    }
    
    func uploadImages(image:Data){
        NetworkManager.shared.uploadImage(url: "upload_file", fileData: image) { response in
            switch response {
            case .success(let file):
                DispatchQueue.main.async {
                    self.imagesIDs.append(file.data?.id ?? 1)
                    switch self.type {
                    case .img1:
                        self.img1ID = file.data?.id ?? 1
                    case .img2:
                        self.img2ID = file.data?.id ?? 1
                    case .img3:
                        self.img3ID = file.data?.id ?? 1
                    case .img4:
                        self.img4ID = file.data?.id ?? 1
                    case .img5:
                        self.img5ID = file.data?.id ?? 1
                    case .img6:
                        self.img6ID = file.data?.id ?? 1
                    default:
                        print("none")
                    }
                    //self.imagesCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func convertToImageAndUpload(asset:PHAsset) -> UIImage{
        var img = UIImage()
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
            // Do something with image
            img = image!
        }
        return img
    }
    
    func setVedioImage(video:String) -> UIImage{
        guard let url = URL(string: video ) else {
            return UIImage()
        }
        var imagee = UIImage()
        AVAsset(url: url).generateThumbnail { (image) in
            guard let image = image else {
                return
            }
            imagee = image
        }
        return imagee
    }
    
    @IBAction func imgV1Action(_ sender: Any) {
        type = .img1
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
        //btnImg1delete.isHidden = false
        //self.uploadImages(image: self.convertToImageAndUpload(asset: i).jpegData(compressionQuality: 0.5)!)
        //photoArray.append(self.convertToImageAndUpload(asset: i))
    }
    @IBAction func imgV2Action(_ sender: Any) {
        type = .img2
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    @IBAction func imgV3Action(_ sender: Any) {
        type = .img3
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    @IBAction func imgV4Action(_ sender: Any) {
        type = .img4
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    @IBAction func imgV5Action(_ sender: Any) {
        type = .img5
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    @IBAction func imgV6Action(_ sender: Any) {
        type = .img6
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    
    @IBAction func vedioOpen(_ sender: Any) {
        AttachmentHandler.shared.videoDelegate = self
        AttachmentHandler.shared.authorisationStatus(attachmentTypeEnum: .video, vc: self)
    }
    
    @IBAction func imagesBtn(_ sender: Any) {
//        let picker = AssetsPickerViewController()
//        picker.pickerDelegate = self
//        picker.pickerConfig.assetsMaximumSelectionCount = 10
//        present(picker, animated: true, completion: nil)
        
        let imagePicker = ImagePickerController()

        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            // User finished selection assets.
            for i in assets {
                self.uploadImages(image: self.convertToImageAndUpload(asset: i).jpegData(compressionQuality: 1.0)!)
                self.photoArray.append(self.convertToImageAndUpload(asset: i))
            }
        })
    }
    @IBAction func openMap(_ sender: Any) {
       // mapView.isHidden = !mapView.isHidden
    }
    
    @IBAction func addNewAdd(_ sender: Any) {
        
        if isEdit {
            NetworkManager.shared.updateAdd(url: "update_ads/\(details?.id ?? 0)", adsType: adTypeString, title: titleTF.text, detail: detailsTF.text, country_id:countryID, city_id: cityID, area_id: self.areaID, phoneAllow: allowCallSwitch.isOn ? 1 : 0, video: videoID, commentAllow: allowCommentsSwitch.isOn ? 1: 0, photos: imagesIDs, category_id: typeID, lat: UserInfo.userLat, lng: UserInfo.userLng, accpet: accept ? 1 : 0, accept_title: acceptTitle ? "1" : "0") { response in
                switch response {
                case .success(let add):
                    print(add)
                    AlertsManager.showAlert(withTitle: "تم التعديل", message: add.message, viewController: self)
                    UserInfo.navigateToTabBarBYIndex(index: 0, vc: self)
                case .failure(let error):
                    print(error)
                    AlertsManager.showAlert(withTitle: "معذرة", message: error.localizedDescription, viewController: self)
                }
            }
        }else{
            NetworkManager.shared.addNewAdd(url: "add_ads", adsType: adTypeString, title: titleTF.text, detail: detailsTF.text, country_id:countryID, city_id: cityID, area_id: self.areaID, phoneAllow: allowCallSwitch.isOn ? 1 : 0, video: videoID, commentAllow: allowCommentsSwitch.isOn ? 1: 0, photos: imagesIDs, category_id: typeID, lat: UserInfo.userLat, lng: UserInfo.userLng, accpet: accept ? 1 : 0, accept_title: acceptTitle ? "1" : "0") { response in
                switch response {
                case .success(let add):
                    print(add)
                    self.clearViewContent()
                    AlertsManager.showAlert(withTitle: "تمت الاضافة", message: add.message, viewController: self)
                case .failure(let error):
                    print(error)
                    AlertsManager.showAlert(withTitle: "معذرة", message: error.localizedDescription, viewController: self)
                }
            }
        }
        
    }
    
    @IBAction func acceptBtnPressed(_ sender: Any) {
        accept = !accept
        if accept {
            acceptBtn.setImage(UIImage(named: "check-box"), for: .normal)
        }else{
            acceptBtn.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    @IBAction func acceptTitleBtnPressed(_ sender: Any) {
        acceptTitle = !acceptTitle
        if acceptTitle {
            acceptTitleBtn.setImage(UIImage(named: "check-box"), for: .normal)
        }else{
            acceptTitleBtn.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    @IBAction func deleteImgV1(_ sender: Any) {
        AlertsManager.showAlert(withTitle: "هل تريد حذف الصورة", message: "سيتم حذف الصورة نهائيا", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "حذف", actionStyle: .default) { _ in
            self.imgV1.image = UIImage(named: "add-image")
            self.btnImg1delete.isHidden = true
            self.imagesIDs = self.imagesIDs.filter {$0 != self.img1ID}
        }
    }
    
    @IBAction func deleteImgV2(_ sender: Any) {
        AlertsManager.showAlert(withTitle: "هل تريد حذف الصورة", message: "سيتم حذف الصورة نهائيا", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "حذف", actionStyle: .default) { _ in
            self.imgV2.image = UIImage(named: "add-image")
            self.btnImage2Delete.isHidden = true
            self.imagesIDs = self.imagesIDs.filter {$0 != self.img2ID}
        }
    }
    @IBAction func deleteImgV3(_ sender: Any) {
        AlertsManager.showAlert(withTitle: "هل تريد حذف الصورة", message: "سيتم حذف الصورة نهائيا", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "حذف", actionStyle: .default) { _ in
            self.imgV3.image = UIImage(named: "add-image")
            self.btnImage3delete.isHidden = true
            self.imagesIDs = self.imagesIDs.filter {$0 != self.img3ID}
        }
    }
    
    @IBAction func deleteImgV4(_ sender: Any) {
        AlertsManager.showAlert(withTitle: "هل تريد حذف الصورة", message: "سيتم حذف الصورة نهائيا", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "حذف", actionStyle: .default) { _ in
            self.imgV4.image = UIImage(named: "add-image")
            self.btnImage4delete.isHidden = true
            self.imagesIDs = self.imagesIDs.filter {$0 != self.img4ID}
        }
    }
    
    @IBAction func deleteImgV5(_ sender: Any) {
        AlertsManager.showAlert(withTitle: "هل تريد حذف الصورة", message: "سيتم حذف الصورة نهائيا", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "حذف", actionStyle: .default) { _ in
            self.imgV5.image = UIImage(named: "add-image")
            self.btnImg5delete.isHidden = true
            self.imagesIDs = self.imagesIDs.filter {$0 != self.img5ID}
        }
    }
    @IBAction func deleteImgV6(_ sender: Any) {
        AlertsManager.showAlert(withTitle: "هل تريد حذف الصورة", message: "سيتم حذف الصورة نهائيا", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "حذف", actionStyle: .default) { _ in
            self.imgV6.image = UIImage(named: "add-image")
            self.btnimage6delete.isHidden = true
            self.imagesIDs = self.imagesIDs.filter {$0 != self.img6ID}
        }
    }
}

extension AddNewAddVC:vedioUpload,AssetsPickerViewControllerDelegate,GMSMapViewDelegate,imageUpload{
    func handleImageSelection(image: UIImage) {
        self.selectedImage = image
        let imageUp = image.jpegData(compressionQuality: 0.5)
        switch self.type {
        case .img1:
            self.imgV1.image = self.selectedImage
            self.uploadImages(image: imageUp!)
            self.btnImg1delete.isHidden = false
        case .img2:
            self.imgV2.image = self.selectedImage
            self.uploadImages(image: imageUp!)
            btnImage2Delete.isHidden = false
        case .img3:
            self.imgV3.image = self.selectedImage
            self.uploadImages(image: imageUp!)
            btnImage3delete.isHidden = false
        case .img4:
            self.imgV4.image = self.selectedImage
            self.uploadImages(image: imageUp!)
            btnImage4delete.isHidden = false
        case .img5:
            self.imgV5.image = self.selectedImage
            self.uploadImages(image: imageUp!)
            btnImg5delete.isHidden = false
        case .img6:
            self.imgV6.image = self.selectedImage
            self.uploadImages(image: imageUp!)
            btnimage6delete.isHidden = false
        default:
            print("error")
            
        }
    }
    
    func setImgID(id: Int) {
        
    }
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {}
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
        for i in assets {
            
            self.uploadImages(image: self.convertToImageAndUpload(asset: i).jpegData(compressionQuality: 0.5)!)
            photoArray.append(self.convertToImageAndUpload(asset: i))
        }
        
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {}
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
    func handleVedioSelection(vedio: Data) {
        showLoadingView()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        NetworkManager.shared.uploadVedio(url: "upload_file", fileData: vedio) { response in
            self.removeLoadingView()
            self.progressView.progress = 1.0
            self.timer.invalidate()
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                self.progressView.progress = 0.0
            }
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    AlertsManager.showAlert(withTitle: "تم", message: "تم رفع الفيديو بنجاح", viewController: self)
                    self.videoImgV.image =  UIImage(named: "DoneMArk")
                    self.videoID = data.data?.id ?? 0
                }
                print(data)
            case .failure(let error):
                print(error)
                AlertsManager.showAlert(withTitle: "خطأ", message: "خطأ في رفع الفيديو", viewController: self)
            }
        }
    }
    
    func setVedioID(id: Int) {
        
    }
    
    
 
    
    
    
}

