import Foundation
import UIKit
class Presenter: ViewControllerDelegate {
    private weak var view: PresenterDelegate?
    private let imageCache = NSCache<NSString, UIImage>()
    private var dictionaryOfData = [String: Photo]() {
        didSet {
            sortByAuthor()
            DispatchQueue.main.async {
                self.view?.reloadCollection()
            }
        }
    }
    private var arrayOfNames = [String]()
    
    required init(view: PresenterDelegate) {
        self.view = view
    }
    
    private func updateAllNetworkData() {
        NetworkManager.data.getAllData { data, error in
            if error != .success {
                DispatchQueue.main.async {
                    self.view?.showErrorAlert(error: error)
                }
            } else {
                guard let data = data else { return }
                self.dictionaryOfData = data
            }
        }
    }
    
    private func sortByAuthor() {
        arrayOfNames = dictionaryOfData.sorted { $0.value.userName ?? "" < $1.value.userName ?? ""}.map { $0.key }
    }
    
    func updateAllData() {
        updateAllNetworkData()
    }
    
    func getNumberOfCells() -> Int {
        return arrayOfNames.count
    }
    
    func getItemForIndexPath(indexPath: Int) -> Photo {
        return dictionaryOfData[arrayOfNames[indexPath]] ?? Photo()
    }
    
    func getImageForCell(indexPath: Int, completitionHandler: @escaping (UIImage?) -> Void) {
        let imageName = arrayOfNames[indexPath]
        if let image = imageCache.object(forKey: imageName as NSString) {
            completitionHandler(image)
        } else {
            NetworkManager.data.getImage(nameOfPhoto: arrayOfNames[indexPath]) { data in
                guard let data = data else { return }
                let image = UIImage(data: data as Data)
                if let image = image {
                    self.imageCache.setObject(image, forKey: imageName as NSString)
                }
                completitionHandler(image)
            }
        }
    }
}
