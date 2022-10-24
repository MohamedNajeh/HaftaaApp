

import Foundation

struct typeRoot:Codable{
    let data : [Category]?
    let message : String?
    let success : Bool?
    let status : Int?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case message = "message"
        case success = "success"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Category].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
}
