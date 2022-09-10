//
//  AddNewAdds+TVDelegate.swift
//  Haftaa
//
//  Created by Apple on 25/07/2022.
//

import Foundation
import UIKit
extension AddNewAddVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "adImagesCell", for: indexPath) as! adImagesCell
        item.imageV.image = photoArray[indexPath.row]
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imagesCollectionView.frame.width/3, height: imagesCollectionView.frame.height)
    }
}
