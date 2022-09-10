//
//  adsDetails+collectionDelegate.swift
//  Haftaa
//
//  Created by Apple on 04/07/2022.
//

import Foundation
import UIKit
import SwiftUI

extension  adsDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == commentsAndAdTable {
            return 3
        }
        return self.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == commentsAndAdTable {
            switch indexPath.row {
            case 0:
                guard let cell = commentsAndAdTable.dequeueReusableCell(withReuseIdentifier: "RelatedAddsListCell", for: indexPath) as?  RelatedAddsListCell
                else { return UICollectionViewCell() }
                cell.related = self.related
                //cell.delegate = self
                return cell
            case 1:
                guard let cell = commentsAndAdTable.dequeueReusableCell(withReuseIdentifier: "CustomersReviewsCell", for: indexPath) as?  CustomersReviewsCell
                else { return UICollectionViewCell() }
                cell.details = details
                //cell.delegate = self
                return cell
            case 2:
                guard let cell = commentsAndAdTable.dequeueReusableCell(withReuseIdentifier: "CommentsListCell", for: indexPath) as?  CommentsListCell
                else { return UICollectionViewCell() }
                cell.details = details
                cell.comments = details?.comments ?? []
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adImagesCell", for: indexPath) as! adImagesCell
        cell.configureImage(image: images?[indexPath.row].image ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == commentsAndAdTable {
            return CGSize(width: commentsAndAdTable.frame.width, height: commentsAndAdTable.frame.height)
        }
        return CGSize(width: adImagesCollection.frame.width , height: adImagesCollection.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
        vc.imageURL = images?[indexPath.row].image
        self.present(vc, animated: true)
    }
    
    func changeCollectionStat(index: Int) {
        commentsAndAdTable.isScrollEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.commentsAndAdTable.scrollToItem(at: IndexPath(row: index, section: 0), at: .init(), animated: false)
            self.commentsAndAdTable.layoutIfNeeded()
        } completion: { _ in
            self.commentsAndAdTable.isScrollEnabled = false
        }
    }
}


