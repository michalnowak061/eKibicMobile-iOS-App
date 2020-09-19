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
                presentSignInCommunicate()
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
        afSession.dowloadHtmlSourceCode(url: dataModel.eKibicURL["myTickets"] ?? "")
        
        afQueue.async {
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
    
    private func presentSignInCommunicate() {
        let alert = UIAlertController(title: "Pierwsze uruchomienie", message: "Pierwsze uruchomienie aplikacji wymaga zalogowania się na platformie ekibic wraz z zaznaczoną opcją \"zapamiętaj mnie\".", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
            self.presentSignInVC()
        }))
        self.present(alert, animated: true)
    }
}
