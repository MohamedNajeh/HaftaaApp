//
//  ImageVC.swift
//  Haftaa
//
//  Created by Apple on 06/07/2022.
//

import UIKit

class ImageVC: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageV: UIImageView!
    
    var imageURL:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageV.setImage(with: imageURL ?? "")
        scrollView.delegate = self
        //scrollView.minimumZoomScale = 1.0
        //scrollView.maximumZoomScale = 10.0

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageV
    }


}
