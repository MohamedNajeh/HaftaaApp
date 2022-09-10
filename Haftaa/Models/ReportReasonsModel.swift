//
//  ReportReasonsModel.swift
//  Haftaa
//
//  Created by Najeh on 27/07/2022.
//

import Foundation

struct ReportReason:Codable {
    let data:[reasonElement]?
    let message:String?
    let success:Bool?
    let status:Int?
}

struct reasonElement:Codable {
    let id:Int?
    let reason:String?
}
