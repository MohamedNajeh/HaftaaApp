//
//  WhoWeAre.swift
//  Haftaa
//
//  Created by Najeh on 03/05/2022.
//

import Foundation

// MARK: - WhoWeAre
struct WhoWeAre: Codable {
    let data: [Datum]
    let message: String
    let success: Bool
    let status: Int
}

// MARK: - Datum
struct Datum: Codable {
    let name, datumDescription: String

    enum CodingKeys: String, CodingKey {
        case name
        case datumDescription = "description"
    }
}

