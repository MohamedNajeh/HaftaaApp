//
//  StaticPageDetails.swift
//  Haftaa
//
//  Created by Najeh on 07/08/2022.
//

import UIKit

class StaticPageDetails: UIViewController {

    @IBOutlet weak var descriptionTV: UITextView!
    var desc = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTV.attributedText = desc.htmlToAttributedString
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
