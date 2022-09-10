//
//  ProfileVC.swift
//  Haftaa
//
//  Created by Najeh on 03/07/2022.
//

import UIKit
import DropDown
enum TypeImageProfile {
    case profile
    case nationalID
    case commericalID
    case favor
    case workPermit
}

class ProfileVC: UITableViewController,imageUpload {
    
    var selectedImage:UIImage?
    var typeImageSelected:TypeImageProfile?
    var countries:[Country] = []
    var cities:[City] = []
    var dropDown = DropDown()
    var dropDown2 = DropDown()
    var countryID:Int?
    var cityID:Int?
    var profileImgID = 0,nationalImgID = 0,commericalImgID = 0,favorImgID = 0,workPermitImgID = 0
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var areaBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var callSwitch: UISwitch!
    @IBOutlet weak var whatsSwitch: UISwitch!
    @IBOutlet weak var nationalIDImgV: UIImageView!
    @IBOutlet weak var commericalID: UIImageView!
    @IBOutlet weak var favorImgV: UIImageView!
    @IBOutlet weak var workPermitImgV: UIImageView!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var essentialStack: UIStackView!
    @IBOutlet weak var verfySrtack: UIStackView!
    @IBOutlet weak var profileStack: UIStackView!
    
    @IBOutlet weak var essentialssBtnOutlet: UIButton!
    @IBOutlet weak var verifyBtnOutlet: UIButton!
    @IBOutlet weak var othersBtnOutlet: UIButton!
    @IBOutlet weak var segelMadaniTF: UITextField!
    
    @IBOutlet weak var btnAddCmmrical: UIButton!
    @IBOutlet weak var btnAddNationalID: UIButton!
    @IBOutlet weak var btnAddWorkPermit: UIButton!
    @IBOutlet weak var btnAddFavor: UIButton!
    
    @IBOutlet weak var star3: UILabel!
    @IBOutlet weak var stra2: UILabel!
    @IBOutlet weak var star1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserInfo.appSettings?.data.email ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserInfo.getUserLogin() {
            AttachmentHandler.shared.delegate = self
            NetworkManager.shared.delegate = self
            self.countries = UserInfo.countries ?? []
            getUserInfo()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        
        //        DispatchQueue.global().async {
        //            AttachmentHandler.shared.imagePickedBlock = { [weak self] (image) in
        //                guard let self = self else {return}
        //                self.selectedImage = image
        //                switch self.typeImageSelected {
        //                case .profile:
        //                    self.profileImg.image = self.selectedImage
        //                    self.uploadImage(image: image) { id in
        //                        self.profileImgID = id
        //
        //                    }
        //                case .nationalID:
        //                    self.nationalIDImgV.image = self.selectedImage
        //                    self.uploadImage(image: image) { id in
        //                        self.nationalImgID = id
        //                    }
        //                case .commericalID:
        //                    self.commericalID.image = self.selectedImage
        //                    self.uploadImage(image: image) { id in
        //                        self.commericalImgID = id
        //                    }
        //                case .favor:
        //                    self.favorImgV.image = self.selectedImage
        //                    self.uploadImage(image: image) { id in
        //                        self.favorImgID = id
        //                    }
        //                case .workPermit:
        //                    self.workPermitImgV.image = self.selectedImage
        //                    self.uploadImage(image: image) { id in
        //                        self.workPermitImgID = id
        //                    }
        //                default:
        //                    print("error")
        //
        //                }
        //
        //
        //            }
        //        }
    }
    
    func setImgID(id:Int){
        switch self.typeImageSelected {
        case .profile:
            self.profileImgID = id
        case .nationalID:
            self.nationalImgID = id
        case .commericalID:
            self.commericalImgID = id
        case .favor:
            self.favorImgID = id
        case .workPermit:
            self.workPermitImgID = id
        default:
            print("error")
            
        }
    }
    
    func handleImageSelection(image:UIImage){
        self.selectedImage = image
        switch self.typeImageSelected {
        case .profile:
            self.profileImg.image = self.selectedImage
            self.uploadImage(image: image)
        case .nationalID:
            self.nationalIDImgV.image = self.selectedImage
            self.uploadImage(image: image)
        case .commericalID:
            self.commericalID.image = self.selectedImage
            self.uploadImage(image: image)
        case .favor:
            self.favorImgV.image = self.selectedImage
            self.uploadImage(image: image)
        case .workPermit:
            self.workPermitImgV.image = self.selectedImage
            self.uploadImage(image: image)
        default:
            print("error")
            
        }
    }
    
    
    func uploadImage(image:UIImage){
        let imageData = image.jpegData(compressionQuality: 0.5)
        showLoadingView()
        NetworkManager.shared.uploadImage(url: "upload_file", fileData: imageData) { response in
            self.removeLoadingView()
            switch response {
            case .success(let fileData):
                print("ph \(fileData)")
                //self.setImgID(id: fileData.data?.id ?? 0)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setDatainView(data:LoginModel?){
        nameTF.text = data?.data?.userName ?? ""
        phoneTF.text = data?.data?.phone ?? ""
        countryBtn.setTitle(data?.data?.country?.name ?? "اختر دولة", for: .normal)
        areaBtn.setTitle(data?.data?.city?.name ?? "اختر المنطقة", for: .normal)
        emailTF.text = data?.data?.email ?? ""
        callSwitch.isOn = data?.data?.allowPhone == 1 ? true : false
        whatsSwitch.isOn = data?.data?.whatsapp == 1 ? true : false
        profileImg.setImage(with: data?.data?.photoPath ?? "")
        nationalIDImgV.setImage(with: data?.data?.nationalIdentityPath ?? "")
        commericalID.setImage(with: data?.data?.commercialRegisterPath ?? "")
        favorImgV.setImage(with: data?.data?.favourPath ?? "")
        workPermitImgV.setImage(with: data?.data?.workPermitPath ?? "")
        self.cities = data?.data?.country?.cities ?? []
        countryID = data?.data?.country?.id
        cityID = Int(data?.data?.city?.id ?? 0)
        profileImgID = Int(data?.data?.photoID ?? "") ?? 0
        nationalImgID = data?.data?.nationalIdentity ?? 0
        commericalImgID = data?.data?.commercialRegister ?? 0
        favorImgID = data?.data?.favour ?? 0
        workPermitImgID = data?.data?.workPermit ?? 0
        segelMadaniTF.text = data?.data?.sajalMadaniun ?? ""
        if data?.data?.trusted == 1 {
            verifyBtnOutlet.isHidden = true
        }
    }
    
    func getUserInfo(){
        showLoadingView()
        NetworkManager.shared.getUser(url: "get_user") { response in
            self.removeLoadingView()
            switch response{
            case .success(let user):
                self.setDatainView(data: user)
                print(user)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    @IBAction func imgBtnPressed(_ sender: Any) {
        typeImageSelected = .profile
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    
    @IBAction func addNationalID(_ sender: Any) {
        typeImageSelected = .nationalID
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
        
    }
    @IBAction func addFavor(_ sender: Any) {
        typeImageSelected = .favor
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    
    @IBAction func addCommerical(_ sender: Any) {
        typeImageSelected = .commericalID
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    
    @IBAction func addWorkPermit(_ sender: Any) {
        typeImageSelected = .workPermit
        AttachmentHandler.shared.showAttachmentActionSheetForImage(vc: self)
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        showLoadingView()
        NetworkManager.shared.updateProfile(url: "update_profile", name: nameTF.text, userName: nameTF.text, phoneNumber: phoneTF.text, country_id: "\(countryID ?? 1)", cityID: "\(cityID ?? 1)", email: emailTF.text, photoPath: "\(profileImgID)", password: passwordTF.text, nationalID: nationalImgID, commericalID: commericalImgID, favor: favorImgID, workPermit: workPermitImgID, segelMadani: segelMadaniTF.text, allowPhone: callSwitch.isOn ? 1 : 0, allowWhats: whatsSwitch.isOn ? 1 : 0) { response in
            self.removeLoadingView()
            switch response {
            case .success(let user):
                DispatchQueue.main.async {
                    self.setDatainView(data: user)
                }
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func countryBtnSelected(_ sender: UIButton) {
        var names:[String] {countries.map(\.name!)}
        var ids:[Int] {countries.map(\.id!)}
        dropDown.dataSource = names
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
        dropDown.direction = .bottom
        dropDown.show()
        dropDown.selectionAction = {[weak self] (index: Int , item: String) in
            guard let _ = self else {return}
            sender.setTitle(item, for: .normal)
            self?.countryID = self?.countries[index].id ?? 1
            self?.cities = self?.countries[index].cities ?? []
        }
        
    }
    @IBAction func areaBtnSelected(_ sender: UIButton) {
        dropDown2.dataSource = self.cities.map(\.name!)
        dropDown2.anchorView = sender
        dropDown2.bottomOffset = CGPoint(x: 0.0, y: sender.frame.size.height)
        dropDown2.direction = .bottom
        dropDown2.show()
        dropDown2.selectionAction = {[weak self] (index: Int , item: String) in
            guard let _ = self else {return}
            sender.setTitle(item, for: .normal)
            self?.cityID = self?.cities[index].id ?? 1
            
        }
        
    }
    
    @IBAction func essentialBtn(_ sender: Any) {
        
        essentialStack.isHidden = false
        verfySrtack.isHidden = true
        profileStack.isHidden = true
        
        essentialssBtnOutlet.backgroundColor = .lightSkyColor
        essentialssBtnOutlet.setTitleColor(.black, for: .normal)
        verifyBtnOutlet.backgroundColor = .link
        verifyBtnOutlet.setTitleColor(.white, for: .normal)
        othersBtnOutlet.backgroundColor = .link
        othersBtnOutlet.setTitleColor(.white, for: .normal)
        star1.isHidden = false
        star3.isHidden = false
        stra2.isHidden = false
        
    }
    
    @IBAction func verifyBtn(_ sender: Any) {
        
        essentialStack.isHidden = true
        verfySrtack.isHidden = false
        profileStack.isHidden = true
        verifyBtnOutlet.backgroundColor = .lightSkyColor
        verifyBtnOutlet.setTitleColor(.black, for: .normal)
        essentialssBtnOutlet.backgroundColor = .link
        essentialssBtnOutlet.setTitleColor(.white, for: .normal)
        othersBtnOutlet.backgroundColor = .link
        othersBtnOutlet.setTitleColor(.white, for: .normal)
        star1.isHidden = true
        star3.isHidden = true
        stra2.isHidden = true
        
        
    }
    @IBAction func otherBtn(_ sender: Any) {
        
        essentialStack.isHidden = true
        verfySrtack.isHidden = true
        profileStack.isHidden = false
        
        othersBtnOutlet.backgroundColor = .lightSkyColor
        othersBtnOutlet.setTitleColor(.black, for: .normal)
        essentialssBtnOutlet.backgroundColor = .link
        essentialssBtnOutlet.setTitleColor(.white, for: .normal)
        verifyBtnOutlet.backgroundColor = .link
        verifyBtnOutlet.setTitleColor(.white, for: .normal)
        star1.isHidden = true
        star3.isHidden = true
        stra2.isHidden = true
        
        
    }
}
