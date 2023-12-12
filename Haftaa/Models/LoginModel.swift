// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginModel = try? newJSONDecoder().decode(LoginModel.self, from: jsonData)

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let data: loginData?
    let success: Bool?
    let message: String?
    let status: Int?
}

struct FCMModel: Codable {
    let data: String?
    let success: Bool?
    let message: String?
    let status: Int?
}

// MARK: - DataClass
struct loginData: Codable {
    let id: Int?
    let userName, name, phone: String?
    let photoPath: String?
    let photoID: String?
    let nationalIdentityPath: String?
    let nationalIdentity: Int?
    let commercialRegisterPath: String?
    let commercialRegister: Int?
    let favourPath: String?
    let favour: Int?
    let workPermitPath: String?
    let workPermit:Int?
    let sajalMadaniun: String?
    let allowPhone, whatsapp: Int?
    let email: String?
    let trusted: Int?
    let city: DataCity?
    let newPassword: Int?
    let country: Country?
    let ban: Int?
    let accessToken: String?

    enum CodingKeys: String, CodingKey {
        case id, userName, name, phone,trusted,ban
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
        case country
        case accessToken = "access_token"
    }
}

// MARK: - DataCity
struct DataCity: Codable {
    let id:Int?
    let name: String?
}

// MARK: - Country
struct Country: Codable {
    let id: Int?
    let name, key: String?
    let sendSMS: Int?
    let cities: [City]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case key = "Key"
        case sendSMS = "send_sms"
        case cities
    }
}

// MARK: - CityElement
struct CityElement: Codable {
    let id: Int?
    let name: String?
}

