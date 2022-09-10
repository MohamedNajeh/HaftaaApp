//
//  LoginVC.swift
//  Haftaa
//
//  Created by Najeh on 05/05/2022.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var registrationStepsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionHieghtConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollevtion()
        // Do any additional setup after loading the view.
    }
    
    func navigateToTabBarBYIndex(index : Int) {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        let tabBarController = keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = index
        self.dismiss(animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: false)
        })
    }
    
    func configureCollevtion(){
        registrationStepsCollectionView.delegate = self
        registrationStepsCollectionView.dataSource = self
        registrationStepsCollectionView.register(UINib(nibName: "LoginCell", bundle: nil), forCellWithReuseIdentifier: "LoginCell")
        registrationStepsCollectionView.register(UINib(nibName: "RegisterCell", bundle: nil), forCellWithReuseIdentifier: "RegisterCell")
        registrationStepsCollectionView.register(UINib(nibName: "ResetPasswordCell", bundle: nil), forCellWithReuseIdentifier: "ResetPasswordCell")
        registrationStepsCollectionView.register(UINib(nibName: "verficationCodeCell", bundle: nil), forCellWithReuseIdentifier: "verficationCodeCell")
        registrationStepsCollectionView.register(UINib(nibName: "NewPasswordCell", bundle: nil), forCellWithReuseIdentifier: "NewPasswordCell")
    }
    
    func configureVC(){
        containerView.layer.cornerRadius = 15
    }
    

    @IBAction func dismissBtnPressed(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true)
        self.navigateToTabBarBYIndex(index: 0)
    }

}
extension LoginVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoginCell", for: indexPath) as?  LoginCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterCell", for: indexPath) as?  RegisterCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResetPasswordCell", for: indexPath) as?  ResetPasswordCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "verficationCodeCell", for: indexPath) as?  verficationCodeCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewPasswordCell", for: indexPath) as?  NewPasswordCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = registrationStepsCollectionView.frame.width
        var collectionViewHeight = registrationStepsCollectionView.frame.height
        if indexPath.row == 1 {
            collectionViewHeight = 500
        }else{}
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }

    
    
}
