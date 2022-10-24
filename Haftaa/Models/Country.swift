//
//
//import Foundation
//struct Country : Codable {
//    let id : Int?
//    let name : String?
//    let key : String?
//    let send_sms : Int?
//    let cities : [Cities]?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case name = "name"
//        case key = "Key"
//        case send_sms = "send_sms"
//        case cities = "cities"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        key = try values.decodeIfPresent(String.self, forKey: .key)
//        send_sms = try values.decodeIfPresent(Int.self, forKey: .send_sms)
//        cities = try values.decodeIfPresent([Cities].self, forKey: .cities)
//    }
//
//}
