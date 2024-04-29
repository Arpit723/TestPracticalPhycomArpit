//
//  NewsWebViewController.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 28/04/24.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView!

    var newsUrlString: String?
    var titleNavigationBar: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleNavigationBar
        loadWebView()
        // Do any additional setup after loading the view.
    }
    
    func loadWebView() {
        Loader.show()
        wkWebView.navigationDelegate = self
        let link = URL(string:newsUrlString ?? "https://www.google.com")!
        let request = URLRequest(url: link)
        wkWebView.load(request)
    }
    

    

}

extension NewsWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.hide()

    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        Loader.hide()
    }
  
}
