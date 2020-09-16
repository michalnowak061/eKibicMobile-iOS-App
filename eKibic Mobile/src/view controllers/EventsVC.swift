//
//  EventsVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 16/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {
    var afSession = AlamofireSession()
    var afQueue = DispatchQueue.init(label: "afQueue")
    var viewQueue = DispatchQueue.main
    var hostsImages: [UIImage] = []
    var opponentsImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        downloadData()
    }
    
    private func updateView() {
        viewQueue.sync {
            switch dataModel.state {
            case .SignIn:
                presentSignInVC()
                break
            case .BuyTicket:
                presentDataVC()
                break
            case .MyTickets:
                break
            case .ForSale:
                break
            case .Null:
                break
            }
            
            eventsCollectionView.reloadData()
        }
    }
    
    private func downloadData() {
        // Download HTML code queue
        afQueue.async {
            self.afSession.dowloadHtmlSourceCode(url: dataModel.eKibicURL["forSale"] ?? "")
            
            while self.afSession.htmlSourceCode == nil {
                sleep(1)
                print("pobieram...")
            }
            
            if self.afSession.htmlSourceCode != "error" {
                dataModel.htmlSourceCode = self.afSession.htmlSourceCode
            }
            else {
                print("Error - downloadData")
            }
            
            dataModel.update()
        }
        // Download images Queue
        afQueue.async {
            for event in dataModel.events {
                guard event.opponentImgLink != nil else {
                    return
                }
                self.afSession.downloadImage(url: event.opponentImgLink!)
                while self.afSession.image == nil {
                    sleep(1)
                    print("pobieram obrazek...")
                }
                self.opponentsImages.append(self.afSession.image!)
                self.afSession.image = nil
                
                self.afSession.downloadImage(url: event.hostImgLink!)
                while self.afSession.image == nil {
                    sleep(1)
                    print("pobieram obrazek...")
                }
                self.hostsImages.append(self.afSession.image!)
                self.afSession.image = nil
            }
    
            self.updateView()
        }
    }

    @IBOutlet weak var eventsCollectionView: UICollectionView!
}

extension EventsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}

extension EventsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCVC", for: indexPath) as! EventCVC
        
        cell.nameLabel.text = dataModel.events[indexPath.row].name
        cell.dateLabel.text = dataModel.events[indexPath.row].date
        cell.timeLabel.text = dataModel.events[indexPath.row].time
        cell.hostImageView.image = hostsImages[indexPath.row]
        cell.hostNameLabel.text = dataModel.events[indexPath.row].host
        cell.opponentImageView.image = opponentsImages[indexPath.row]
        cell.opponontNameLabel.text = dataModel.events[indexPath.row].opponent
        
        return cell
    }
}
