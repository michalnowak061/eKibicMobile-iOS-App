//
//  ViewController.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 11/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

var dataModel = DataModel()

class MainVC: UIViewController {
    var afSession = AlamofireSession()
    var afQueue = DispatchQueue.init(label: "afQueue")
    var viewQueue = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
    }
    
    private func updateView() {
        viewQueue.sync {
            switch dataModel.state {
            case .SignIn:
                presentSignInVC()
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
            
            self.textView.text = dataModel.htmlSourceCode
        }
    }
    
    private func downloadData() {
        afSession.dowloadHtmlSourceCode(url: dataModel.eKibicURL["myTickets"] ?? "")
        
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
        
    @IBOutlet weak var textView: UITextView!
}
