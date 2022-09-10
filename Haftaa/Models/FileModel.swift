//
//  FileModel.swift
//  Haftaa
//
//  Created by Najeh on 23/07/2022.
//

import Foundation

struct FileModel:Codable {
    let data : FileData?
    let message : String?
    let success : Bool?
    let status : Int?
}

struct FileData:Codable {
    let id : Int?
    let rout : String?
    let type : String?
}
