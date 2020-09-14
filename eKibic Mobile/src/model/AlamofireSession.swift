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
    
    public func dowloadHtmlSourceCode(url: String) {
        afHandle.request(url).responseString { response in
            if let html = String(bytes: response.data!, encoding: String.Encoding.utf8) {
                self.htmlSourceCode = html
            }
            else {
                self.htmlSourceCode = "error"
            }
        }
    }
}
