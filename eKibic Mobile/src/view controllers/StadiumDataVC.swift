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
    var url: String = dataModel.eKibicURL["home"] ?? ""
    var barPrompt: String = ""
    
    override func viewDidLoad() {
        viewSetup()
        super.viewDidLoad()
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
        
        navigationBarSetup()
    }
    
    private func updateView() {
        
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
