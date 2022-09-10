//
//  RelatedAddsListCell.swift
//  Haftaa
//
//  Created by Najeh on 01/08/2022.
//

import UIKit

class RelatedAddsListCell: UICollectionViewCell {

    @IBOutlet weak var noAdsLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var related:[AddsDetails]? {
        didSet {
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configueCollectionView()
        // Initialization code
    }
    
    func configueCollectionView(){
        collectionView.register(UINib(nibName: "adsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "adsCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension RelatedAddsListCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if related?.count == 0 {
            noAdsLbl.isHidden = false
        }else{
            noAdsLbl.isHidden = true
        }
        return related?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adsCollectionCell", for: indexPath) as! adsCollectionCell
        cell.adTitle.text = related?[indexPath.row].title
        cell.adsImage.setImage(with: related?[indexPath.row].image ?? "")
        cell.userLblName.text = related?[indexPath.row].user?.name ?? ""
        cell.sinceLbl.text = related?[indexPath.row].since
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
        vc.addID = related?[indexPath.row].id
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
}
