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

enum NetworkError: String {
    case success
    case unableToDecode = "Unable to decode data"
    case noData = "No data to decode"
    case badRequest = "Something has changed on the server"
    case connectionProblems = "Internet connection problems"
}
