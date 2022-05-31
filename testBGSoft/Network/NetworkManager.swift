import Foundation

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    private struct URL {
        static let commonLink = "https://dev.bgsoft.biz/task/"
        static let photoData = "credits.json"
        static let photoType = ".jpg"
    }
    
    private init() {}
    
    func getImage(nameOfPhoto: String?, completitionHandler: @escaping (Data?) -> Void) {
        guard let nameOfPhoto = nameOfPhoto else { return }
        URLSessionProvider.getData(currentLink: URL.commonLink + nameOfPhoto + URL.photoType) { image, _ in
            completitionHandler(image)
        }
    }
    
    func getAllData(completionHandler: @escaping ([String: Photo]?, NetworkError) -> Void) {
        URLSessionProvider.getData(currentLink: URL.commonLink + URL.photoData) {data, error in
            if error == NetworkError.success {
                guard let data = data else { return completionHandler(nil, NetworkError.noData) }
                let result: ([String: Photo]?, NetworkError) = NetworkDecoder.decodeData(data: data)
                guard let readyData = result.0 else { return completionHandler(nil, NetworkError.noData) }
                completionHandler(readyData, NetworkError.success)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
