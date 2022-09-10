//
//  AllChatsModel.swift
//  Haftaa
//
//  Created by Najeh on 05/08/2022.
//

import Foundation

struct AllChats: Codable {
    let data: [ChatData]
    let message: String
    let success: Bool
    let status: Int
}

// MARK: - Datum
//struct Datum: Codable {
//    let id: Int
//    let senderUser: User
//    let receivedUser: User?
//    let receivedUserID, notReady: Int
//    let messages: [Message]
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case senderUser = "sender_user"
//        case receivedUser = "received_user"
//        case receivedUserID = "received_user_id"
//        case notReady = "not_ready"
//        case messages
//    }
//}

// MARK: - Message
//struct Message: Codable {
//    let id: Int
//    let message: String
//    let senderUser: User?
//    let senderID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, message
//        case senderUser = "sender_user"
//        case senderID = "sender_id"
//    }
//}

// MARK: - User
//struct User: Codable {
//    let id: Int
//    let userName, name, phone: String
//    let photoPath: String
//    let photoID: String
//    let nationalIdentityPath: String
//    let nationalIdentity: Int
//    let commercialRegisterPath: String
//    let commercialRegister: Int
//    let favourPath: String
//    let favour: Int
//    let workPermitPath: String
//    let workPermit: Int
//    let sajalMadaniun: String
//    let allowPhone, whatsapp: Int
//    let email: Email
//    let city: City?
//    let newPassword: Int
//    let country: Country
//    let step, trusted: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, userName, name, phone
//        case photoPath = "photo_path"
//        case photoID = "photo_id"
//        case nationalIdentityPath = "national_identity_path"
//        case nationalIdentity = "national_identity"
//        case commercialRegisterPath = "commercial_register_path"
//        case commercialRegister = "commercial_register"
//        case favourPath = "favour_path"
//        case favour
//        case workPermitPath = "work_permit_path"
//        case workPermit = "work_permit"
//        case sajalMadaniun = "sajal_madaniun"
//        case allowPhone = "allow_phone"
//        case whatsapp, email, city
//        case newPassword = "new_password"
//        case country, step, trusted
//    }
//}

// MARK: - City
//struct City: Codable {
//    let id: Int
//    let name: String
//}

// MARK: - Country
//struct Country: Codable {
//    let id: Int
//    let name: Name
//    let key: String
//    let sendSMS: Int
//    let cities: [City]
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case key = "Key"
//        case sendSMS = "send_sms"
//        case cities
//    }
//}

