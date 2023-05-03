//
//  UserAdsModel.swift
//  Haftaa
//
//  Created by Najeh on 30/07/2022.

import Foundation

// MARK: - UserAdsModel
struct UserAdsModel: Codable {
    let data: UserAdsData?
    let message: String?
    let success: Bool?
    let status: Int?
}

// MARK: - DataClass
struct UserAdsData: Codable {
    let pages: Int?
    let data: [AddsDetails]?
    let countAds: Int?
    let totleRate: String?
    let rate: [Rate]?
    let comments: [Comment]?

    enum CodingKeys: String, CodingKey {
        case pages, data
        case countAds = "count_ads"
        case totleRate = "totle_rate"
        case rate, comments
    }
}

struct Rate: Codable {
    let user: User?
    let rateDescription: String?
    let date: String?
    let rate: Int?

    enum CodingKeys: String, CodingKey {
        case user
        case rateDescription = "description"
        case date, rate
    }
}
