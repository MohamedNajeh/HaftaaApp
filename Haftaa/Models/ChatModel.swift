// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chatModel = try? newJSONDecoder().decode(ChatModel.self, from: jsonData)

import Foundation

// MARK: - ChatModel
struct ChatModel: Codable {
    let data: ChatData?
    let message: String?
    let success: Bool?
    let status: Int?
}

// MARK: - DataClass
struct ChatData: Codable {
    let id: Int?
    let senderUser, receivedUser: ChatUser?
    let receivedUserID, notReady: Int?
    let messages: [Message]?

    enum CodingKeys: String, CodingKey {
        case id
        case senderUser = "sender_user"
        case receivedUser = "received_user"
        case receivedUserID = "received_user_id"
        case notReady = "not_ready"
        case messages
    }
}

// MARK: - Message
struct Message: Codable {
    let id: Int?
    let message: String?
    let senderUser: ChatUser?
    let senderID: Int?

    enum CodingKeys: String, CodingKey {
        case id, message
        case senderUser = "sender_user"
        case senderID = "sender_id"
    }
}

// MARK: - User
struct ChatUser: Codable {
    let id: Int?
    let userName, name, phone: String?
    let photoPath: String?
    let photoID: String?
    let nationalIdentityPath: String?
    let nationalIdentity: Int
    let commercialRegisterPath: String?
    let commercialRegister: Int?
    let favourPath: String?
    let favour: Int?
    let workPermitPath: String?
    let workPermit: Int?
    let sajalMadaniun: String?
    let allowPhone, whatsapp: Int?
    let email: String?
    let city: CityElement?
    let newPassword: Int?
    let country: Country?
    let step, trusted: Int?

    enum CodingKeys: String, CodingKey {
        case id, userName, name, phone
        case photoPath = "photo_path"
        case photoID = "photo_id"
        case nationalIdentityPath = "national_identity_path"
        case nationalIdentity = "national_identity"
        case commercialRegisterPath = "commercial_register_path"
        case commercialRegister = "commercial_register"
        case favourPath = "favour_path"
        case favour
        case workPermitPath = "work_permit_path"
        case workPermit = "work_permit"
        case sajalMadaniun = "sajal_madaniun"
        case allowPhone = "allow_phone"
        case whatsapp, email, city
        case newPassword = "new_password"
        case country, step, trusted
    }
}

// MARK: - Country
//struct Country: Codable {
//    let id: Int
//    let name, key: String
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

// MARK: - City
//struct City: Codable {
//    let id: Int
//    let name: String
//}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}

