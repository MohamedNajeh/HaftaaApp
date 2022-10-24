//
//  UIImageView+Ext.swift
//  Haftaa
//
//  Created by Najeh on 23/04/2022.
//

import Foundation
import UIKit
import Kingfisher
import SDWebImage

extension UIImageView{
    func  setImage(with url : String){
        DispatchQueue.main.async {
            guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
            let placeHolderImage = UIImage(named: "llogo")
            //self.sd_setImage(with: url, placeholderImage: placeHolderImage)
            self.kf.indicatorType = .activity
            
            self.kf.setImage(with: url, placeholder: placeHolderImage, options: [.transition(.fade(1))])
            
        }
    }
}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        }
        
        return image.withRenderingMode(self.renderingMode)
    }
}

extension UIImage {
    func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
    
    
    func maskWithColor(color: UIColor) -> UIImage {
           UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
           let context = UIGraphicsGetCurrentContext()!

           let rect = CGRect(origin: CGPoint.zero, size: size)

           color.setFill()
           self.draw(in: rect)

           context.setBlendMode(.sourceIn)
           context.fill(rect)

           let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           return resultImage
       }
    
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
           let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
           let format = imageRendererFormat
           format.opaque = isOpaque
           return UIGraphicsImageRenderer(size: canvas, format: format).image {
               _ in draw(in: CGRect(origin: .zero, size: canvas))
           }
       }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
            let bytes = kb * 1024
            var compression: CGFloat = 1.0
            let step: CGFloat = 0.05
            var holderImage = self
            var complete = false
            while(!complete) {
                if let data = holderImage.jpegData(compressionQuality: 1.0) {
                    let ratio = data.count / bytes
                    if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                        complete = true
                        return data
                    } else {
                        let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                        compression -= (step * multiplier)
                    }
                }
                
                guard let newImage = holderImage.resized(withPercentage: compression) else { break }
                holderImage = newImage
            }
            return Data()
        }
}
