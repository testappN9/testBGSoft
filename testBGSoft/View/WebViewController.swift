import Foundation
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    private var link: String?
    
    convenience init(link: String?) {
        self.init(nibName: nil, bundle: nil)
        self.link = link
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPage()
    }
    
    private func loadPage() {
        guard let link = link else { return }
        let url = URL(string: link)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
