import Foundation

enum NetworkError: String {
    case success
    case unableToDecode = "Unable to decode data"
    case noData = "No data to decode"
    case badRequest = "Something has changed on the server"
    case connectionProblems = "Internet connection problems"
}
