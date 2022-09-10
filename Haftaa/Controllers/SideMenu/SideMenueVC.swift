//
//  SideMenueVC.swift
//  Haftaa
//
//  Created by Najeh on 01/05/2022.
//

import UIKit
import SideMenu
import DropDown
struct SideMenuModel {
    var icon: UIImage
    var title: String
}


class SideMenueVC: UIViewController{
  
    

    

    @IBOutlet weak var userNameLblOutlet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    var isLogin = false
    var dropDown = DropDown()
    var pages:[staicData] = []
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "الرئيسية"),
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "حسابي"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "المفضلة"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title:"اعلاناتي"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "المناقشات"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "مراسلة الادارة"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "بحث متقدم"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "القسم الاول"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "سياسة الخصوصية"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "الأسئلة الشائعة"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "تواصل معنا"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "تسجيل الخروج"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "حذف الحساب")
    ]
    
    var menu2: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "الرئيسية"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "بحث متقدم"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "القسم الاول"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title:"سياسة الخصوصية"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "الأسئلة الشائعة"),
        SideMenuModel(icon: UIImage(systemName: "arrow.right")!, title: "تواصل معنا")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        getStaticPages()
        isLogin = UserInfo.getUserLogin()
        if isLogin {
            userNameLblOutlet.text = UserInfo.getUserNAme()
            loginBtn.isHidden = true
        }else{
            userNameLblOutlet.text = "اسم العضو"
            loginBtn.isHidden = false
        }

        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideCell")
    }
    
    func openTwitter(){
        let screenName =  "saud05007s"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    func openSnap(){
        let username = "saud05005"
        let appURL = URL(string: "snapchat://add/\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)

        } else {
            // if Snapchat app is not installed, open URL inside Safari
            let webURL = URL(string: "https://www.snapchat.com/add/\(username)")!
            application.open(webURL)

        }
    }
    
    func openMa3rof(){
        let webURL = URL(string: "https://maroof.sa/139125")!
        UIApplication.shared.open(webURL)
    }
    
    func logOut(){
        showLoadingView()
        NetworkManager.shared.logOut(url: "logout") { response in
            self.removeLoadingView()
            switch response {
            case .success(_):
                print("logedOut")
                UserInfo.logOut()
                UserInfo.navigateToTabBarBYIndex(index: 0, vc: self)
                NotificationCenter.default.post(name: .init("hideChatAndNotification"), object: nil )
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getStaticPages(){
        NetworkManager.shared.fetchData(url: "get_static_page", decodable: StaicPages.self) { response in
            switch response {
            case .success(let sucess):
                print(sucess)
                self.pages = sucess.data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAccount(){
        NetworkManager.shared.fetchData(url: "delete_account", decodable: LogOut.self) { response in
            switch response {
            case .success(let model):
                print(model)
                UserInfo.logOut()
                UserInfo.navigateToTabBarBYIndex(index: 0, vc: self)
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func ttterBtnPressed(_ sender: Any) {
        openTwitter()
    }
    
    @IBAction func snapBtnPressed(_ sender: Any) {
        openSnap()
    }
    
    @IBAction func m3rofBtnPressed(_ sender: Any) {
        openMa3rof()
    }
}

extension SideMenueVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLogin{
            return menu2.count
        }
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideCell", for: indexPath) as! SideMenuCell
        if !isLogin{
            cell.imgV.image = menu2[indexPath.row].icon
            cell.titleLbl.text = menu2[indexPath.row].title
            return cell

        }
        cell.imgV.image = menu[indexPath.row].icon
        cell.titleLbl.text = menu[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let menu = SideMenuNavigationController(rootViewController: DetailsVC())
        if !isLogin {
            switch indexPath.row {
            case 0:
                UserInfo.navigateToTabBarBYIndex(index: 0,vc: self)
            case 1:
                print("1")
                NotificationCenter.default.post(name: .init("enableAdvancedSearch"), object: nil )
                UserInfo.navigateToTabBarBYIndex(index: 0,vc: self)
            case 2:
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                guard let currentCell = tableView.cellForRow(at: indexPath) else { return }
               // var dataSource = self.pages.map {\}
                var pagess:[String] {pages.map(\.name)}
                //dataSource.append("التوثيق والباقات")
                dropDown.dataSource = pagess
                dropDown.anchorView = currentCell
                dropDown.bottomOffset = CGPoint(x: 0.0, y: currentCell.frame.size.height)
                dropDown.direction = .bottom
                dropDown.show()
                dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                    cell.optionLabel.textAlignment = .right
                }
                dropDown.selectionAction = {[weak self] (index: Int , item: String) in
                    guard let _ = self else {return}
                    print("selected")
                    let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "StaticPagesVC") as! StaticPagesVC
                    vc.pages = self?.pages[index].page ?? []
                    self?.present(vc, animated: true, completion: nil)
                }
            case 3:
                print("3")
                let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
                self.present(vc, animated: true, completion: nil)
            case 4:
                print("4")
                let vc = storyboard?.instantiateViewController(withIdentifier: "CommonQuestionsVC") as! CommonQuestionsVC
                self.present(vc, animated: true, completion: nil)
            case 5:
                print("")
                let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("0")
            }
        }else{
            switch indexPath.row {
            case 0:
                print("0")
                UserInfo.navigateToTabBarBYIndex(index: 0,vc: self)
            case 1:
                UserInfo.navigateToTabBarBYIndex(index: 1, vc: self)
            case 2:
                print("2")
                let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "FavoritesVC") as! FavoritesVC
                vc.title = "المفضلة"
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "MyAdsVC") as! MyAdsVC
                vc.title = "اعلاناتي"
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                UserInfo.navigateToTabBarBYIndex(index: 3, vc: self)
            case 5:
                let vc = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                vc.id = 0
                vc.title = "الإدارة"
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:
                NotificationCenter.default.post(name: .init("enableAdvancedSearch"), object: nil )
                UserInfo.navigateToTabBarBYIndex(index: 0,vc: self)
            case 7:
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                guard let currentCell = tableView.cellForRow(at: indexPath) else { return }
               // var dataSource = self.pages.map {\}
                var pagess:[String] {pages.map(\.name)}
                //dataSource.append("التوثيق والباقات")
                dropDown.dataSource = pagess
                dropDown.anchorView = currentCell
                dropDown.bottomOffset = CGPoint(x: 0.0, y: currentCell.frame.size.height)
                dropDown.direction = .bottom
                dropDown.show()
                dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                    cell.optionLabel.textAlignment = .right
                }
                dropDown.selectionAction = {[weak self] (index: Int , item: String) in
                    guard let _ = self else {return}
                    print("selected")
                    let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "StaticPagesVC") as! StaticPagesVC
                    vc.pages = self?.pages[index].page ?? []
                    self?.present(vc, animated: true, completion: nil)
                }
            case 9:
                let vc = storyboard?.instantiateViewController(withIdentifier: "CommonQuestionsVC") as! CommonQuestionsVC
                self.present(vc, animated: true, completion: nil)
            case 10:
                let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                self.navigationController?.pushViewController(vc, animated: true)
            case 11:
                print("logOut")
                AlertsManager.showAlert(withTitle: "تنبيه", message: "هل انت متاكد من تسجيل الخروج", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "خروج", actionStyle: .default) { _ in
                    self.logOut()
                }
            case 12:
                print("deleteAccount")
                AlertsManager.showAlert(withTitle: "تنبيه", message: "هل انت متاكد من حذف الحساب نهائيا", viewController: self, showingCancelButton: true, showingOkButton: true, cancelHandler: nil, actionTitle: "حذف الحساب", actionStyle: .default) { _ in
                    self.deleteAccount()
                }
            default:
                let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
   
    
    
}
