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
        navigationBarSetup()
        eventsCollectionViewSetup()
        downloadData()
    }
    
    private func navigationBarSetup() {
        navigationBar.barTintColor = UIColor.rgb(red: 208, green: 87, blue: 45)
        navigationBar.backgroundColor = UIColor.rgb(red: 208, green: 87, blue: 45)
        navigationBar.tintColor = UIColor.rgb(red: 208, green: 87, blue: 45)
    }
    
    private func eventsCollectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.eventsCollectionView.frame.width * 0.9,
                                 height: self.eventsCollectionView.frame.height * 0.45)
        
        self.eventsCollectionView.collectionViewLayout = layout
        self.eventsCollectionView.delegate = self
        self.eventsCollectionView.dataSource = self
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
            
            eventsCollectionView.reloadData()
            
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.loadingLabel.isHidden = true
        }
    }
    
    private func downloadData() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        loadingLabel.isHidden = false
        
        // Download HTML code queue
        afQueue.async {
            self.afSession.dowloadHtmlSourceCode(url: dataModel.eKibicURL["forSale"] ?? "")
            
            while self.afSession.htmlSourceCode == nil {
                usleep(100000)
            }
            
            if self.afSession.htmlSourceCode != "error" {
                dataModel.htmlSourceCode = self.afSession.htmlSourceCode
                dataModel.update()
            }
            else {
                self.presentServerError()
            }
        }
        // Download images Queue
        afQueue.async {
            for event in dataModel.events {
                guard event.opponentImgLink != nil else {
                    return
                }
                self.afSession.downloadImage(url: event.opponentImgLink!)
                while self.afSession.image == nil {
                    usleep(100000)
                }
                self.opponentsImages.append(self.afSession.image!)
                self.afSession.image = nil
                
                self.afSession.downloadImage(url: event.hostImgLink!)
                while self.afSession.image == nil {
                    usleep(100000)
                }
                self.hostsImages.append(self.afSession.image!)
                self.afSession.image = nil
            }
            
            self.updateView()
        }
    }
    
    private func presentServerError() {
        let alert = UIAlertController(title: "Brak połączenia", message: "Brak połączenia z serwisem ekibic.zaglebie.com.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Odśwież", style: .default, handler: {action in
            self.downloadData()
        }))
        self.present(alert, animated: true)
    }

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
}

extension EventsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCVC", for: indexPath) as! EventCVC
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.nameLabel.text = dataModel.events[indexPath.row].name
        cell.dateLabel.text = dataModel.events[indexPath.row].date
        cell.timeLabel.text = dataModel.events[indexPath.row].time
        cell.hostImageView.image = hostsImages[indexPath.row]
        cell.hostNameLabel.text = dataModel.events[indexPath.row].host
        cell.opponentImageView.image = opponentsImages[indexPath.row]
        cell.opponontNameLabel.text = dataModel.events[indexPath.row].opponent
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let link = dataModel.events[indexPath.row].link, let eventName = dataModel.events[indexPath.row].name else {
            return
        }
        presentDataVC(title: eventName, url: link)
    }
}
