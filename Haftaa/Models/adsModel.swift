// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let myAdss = try? newJSONDecoder().decode(MyAdss.self, from: jsonData)

import Foundation

// MARK: - MyAdss
struct MyAds: Codable {
    let data: Ads?
    let message: String?
    let success: Bool?
    let status: Int?
}

struct AddDetailsModel:Codable {
    let data: AddDetailsData?
    let message: String?
    let success: Bool?
    let status: Int?
}

struct AddDetailsData:Codable {
    let ads: AddsDetails?
    let related: [AddsDetails]?
}

// MARK: - DataClass
struct Ads: Codable {
    let pages: Int?
    let data: [AddsDetails]?
}

// MARK: - Datum
struct AddsDetails: Codable {
    let id: Int?
    let title: String?
    let adsType: String?
    let isType: Bool?
    let user: User?
    let city: City?
    let area:CityElement?
    let country: Country?
    let category: Category?
    let detail: String?
    let video: String?
    let videoID, phone: String?
    let price,commentAllow: Int?
    let edit,delete : Int?
    let image: String?
    let images: [Image]?
    let comments: [Comment]?
    let countViews: Int?
    let rate: String?
    let since: String?
    let lat, lng:String?
    let distance: String?
    let typeAds: String?
    let mayReport, allreport: JSONAny?
    let reviewAds: [ReviewAd]?
    let bankAccounts: [BanksData]?
    let favorit: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, adsType, user, city, country, category, detail, video,area,delete
        case videoID = "video_id"
        case phone, commentAllow, price, edit, image, images, comments
        case countViews = "count_views"
        case rate, since, lat, lng, distance
        case typeAds = "type_ads"
        case mayReport = "may_report"
        case allreport
        case reviewAds = "review_ads"
        case favorit
        case isType = "is_type"
        case bankAccounts = "bank_account"
    }
}

struct BanksData:Codable{
    let name, number_account, iban:String?
}


// MARK: - Category
struct Category1: Codable {
    let id: Int?
    let name: String?
    let image: String?
}


// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let areas:[CityElement]?
}


// MARK: - Comment
struct Comment: Codable {
    let id:Int?
    let users: User?
    let since, comment: String?
    let deleteComment: Int?
    let parents:commentParentForAds?

    enum CodingKeys: String, CodingKey {
        case users, since, comment,id
        case deleteComment = "delete_comment"
        case parents
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let userName: String?
    let name: String?
    let phone: String?
    let photoPath: String?
    let photoID: String?
    let nationalIdentityPath: String?
    let nationalIdentity: Int?
    let commercialRegisterPath: String?
    let commercialRegister: Int?
    let favourPath: String?
    let favour: Int?
    let workPermitPath: String?
    let workPermit: Int?
    let sajalMadaniun: String?
    let allowPhone, whatsapp: Int?
    let email: String?
    let city: City?
    let newPassword: Int?
    let country: Country2?
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
struct Country2: Codable {
    let id: Int?
    let name: String?
    let key: String?
    let sendSMS: Int?
    let cities: [City]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case key = "Key"
        case sendSMS = "send_sms"
        case cities
    }
}

// MARK: - Image
struct Image: Codable {
    let image: String?
    let id: String?
}

// MARK: - ReviewAd
struct ReviewAd: Codable {
    let user: User?
    let reviewAdDescription, date: String?
    let rate: Int?

    enum CodingKeys: String, CodingKey {
        case user
        case reviewAdDescription = "description"
        case date, rate
    }
}

enum Since: String, Codable {
    case منذ15ساعة = "منذ 15 ساعة"
    case منذيوم = "منذ يوم"
}

enum TypeAds: String, Codable {
    case normal = "normal"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

