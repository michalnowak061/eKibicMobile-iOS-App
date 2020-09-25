//
//  Sector.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 22/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import Foundation

struct Sector {
    var name: String = ""
    var freePlaces: Int = 0
    var capacityScaleFactor: Float = 1.0
    var maxCapacity: Int = 0
    var capacity: Int {
        get {
            return Int(ceil(Float(maxCapacity) * capacityScaleFactor))
        }
    }
    var occupiedPlaces: Int {
        get {
            let occupied = capacity - freePlaces
            return occupied >= 0 ? occupied : 0
        }
    }
    var infill: Float {
        get {
            guard capacity != 0 else {
                return 0
            }
            let infill = Float(occupiedPlaces) / Float(capacity)
            return infill
        }
    }
    var isOpen: Bool = false
    var isLoaded: Bool = false
    var color: (r: Int, g: Int, b: Int) = (0, 0, 0)
    var link: String? = nil
    var htmlSourceCode: String? = nil
}
