//
//  UIControllerViewExtensions.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 14/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

public extension UIViewController {
    func presentSignInVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        
        signInVC.modalPresentationStyle = .fullScreen
        signInVC.modalTransitionStyle = .crossDissolve
        
        present(signInVC, animated: true, completion: nil)
    }
    
    func presentEventsVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventsVC = storyboard.instantiateViewController(withIdentifier: "EventsVC")
        
        eventsVC.modalPresentationStyle = .fullScreen
        eventsVC.modalTransitionStyle = .crossDissolve
        
        present(eventsVC, animated: true, completion: nil)
    }
    
    func presentDataVC(title: String, url: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dataVC = storyboard.instantiateViewController(withIdentifier: "DataVC") as! DataVC
        
        dataVC.modalPresentationStyle = .fullScreen
        dataVC.modalTransitionStyle = .crossDissolve
        dataVC.barTitle = title
        dataVC.url = url
        
        present(dataVC, animated: true, completion: nil)
    }
}

