import Foundation

struct Photo: Codable {
    var photoURL: String?
    var userName: String?
    var userURL: String?
    var colors: [String]?
    enum CodingKeys: String, CodingKey {
        case photoURL = "photo_url"
        case userName = "user_name"
        case userURL = "user_url"
        case colors = "colors"
    }
}
