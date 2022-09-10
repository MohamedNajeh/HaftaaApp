//
//  HomeVC+CollectionDelegate.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import Foundation
import UIKit

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productTypeCell", for: indexPath) as! productTypeCell
        cell.imgV.setImage(with: types[indexPath.row].image!)
        cell.profuctName.text = types[indexPath.row].name
        cell.contentView.borderColor = self.selectedType == indexPath.row ? .blue : .clear
        if UserInfo.appSettings?.data.categoryImage == 1 {
            cell.imgV.isHidden = true
            cell.profuctName.isHidden = false
        }else if UserInfo.appSettings?.data.categoryImage == 2{
            cell.imgV.isHidden = false
            cell.profuctName.isHidden = true
        }else if UserInfo.appSettings?.data.categoryImage == 3{
            cell.imgV.isHidden = false
            cell.profuctName.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 10)/2.5, height: (collectionView.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchByCategory(categoryID: types[indexPath.row].id!, cityID: self.cityID, countryID: self.countryID, adsType: searchAdsType, searchText: "")
        self.selectedType = indexPath.row
        self.isTypeFilter = true
        self.categoryID = types[indexPath.row].id ?? 0
        self.collectionView.reloadData()
    }
    
    
}
