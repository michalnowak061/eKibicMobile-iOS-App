//
//  DataVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 19/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class DataVC: UIViewController {
    var afSession = AlamofireSession()
    var afQueue = DispatchQueue.init(label: "afQueue")
    var viewQueue = DispatchQueue.main
    var url: String = ""
    var barPrompt: String = ""
    
    var subViewControllers: [UIViewController] = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StadiumDataVC") as! StadiumDataVC,
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectorsDataVC") as! SectorsDataVC
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControll.isHidden = true
        pageControll.numberOfPages = subViewControllers.count
        scrollView.delegate = self
        scrollView.contentSize.height = 0
        downloadData(url: url)
    }
    
    private func updateView() {
        viewQueue.sync {
            self.loadSubViews()
            
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            self.pageControll.isHidden = false
        }
    }
    
    private func loadSubViews() {
        let firstSubView = subViewControllers[0] as! StadiumDataVC
        let secondSubView = subViewControllers[1] as! SectorsDataVC
        firstSubView.barPrompt = barPrompt
        secondSubView.barPrompt = barPrompt
        
        var frame = CGRect.zero
        for index in 0..<subViewControllers.count {
            let subView = subViewControllers[index]
            
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            subView.view.frame = frame

            subView.willMove(toParent: self)
            addChild(subView)
            subView.didMove(toParent: self)
            scrollView.addSubview(subView.view)
        }
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(subViewControllers.count)), height: scrollView.frame.size.height)
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
                self.presentServerError()
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
                        self.presentServerError()
                        break
                    }
                }
            }
            
            if self.afSession.htmlSourceCode != "error" {
                dataModel.update()
                self.updateView()
            }
        }
    }
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
}

extension DataVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControll.currentPage = Int(pageNumber)
    }
}
