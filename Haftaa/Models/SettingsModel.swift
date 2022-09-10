//
//  Settings.swift
//  Haftaa
//
//  Created by Apple on 20/07/2022.
//

import Foundation
struct SettingsModel: Codable {
    let data: SettingsData
    let message: String
    let success: Bool
    let status: Int
}
struct SettingsData: Codable {
    let name, email, phone, whatsapp: String
    let categoryImage: Int
    let logo, appImage: String
    let maintenance, activeRegister: Int
    let maintenanceMessage, dataDescription, notification, section: String
    let commission, facebook, youtube: String
    let twitter: String
    let instagram: String
    let snap: String

    enum CodingKeys: String, CodingKey {
        case name, email, phone, whatsapp
        case categoryImage = "category_image"
        case logo
        case appImage = "app_image"
        case maintenance
        case activeRegister = "active_register"
        case maintenanceMessage = "maintenance_message"
        case dataDescription = "description"
        case notification
        case section = "Section"
        case commission, facebook, youtube, twitter
        case instagram = "Instagram"
        case snap
    }
}
