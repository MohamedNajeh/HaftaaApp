//
//  StaticPage.swift
//  Haftaa
//
//  Created by Najeh on 07/08/2022.
//

import Foundation
struct StaicPages: Codable {
    let data: [staicData]
    let message: String
    let success: Bool
    let status: Int
}

// MARK: - Datum
struct staicData: Codable {
    let id: Int
    let name: String
    let page: [Page]
}

// MARK: - Page
struct Page: Codable {
    let id: Int
    let name, pageDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case pageDescription = "description"
    }
}
