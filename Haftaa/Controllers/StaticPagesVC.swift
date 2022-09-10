//
//  StaticPagesVC.swift
//  Haftaa
//
//  Created by Najeh on 07/08/2022.
//

import UIKit

class StaticPagesVC: UIViewController,UISheetPresentationControllerDelegate {

    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    @IBOutlet weak var tableView: UITableView!
    var pages:[Page] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSheet()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        // Do any additional setup after loading the view.
    }
    
    func configureSheet(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [.medium(),.large()]
    }
}

extension StaticPagesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.titleLbl.text = pages[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "StaticPageDetails") as! StaticPageDetails
        vc.desc = pages[indexPath.row].pageDescription
        self.present(vc, animated: true, completion: nil)
    }
}
