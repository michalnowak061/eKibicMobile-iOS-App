//
//  SignInVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 14/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit
import WebKit

class SignInVC: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    var afSession = AlamofireSession()
    var afQueue = DispatchQueue.init(label: "afQueue")
    var viewQueue = DispatchQueue.main
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: dataModel.eKibicURL["signIn"] ?? "")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func updateView() {
        viewQueue.sync {
            switch dataModel.state {
            case .SignIn:
                break
            case .BuyTicket:
                presentDataVC()
                break
            case .MyTickets:
                break
            case .ForSale:
                break
            case .Null:
                break
            }
        }
    }
    
    private func downloadData() {
        afSession.dowloadHtmlSourceCode(url: dataModel.eKibicURL["cracovia"] ?? "")
        
        afQueue.async {
            while self.afSession.htmlSourceCode == nil {
                sleep(1)
                print("pobieram...")
            }
            
            if self.afSession.htmlSourceCode != "error" {
                dataModel.htmlSourceCode = self.afSession.htmlSourceCode
            }
            else {
                print("Error - downloadData")
            }
            
            dataModel.update()
            self.updateView()
        }
    }
}

extension SignInVC: WKNavigationDelegate {
    func webView(_: WKWebView, didFinish: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            self.downloadData()
        })
    }
}
