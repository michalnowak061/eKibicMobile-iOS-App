//
//  UIControllerViewExtensions.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 14/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

public extension UIViewController {
    func presentMainVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
        
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.modalTransitionStyle = .crossDissolve
        
        present(mainVC, animated: false, completion: nil)
    }
    
    func presentSignInVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        
        signInVC.modalPresentationStyle = .fullScreen
        signInVC.modalTransitionStyle = .crossDissolve
        
        present(signInVC, animated: false, completion: nil)
    }
    
    func presentEventsVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventsVC = storyboard.instantiateViewController(withIdentifier: "EventsVC")
        
        eventsVC.modalPresentationStyle = .fullScreen
        eventsVC.modalTransitionStyle = .coverVertical
        
        present(eventsVC, animated: false, completion: nil)
    }
    
    func presentDataVC(title: String, url: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dataVC = storyboard.instantiateViewController(withIdentifier: "DataVC") as! DataVC
        
        dataVC.modalPresentationStyle = .fullScreen
        dataVC.modalTransitionStyle = .coverVertical
        dataVC.barPrompt = title
        dataVC.url = url
        
        present(dataVC, animated: false, completion: nil)
    }
    
    func presentTimeoutError() {
        let alert = UIAlertController(title: "Przekroczono limit czasu żądania", message: "Przekroczono limit czasu żądania", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Odśwież", style: .default, handler: {action in
            self.viewDidLoad()
        }))
        self.present(alert, animated: true)
    }
    
    func presentServerError() {
        let alert = UIAlertController(title: "Brak połączenia", message: "Brak połączenia z serwisem ekibic.zaglebie.com.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Odśwież", style: .default, handler: {action in
            self.viewDidLoad()
        }))
        self.present(alert, animated: true)
    }
}

