import UIKit

class ViewController: UIViewController, PresenterDelegate {
    @IBOutlet weak var mainCollection: UICollectionView!
    private var presenter: ViewControllerDelegate!
    private struct Properties {
        static let cellName = "CollectionViewCell"
        static let spacing: CGFloat = 20
    }
    
    private struct AlertText {
        static let title = "Something went wrong"
        static let buttonReload = "try again"
        static let buttonCancel = "cancel"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter = Presenter(view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerMainCollection()
        presenter.updateAllData()
    }
    
    private func registerMainCollection() {
        mainCollection.delegate = self
        mainCollection.dataSource = self
        mainCollection.register(UINib(nibName: Properties.cellName, bundle: nil), forCellWithReuseIdentifier: Properties.cellName)
        mainCollection.isPagingEnabled = true
    }
    
    func reloadCollection() {
        mainCollection.reloadData()
    }
    
    func showErrorAlert(error: NetworkError) {
        let alert = UIAlertController(title: AlertText.title, message: error.rawValue, preferredStyle: .alert)
        let actionOkey = UIAlertAction(title: AlertText.buttonReload, style: .default) { _ in
            self.presenter.updateAllData() }
        let actionCancel = UIAlertAction(title: AlertText.buttonCancel, style: .default) { _ in
        }
        alert.view.tintColor = .black
        alert.addAction(actionOkey)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNumberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Properties.cellName, for: indexPath) as? CollectionViewCell {
            cell.setupCell(item: presenter.getItemForIndexPath(indexPath: indexPath.item), indexPath: indexPath.item, delegate: presenter)
            return cell
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainCollection.frame.width - Properties.spacing * 2, height: mainCollection.frame.height - Properties.spacing * 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2 * Properties.spacing, left: Properties.spacing, bottom: 2 * Properties.spacing, right: Properties.spacing)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Properties.spacing * 2
    }
}
