import Foundation
import UIKit

protocol ViewControllerDelegate: AnyObject {
    init(view: PresenterDelegate)
    func getNumberOfCells() -> Int
    func getItemForIndexPath(indexPath: Int) -> Photo
    func updateAllData()
    func getImageForCell(indexPath: Int, completitionHandler: @escaping (UIImage?) -> Void)
 }

protocol PresenterDelegate: AnyObject {
    func reloadCollection()
    func showErrorAlert(error: NetworkError)
}
