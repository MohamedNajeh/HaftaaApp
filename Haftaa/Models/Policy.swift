//
//  Policy.swift
//  Haftaa
//
//  Created by Najeh on 03/05/2022.
//

import Foundation

// MARK: - Policy
struct Policy: Codable {
    let data: DataClass
    let message: String
    let success: Bool
    let status: Int
}

// MARK: - DataClass
struct DataClass: Codable {
    let privacyPolicy, marketPolicy: String

    enum CodingKeys: String, CodingKey {
        case privacyPolicy = "privacy_policy"
        case marketPolicy = "market_policy"
    }
}
