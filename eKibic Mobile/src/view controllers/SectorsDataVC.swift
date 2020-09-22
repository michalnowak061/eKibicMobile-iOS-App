//
//  DataVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 14/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class SectorsDataVC: UIViewController {
    var barPrompt: String = ""
    var sectors: [Sector] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        sectorsCollectionViewSetup()
        loadSectorsFromDictionary()
        updateView()
    }
    
    private func navigationBarSetup() {
        navigationBar.topItem?.prompt = barPrompt
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.rgb(red: 208, green: 87, blue: 45)
        navigationBar.backgroundColor = UIColor.rgb(red: 208, green: 87, blue: 45)
        navigationBar.tintColor = UIColor.rgb(red: 208, green: 87, blue: 45)
    }
    
    private func sectorsCollectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.25)
        
        self.sectorsCollectionView.collectionViewLayout = layout
        self.sectorsCollectionView.delegate = self
        self.sectorsCollectionView.dataSource = self
    }
    
    private func updateView() {
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
    }
    
    private func loadSectorsFromDictionary() {
        sectors = []
        for key in dataModel.sectorsDictionaryKeys {
            sectors.append(dataModel.sectorsDictionary[key]!)
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var sectorsCollectionView: UICollectionView!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SectorsDataVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectorCVC", for: indexPath) as! SectorCVC
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.backgroundColor = UIColor.rgb(red: CGFloat(sectors[indexPath.row].color.0),
                                           green: CGFloat(sectors[indexPath.row].color.1),
                                           blue: CGFloat(sectors[indexPath.row].color.2))
        
        cell.nameLabel.text = sectors[indexPath.row].name
        cell.capacityLabel.text = String(sectors[indexPath.row].capacity)
        cell.freePlacesLabel.text = String(sectors[indexPath.row].freePlaces)
        cell.occupiedPlacesLabel.text = String(sectors[indexPath.row].occupiedPlaces)
        cell.sectorInfillProgressView.progress = sectors[indexPath.row].infill
        cell.sectorInfillLabel.text = String(format: "%.2f", sectors[indexPath.row].infill * 100) + "%"
        
        return cell
    }
}
