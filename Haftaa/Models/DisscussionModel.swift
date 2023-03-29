// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let discussionModel = try? newJSONDecoder().decode(DiscussionModel.self, from: jsonData)

import Foundation

// MARK: - DiscussionModel
struct DiscussionModel: Codable {
    let data: DiscussionData?
    let message: String?
    let success: Bool?
    let status: Int?
}

// MARK: - DataClass
struct DiscussionData: Codable {
    let data: [Discussions]?
    let pages: Int?
}

struct OneDiscussionDetails: Codable {
    var data:Discussions?
    let message:String?
    let success:Bool?
    let status:Int?
}

// MARK: - Datum
struct Discussions: Codable {
    let id: Int?
    let title, datumDescription, since, listUpdate: String?
    let countComment, countLike, countDisLike: Int?
    var comments: [DiscussComment]?
    let url:String?
    let route:String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case datumDescription = "description"
        case since
        case listUpdate = "list_update"
        case countComment = "count_comment"
        case countLike = "count_like"
        case countDisLike = "count_dis_like"
        case comments
        case url
        case route
    }
}

// MARK: - Comment
struct DiscussComment: Codable {
    let id: Int?
    let user: User?
    let comment, date: String?
    let parent: commentParent?
    let delete: Int?
}

struct commentParent:Codable {
    let id: Int?
    let user: User?
    let comment:String?
}
