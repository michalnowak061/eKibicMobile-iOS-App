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
        dataModel.htmlSourceCode = nil
        
        var timerCounter = 0
        let timeoutTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            timerCounter += 1
        }
        
        afQueue.async {
            while self.afSession.htmlSourceCode == nil && self.afSession.htmlSourceCode != "error" {
                if timerCounter >= 60 {
                    self.presentTimeoutError()
                    break
                }
                usleep(100000)
            }
            if self.afSession.htmlSourceCode != "error" {
                dataModel.htmlSourceCode = self.afSession.htmlSourceCode
                dataModel.update()
                self.updateView()
            }
            else {
                self.presentServerError()
            }
            timeoutTimer.invalidate()
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
