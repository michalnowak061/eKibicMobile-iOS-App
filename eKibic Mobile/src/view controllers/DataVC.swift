//
//  DataVC.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 19/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import UIKit

class DataVC: UIViewController {
    var url: String = ""
    var barPrompt: String = ""
    
    var subViewControllers: [UIViewController] = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StadiumDataVC") as! StadiumDataVC,
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SectorsDataVC") as! SectorsDataVC
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
        pageControll.numberOfPages = subViewControllers.count
        scrollView.delegate = self
        scrollView.contentSize.height = 0
    }
    
    private func loadSubViews() {
        let firstSubView = subViewControllers[0] as! StadiumDataVC
        let secondSubView = subViewControllers[1] as! SectorsDataVC
        firstSubView.url = url
        firstSubView.barPrompt = barPrompt
        secondSubView.url = url
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
}

extension DataVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControll.currentPage = Int(pageNumber)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //updateSubViews()
    }
}
