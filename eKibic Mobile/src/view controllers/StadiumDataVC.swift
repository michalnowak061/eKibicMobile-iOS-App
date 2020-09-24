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
        dismiss(animated: true, completion: nil)
    }
}
