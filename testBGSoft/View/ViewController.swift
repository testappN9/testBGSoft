import UIKit

class ViewController: UIViewController, PresenterDelegate, CollectionCellDelegate {
    @IBOutlet weak var mainCollection: UICollectionView!
    private var presenter: ViewControllerDelegate!
    private var taskScroll = DispatchWorkItem {}
    private struct Properties {
        static let cellName = "CollectionViewCell"
        static let spacing: CGFloat = 20
        static let zoomScale: CGFloat = 0.9
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
    
    private func scrollMainCollection(currentIndex: Int) {
        taskScroll = DispatchWorkItem {
            let index = currentIndex == self.mainCollection.numberOfItems(inSection: 0) - 2 ? 1 : currentIndex
            self.mainCollection.scrollToItem(at: IndexPath(item: index + 1, section: 0), at: .left, animated: true)
            self.scrollMainCollection(currentIndex: index + 2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: taskScroll)
    }
    
    func reloadCollection() {
        mainCollection.reloadData()
        mainCollection.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)
        scrollMainCollection(currentIndex: 1)
    }
    
    func getImageForCell(indexPath: Int, completitionHandler: @escaping (UIImage?) -> Void) {
        presenter.getImageForCell(indexPath: indexPath) { image in
            completitionHandler(image)
        }
    }
    
    func showWebContent(link: String?) {
        taskScroll.cancel()
        self.present(WebViewController(link: link), animated: true, completion: nil)
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
            cell.setupCell(item: presenter.getItemForIndexPath(indexPath: indexPath.item), indexPath: indexPath.item, delegate: self)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        switch page {
        case 0:
            mainCollection.scrollToItem(at: [0, mainCollection.numberOfItems(inSection: 0) - 2], at: .left, animated: false)
        case mainCollection.numberOfItems(inSection: 0) - 1:
            mainCollection.scrollToItem(at: [0, 1], at: .left, animated: false)
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        let center = CGPoint(x: mainCollection.frame.width / 2 + scrollView.contentOffset.x, y: self.mainCollection.frame.height / 2 + scrollView.contentOffset.y)
        guard let indexPath = mainCollection.indexPathForItem(at: center) else { return }
        guard let centerCell = mainCollection.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        let zoomRaw = 1 - ((centerCell.frame.minX - Properties.spacing) - scrollView.contentOffset.x.magnitude).magnitude / ( 4 * mainCollection.frame.width)
        let zoom = zoomRaw >= Properties.zoomScale ? zoomRaw : Properties.zoomScale
        updateEffects(cell: centerCell, ratio: zoom)
        if let nextCell = mainCollection.cellForItem(at: IndexPath(item: indexPath.item + 1, section: 0)) as? CollectionViewCell {
            updateEffects(cell: nextCell, ratio: Properties.zoomScale)
        }
        if let previousCell = mainCollection.cellForItem(at: IndexPath(item: indexPath.item - 1, section: 0) ) as? CollectionViewCell {
            updateEffects(cell: previousCell, ratio: Properties.zoomScale)
        }
        func updateEffects(cell: CollectionViewCell, ratio: CGFloat) {
            cell.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            cell.photoImage.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            cell.photoImage.alpha = ratio
        }
        taskScroll.cancel()
        scrollMainCollection(currentIndex: indexPath.item)
    }
}
