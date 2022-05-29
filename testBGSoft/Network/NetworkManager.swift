import Foundation
import UIKit

class NetworkManager {
    static let data: NetworkManager = NetworkManager()
    private struct Links {
        static let commonLink = "https://dev.bgsoft.biz/task/"
        static let photoData = "credits.json"
        static let photoType = ".jpg"
    }
    
    private init() {}
    
    func getImage(nameOfPhoto: String?, completitionHandler: @escaping (Data?) -> Void) {
        guard let nameOfPhoto = nameOfPhoto else { return }
        URLSessionProvider.getData(currentLink: Links.commonLink + nameOfPhoto + Links.photoType) { image, _ in
            completitionHandler(image)
        }
    }
    
    func getAllData(completionHandler: @escaping ([String: Photo]?, NetworkError) -> Void) {
        URLSessionProvider.getData(currentLink: Links.commonLink + Links.photoData) {data, error in
            if error == NetworkError.success {
                if let data = data {
                    let result: ([String: Photo]?, NetworkError) = NetworkDecoder.decodeData(data: data)
                    if let readyData = result.0 {
                        completionHandler(readyData, NetworkError.success)
                    } else {
                        completionHandler(nil, NetworkError.noData)
                    }
                } else {
                    completionHandler(nil, NetworkError.noData)
                }
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
