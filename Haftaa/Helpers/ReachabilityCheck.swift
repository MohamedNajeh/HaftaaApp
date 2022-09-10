//
//  ReachabilityCheck.swift
//  Haftaa
//
//  Created by Najeh on 15/08/2022.
//

import Foundation
import Alamofire
struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}

