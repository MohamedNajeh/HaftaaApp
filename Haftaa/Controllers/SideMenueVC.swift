//
//  SideMenueVC.swift
//  Haftaa
//
//  Created by Najeh on 01/05/2022.
//

import UIKit
import SideMenu
struct SideMenuModel {
    var icon: UIImage
    var title: String
}

class SideMenueVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "الرئيسية"),
        SideMenuModel(icon: UIImage(systemName: "music.note")!, title: "بحث متقدم"),
        SideMenuModel(icon: UIImage(systemName: "film.fill")!, title: "من نحن ؟"),
        SideMenuModel(icon: UIImage(systemName: "book.fill")!, title: "سياسة الخصوصية"),
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "الأسئلة الشائعة"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideCell")
    }

}

extension SideMenueVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideCell", for: indexPath) as! SideMenuCell
        cell.imgV.image = menu[indexPath.row].icon
        cell.titleLbl.text = menu[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let menu = SideMenuNavigationController(rootViewController: DetailsVC())
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        self.present(vc, animated: true, completion: nil)
    }
    
   
    
    
}
