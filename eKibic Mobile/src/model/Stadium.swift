//
//  Stadium.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 22/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import Foundation

struct Stadium {
    var sectors: [String : Sector] = [:]
    var sectorsKeys: [String] = []
    var capacity: Int {
        get {
            var capacity = 0
            for sector in sectors {
                capacity += sector.value.capacity
            }
            return capacity
        }
    }
    var freePlaces: Int {
        get {
            var freePlaces = 0
            for sector in sectors {
                freePlaces += sector.value.freePlaces
            }
            return freePlaces
        }
    }
    var occupiedPlaces: Int {
        get {
            var occupiedPlaces = 0
            for sector in sectors {
                occupiedPlaces += sector.value.occupiedPlaces
            }
            return occupiedPlaces
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
}
