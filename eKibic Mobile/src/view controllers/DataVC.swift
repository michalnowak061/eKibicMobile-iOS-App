//
//  DataVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 14/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class DataVC: UIViewController {
    var viewQueue = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = dataModel.htmlSourceCode
        //dataModel.printDataModel()
    }
    
    private func updateView() {
        viewQueue.sync {
            switch dataModel.state {
            case DataModelState.SignIn:
                presentSignInVC()
                break
            case DataModelState.BuyTicket:
                break
            case DataModelState.Null:
                break
            }
        }
    }
    
    @IBOutlet weak var textView: UITextView!
}
