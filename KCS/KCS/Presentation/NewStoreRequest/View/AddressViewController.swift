//
//  AddressViewController.swift
//  KCS
//
//  Created by 김영현 on 2/18/24.
//

import WebKit
import RxRelay

final class AddressViewController: UIViewController {
    
    private let loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private lazy var addressWebView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        
        return webView
    }()
    
    private let addressObserver: PublishRelay<String>
    
    init(addressObserver: PublishRelay<String>) {
        self.addressObserver = addressObserver
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIComponents()
        configureConstraints()
        setWebView()
    }
    
}

private extension AddressViewController {
    
    func addUIComponents() {
        view.addSubview(addressWebView)
        view.addSubview(loadIndicator)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            addressWebView.topAnchor.constraint(equalTo: view.topAnchor),
            addressWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addressWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addressWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loadIndicator.centerXAnchor.constraint(equalTo: addressWebView.centerXAnchor),
            loadIndicator.centerYAnchor.constraint(equalTo: addressWebView.centerYAnchor)
        ])
    }
    
    func setWebView() {
        guard let url = URL(string: "https://korea-certified-store.github.io/KakaoAddressWeb/") else { return }
        addressWebView.load(URLRequest(url: url))
        loadIndicator.startAnimating()
    }
    
}

extension AddressViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let data = message.body as? [String: Any],
              let address = data["roadAddress"] as? String else { return }
        addressObserver.accept(address)
        self.dismiss(animated: true)
    }
    
}

extension AddressViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadIndicator.stopAnimating()
    }
    
}
