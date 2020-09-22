//
//  AlamofireSession.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 12/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireSession {
    var afHandle = AF
    var htmlSourceCode: String?
    var image: UIImage?
    
    public func dowloadHtmlSourceCode(url: String) {
        afHandle.request(url).responseString { response in
            if response.data != nil {
                if let html = String(bytes: response.data!, encoding: String.Encoding.utf8) {
                    self.htmlSourceCode = html
                }
                else {
                    self.htmlSourceCode = "error"
                }
            }
            else {
                self.htmlSourceCode = "error"
            }
        }
    }
    
    public func downloadImage(url: String) {
        afHandle.request(url).response { response in
            guard response.data != nil else {
                return
            }
            self.image = UIImage(data: response.data!, scale:1)
        }
    }
}
