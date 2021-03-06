//
//  StadiumDataVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 19/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class StadiumDataVC: UIViewController {
    var viewQueue = DispatchQueue.main
    var barPrompt: String = ""
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        updateView()
    }
    
    private func viewSetup() {
        func navigationBarSetup() {
            navigationBar.topItem?.prompt = barPrompt
            navigationBar.barStyle = .black
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBar.barTintColor = UIColor.rgb(red: 208, green: 87, blue: 45)
            navigationBar.backgroundColor = UIColor.rgb(red: 208, green: 87, blue: 45)
            navigationBar.tintColor = UIColor.rgb(red: 208, green: 87, blue: 45)
        }
        stadiumPlaneView.layer.cornerRadius = 10
        stadiumDataView.layer.cornerRadius = 10
        
        navigationBarSetup()
    }
    
    private func updateView() {
        viewQueue.async {
            guard dataModel.stadium != nil else {
                return
            }
            self.stadiumCapacityLabel.text = String(dataModel.stadium!.capacity)
            self.stadiumOccupiedPlacesLabel.text = String(dataModel.stadium!.occupiedPlaces)
            self.stadiumFreePlacesLabel.text = String(dataModel.stadium!.freePlaces)
            self.progressView.progress = dataModel.stadium!.infill
            self.progressLabel.text = String(format: "%.2f", dataModel.stadium!.infill * 100) + "%"
        }
    }
    
    @IBOutlet weak var stadiumPlaneView: UIView!
    @IBOutlet weak var stadiumDataView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var stadiumCapacityLabel: UILabel!
    @IBOutlet weak var stadiumOccupiedPlacesLabel: UILabel!
    @IBOutlet weak var stadiumFreePlacesLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        fromleftToRightAnimation()
    }
    
    @IBAction func swipeBackGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        let swipeMaxDistance = self.view.frame.size.width * 0.2
        let dismissActivationDistance = self.view.frame.size.width * 0.3
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.x - initialTouchPoint.x > 0 && touchPoint.x - initialTouchPoint.x < swipeMaxDistance {
                self.view.frame = CGRect(x: touchPoint.x - initialTouchPoint.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.x - initialTouchPoint.x > dismissActivationDistance {
                fromleftToRightAnimation()
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
