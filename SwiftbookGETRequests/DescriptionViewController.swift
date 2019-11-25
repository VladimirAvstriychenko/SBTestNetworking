//
//  DescriptionViewController.swift
//  SwiftbookGETRequests
//
//  Created by Владимир on 07/10/2019.
//  Copyright © 2019 VladCorp. All rights reserved.
//

import UIKit
import WebKit

class DescriptionViewController: ViewController{
    @IBOutlet weak var webView: WKWebView!
    var selectedCourse: String?
    var courseURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCourse
        guard let url = URL(string: courseURL) else {return}
        let request = URLRequest(url: url)
        
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
     override func observeValue(forKeyPath keyPath: String?,
                                   of object: Any?,
                                   change: [NSKeyValueChangeKey : Any]?,
                                   context: UnsafeMutableRawPointer?) {
            
            if keyPath == "estimatedProgress" {
                //progressView.progress = Float(webView.estimatedProgress)
            }
        }
        
        private func showProgressView() {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                //self.progressView.alpha = 1
            }, completion: nil)
        }
        
        private func hideProgressView() {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                //self.progressView.alpha = 0
            }, completion: nil)
        }
        
}

    extension DescriptionViewController: WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            //showProgressView()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            //hideProgressView()
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            //hideProgressView()
        }
    }
    

