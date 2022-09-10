//
//  DeeplinkManger.swift
//  Drovox Passenger
//
//  Created by Eman Gaber on 3/10/21.
//

import Foundation
import UIKit

enum HomeViewingType: String {
    case shareAdd
    case none
}

class DeeplinkManger {
    static let shared = DeeplinkManger()
    
    var homeViewingType: HomeViewingType?
    //var tripID: String?
    static var addIDD: String?
    
    
    func handleDeepLink(url: String) {
        
        let addID = url.removingOccurrences(of: "https://alhfta.com/show_ads/ads/")
        if addID.isNumber {
            homeViewingType = .shareAdd
            DeeplinkManger.addIDD = addID
        }
        
    }
}
