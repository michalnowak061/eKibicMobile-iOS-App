//
//  DataVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 14/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class DataVC: UIViewController {
    var afSession = AlamofireSession()
    var afQueue = DispatchQueue.init(label: "afQueue")
    var viewQueue = DispatchQueue.main
    var url: String = dataModel.eKibicURL["home"] ?? ""
    var barTitle: String = ""
    var sectors: [DataModel.Sector] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sectorsCollectionView.delegate = self
        sectorsCollectionView.dataSource = self
        downloadData(url: url)
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
                break
            case .ForSale:
                break
            case .Null:
                break
            }
            
            sectorsCollectionView.reloadData()
            navigationBar.topItem?.title = barTitle
        }
    }
    
    private func downloadData(url: String) {
        afSession.dowloadHtmlSourceCode(url: url)
        
        afQueue.async {
            while self.afSession.htmlSourceCode == nil {
                usleep(100000)
                print("pobieram...")
            }
            
            if self.afSession.htmlSourceCode != "error" {
                dataModel.htmlSourceCode = self.afSession.htmlSourceCode
            }
            else {
                print("Error - downloadData")
            }
            
            dataModel.update()
            self.loadSectorsFromDictionary()
            self.updateView()
        }
    }
    
    private func loadSectorsFromDictionary() {
        for sector in dataModel.sectorsDictionary {
            sectors.append(sector.value)
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var sectorsCollectionView: UICollectionView!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DataVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(sectors.count)
        return sectors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectorCVC", for: indexPath) as! SectorCVC
        
        cell.nameLabel.text = sectors[indexPath.row].name
        cell.capacityLabel.text = String(sectors[indexPath.row].capacity)
        cell.freePlacesLabel.text = String(sectors[indexPath.row].freePlaces)
        cell.occupiedPlacesLabel.text = String(sectors[indexPath.row].occupiedPlaces)
        cell.backgroundColor = UIColor.rgb(red: CGFloat(sectors[indexPath.row].color.0),
                                           green: CGFloat(sectors[indexPath.row].color.1),
                                           blue: CGFloat(sectors[indexPath.row].color.2))
        
        return cell
    }
}
