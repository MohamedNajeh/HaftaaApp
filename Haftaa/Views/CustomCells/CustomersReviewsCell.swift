//
//  CustomersReviewsCell.swift
//  Haftaa
//
//  Created by Najeh on 01/08/2022.
//

import UIKit

class CustomersReviewsCell: UICollectionViewCell {

    @IBOutlet weak var noReviewsLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var details:AddsDetails? {
        didSet {
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ReviewsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ReviewsCollectionCell")
        // Initialization code
    }

}

extension CustomersReviewsCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if details?.reviewAds?.count == 0 {
            noReviewsLbl.isHidden = false
        }else{
            noReviewsLbl.isHidden = true
        }
        return details?.reviewAds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionCell", for: indexPath) as! ReviewsCollectionCell
        //cell.userIcon.setImage(with: details?.reviewAds)
        cell.userLbl.text = details?.reviewAds?[indexPath.row].user?.name
        cell.reviewTV.text = details?.reviewAds?[indexPath.row].reviewAdDescription
        cell.ratingView.rating = Double(details?.reviewAds?[indexPath.row].rate ?? 0)
        cell.timeLbl.text = details?.reviewAds?[indexPath.row].date

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150.0)
    }
}
