import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var rootView: UIView!
    private weak var delegate: ViewControllerDelegate?
    private var loadingView: LoadingView?
    private var linkProfile: String?
    private var linkPhoto: String?
    private struct Properties {
        static let titleTextColor = UIColor.black.withAlphaComponent(0.4)
        static let titleStrokeColor = UIColor.systemGray6
        static let titleStroke = -7
        static let titleFont = UIFont(name: "Gill Sans UltraBold", size: 20)
        static let loadingViewSize = 25
        static let loadingViewSpacing = 12
        static let cornerRadius: CGFloat = 15
        static let shadowOffset = 2
        static let shadowOpacity: Float = 0.6
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLoadingView()
        cellDesign()
    }
    
    override func prepareForReuse() {
        loadingView?.isHidden = false
        loadingView?.animationResume()
        photoImage.image = nil
    }
    
    func setupCell(item: Photo, indexPath: Int, delegate: ViewControllerDelegate) {
        titleLabel.attributedText = titleText(name: item.userName)
        linkProfile = item.userURL
        linkPhoto = item.photoURL
        delegate.getImageForCell(indexPath: indexPath) { image in
            DispatchQueue.main.async {
                self.photoImage.image = image
                self.loadingView?.animationStop()
                self.loadingView?.isHidden = true
            }
        }
    }
    
    @IBAction func profileButton(_ sender: Any) {
        showLinkContent(link: linkProfile)
    }
    
    @IBAction func photoButton(_ sender: Any) {
        showLinkContent(link: linkPhoto)
    }
    
    private func showLinkContent(link: String?) {
        self.window?.rootViewController?.present(WebViewController(link: link), animated: true, completion: nil)
    }
    
    private func titleText(name: String?) -> NSAttributedString {
        guard let text = name else { return NSAttributedString()}
        let attrString = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor: Properties.titleTextColor,
            NSAttributedString.Key.strokeColor: Properties.titleStrokeColor,
            NSAttributedString.Key.strokeWidth: Properties.titleStroke,
            NSAttributedString.Key.font: Properties.titleFont as Any
            ]
        )
        return attrString
    }
    
    private func setupLoadingView() {
        loadingView = LoadingView(frame: CGRect(x: Properties.loadingViewSpacing, y: Properties.loadingViewSpacing, width: Properties.loadingViewSize, height: Properties.loadingViewSize))
        loadingView?.backgroundColor = .clear
        guard let loadingView = loadingView else { return }
        rootView.addSubview(loadingView)
    }
    
    private func cellDesign() {
        addShadows()
        addCornerRadius()
    }
    
    private func addShadows() {
        contentView.layer.shadowOffset = CGSize(width: Properties.shadowOffset, height: Properties.shadowOffset)
        contentView.layer.shadowOpacity = Properties.shadowOpacity
    }
    
    private func addCornerRadius() {
        rootView.layer.masksToBounds = true
        rootView.layer.cornerRadius = Properties.cornerRadius
    }
}
