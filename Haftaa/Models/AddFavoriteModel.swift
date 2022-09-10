//
//  FavoriteModel.swift
//  Haftaa
//
//  Created by Najeh on 27/07/2022.
//

import Foundation

struct AddFavoriteModel:Codable {
    let data:Int?
    let message:String?
    let success:Bool?
    let status:Int?
}

struct AddGeneralComment:Codable {
    let data:String?
    let message:String?
    let success:Bool?
    let status:Int?
}

struct ForgetPssModel:Codable {
    let data:User?
    let message:String?
    let success:Bool?
    let status:Int?
}
