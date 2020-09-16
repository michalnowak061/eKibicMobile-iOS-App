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
    var loadIterator = 0
    
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
                if loadIterator >= 2 {
                    presentMainVC()
                }
                break
            case .BuyTicket:
                break
            case .MyTickets:
                presentEventsVC()
                break
            case .ForSale:
                break
            case .Null:
                break
            }
        }
    }
    
    private func downloadData() {
        afQueue.async {
            self.afSession.htmlSourceCode = nil
            self.afSession.dowloadHtmlSourceCode(url: dataModel.eKibicURL["myTickets"] ?? "")
            
            while self.afSession.htmlSourceCode == nil {
                usleep(100000)
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
    
    private func presentRememberMeCommunicate() {
        let alert = UIAlertController(title: "Zapamiętaj mnie", message: "Do poprawnego działania aplikacja wymaga zalogowania z zaznaczoną opcją \"zapamiętaj mnie\".", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension SignInVC: WKNavigationDelegate {
    func webView(_: WKWebView, didFinish: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
            self.downloadData()
            self.loadIterator += 1
        })
    }
}
