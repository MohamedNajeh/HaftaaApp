//
//  NotificationModel.swift
//  Haftaa
//
//  Created by Apple on 31/07/2022.
//

import Foundation
struct NotificationModel: Codable {
    let data: [NotificationItem]?
    let message: String?
    let success: Bool?
    let status: Int?
}

// MARK: - NotificationModel
struct NotificationItem: Codable {
    let id: Int?
    let userID, title: String?
    let route: String?
    let type, modelID: String?

    enum CodingKeys: String, CodingKey {
        case id , type
        case userID = "user_id"
        case title, route
        case modelID = "model_id"
    }
}
