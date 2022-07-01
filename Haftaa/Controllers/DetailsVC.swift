//
//  DetailsVC.swift
//  Haftaa
//
//  Created by Najeh on 03/05/2022.
//

import UIKit

class DetailsVC: UIViewController,UISheetPresentationControllerDelegate {
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSheet()
//        fetchPolicy()
        // Do any additional setup after loading the view.
    }
    
    init(des:String){
        
        self.textView.text = des
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSheet(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [.medium(),.large()]
    }
    
//    func fetchPolicy(){
//        NetworkManager.shared.fetchPrivacyPolicy(url: "https://hvps.exdezign.com/api/get_privacies") { response in
//            switch response {
//            case .success(let privacy):
//                print(privacy.data.privacyPolicy)
//                DispatchQueue.main.async {
//                    self.textView.text = privacy.data.privacyPolicy
//                }
//            case .failure(let error):
//                print(error)
//            }
//            
//        }
//    }
    

}
