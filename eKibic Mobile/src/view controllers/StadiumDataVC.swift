//
//  StadiumDataVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 19/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class StadiumDataVC: UIViewController {
    var afSession = AlamofireSession()
    var afQueue = DispatchQueue.init(label: "afQueue")
    var viewQueue = DispatchQueue.main
    var url: String = ""
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
        activityIndicatorView.isHidden = true
        navigationBarSetup()
    }
    
    private func updateView() {
        guard dataModel.stadium != nil else {
            return
        }
        viewQueue.async {
            self.stadiumCapacityLabel.text = String(dataModel.stadium!.capacity)
            self.stadiumOccupiedPlacesLabel.text = String(dataModel.stadium!.occupiedPlaces)
            self.stadiumFreePlacesLabel.text = String(dataModel.stadium!.freePlaces)
            
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    private func downloadData(url: String) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        // Sectors data Queue
        afQueue.async {
            self.afSession.htmlSourceCode = nil
            self.afSession.dowloadHtmlSourceCode(url: url)
            
            while self.afSession.htmlSourceCode == nil {
                usleep(1000)
            }
            if self.afSession.htmlSourceCode != "error" {
                dataModel.htmlSourceCode = self.afSession.htmlSourceCode
            }
            else {
                print("Error - downloadData")
            }
            dataModel.update()
        }
        // More Sectors data Queue
        afQueue.async {
            for sector in dataModel.stadium!.sectors {
                if let link = sector.value.link {
                    self.afSession.htmlSourceCode = nil
                    self.afSession.dowloadHtmlSourceCode(url: link)
                    
                    while self.afSession.htmlSourceCode == nil {
                        usleep(1000)
                    }
                    if self.afSession.htmlSourceCode != "error" {
                        dataModel.sectorsDictionary[sector.value.name]?.htmlSourceCode = self.afSession.htmlSourceCode
                    }
                    else {
                        print("Error - downloadData")
                    }
                }
            }
            dataModel.update()
            self.updateView()
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var stadiumCapacityLabel: UILabel!
    @IBOutlet weak var stadiumOccupiedPlacesLabel: UILabel!
    @IBOutlet weak var stadiumFreePlacesLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        downloadData(url: url)
    }
}
