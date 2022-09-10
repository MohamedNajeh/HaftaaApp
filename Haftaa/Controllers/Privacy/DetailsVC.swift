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
        fetchPolicy()
        // Do any additional setup after loading the view.
    }
    
    
    func configureSheet(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [.medium(),.large()]
    }
    
    func fetchPolicy(){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "get_privacies", decodable: Policy.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let privacy):
                print(privacy.data.privacyPolicy)
                DispatchQueue.main.async {
                    //self.textView.text = privacy.data.privacyPolicy
                    self.textView.attributedText = privacy.data.privacyPolicy.htmlToAttributedString
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    

}
