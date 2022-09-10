// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let discussionModel = try? newJSONDecoder().decode(DiscussionModel.self, from: jsonData)

import Foundation

// MARK: - DiscussionModel
struct DiscussionModel: Codable {
    let data: DiscussionData
    let message: String
    let success: Bool
    let status: Int
}

// MARK: - DataClass
struct DiscussionData: Codable {
    let data: [Discussions]
    let pages: Int
}

struct OneDiscussionDetails: Codable {
    let data:Discussions?
    let message:String?
    let success:Bool?
    let status:Int?
}

// MARK: - Datum
struct Discussions: Codable {
    let id: Int
    let title, datumDescription, since, listUpdate: String
    let countComment, countLike, countDisLike: Int
    let comments: [DiscussComment]

    enum CodingKeys: String, CodingKey {
        case id, title
        case datumDescription = "description"
        case since
        case listUpdate = "list_update"
        case countComment = "count_comment"
        case countLike = "count_like"
        case countDisLike = "count_dis_like"
        case comments
    }
}

// MARK: - Comment
struct DiscussComment: Codable {
    let id: Int?
    let user: User?
    let comment, date: String?
}

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
