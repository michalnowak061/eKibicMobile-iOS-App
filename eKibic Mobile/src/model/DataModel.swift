//
//  DataModel.swift
//  eKibic Mobile
//
//  Created by Michał Nowak on 12/09/2020.
//  Copyright © 2020 mnowak061. All rights reserved.
//

import Foundation

enum DataModelState {
    case Null
    case SignIn
    case BuyTicket
}

struct DataModel {
    let eKibicURL = [
        "main": "https://ekibic.zaglebie.com/Home",
        "signIn": "https://ekibic.zaglebie.com/Account/Login/loginLink",
        "cracovia": "https://ekibic.zaglebie.com/BuyTicket/SectorSelect?eventId=245"
    ]
    var htmlSourceCode: String?
    var state: DataModelState = DataModelState.Null
    
    var SectorsDictionary = [
        "A1": Sector.init(name: "A1", capacity: 0, freePlaces: 0, isOpen: false),
        "A2": Sector.init(name: "A2", capacity: 0, freePlaces: 0, isOpen: false),
        "B1": Sector.init(name: "B1", capacity: 0, freePlaces: 0, isOpen: false),
        "B2": Sector.init(name: "B2", capacity: 0, freePlaces: 0, isOpen: false),
        "C": Sector.init(name: "C", capacity: 0, freePlaces: 0, isOpen: false),
        "D": Sector.init(name: "D", capacity: 0, freePlaces: 0, isOpen: false),
        "E1": Sector.init(name: "E1", capacity: 0, freePlaces: 0, isOpen: false),
        "E2": Sector.init(name: "E2", capacity: 0, freePlaces: 0, isOpen: false),
        "E3": Sector.init(name: "E3", capacity: 0, freePlaces: 0, isOpen: false),
        "F0": Sector.init(name: "F0", capacity: 0, freePlaces: 0, isOpen: false),
        "F1": Sector.init(name: "F1", capacity: 0, freePlaces: 0, isOpen: false),
        "F2": Sector.init(name: "F2", capacity: 0, freePlaces: 0, isOpen: false),
        "F3": Sector.init(name: "F3", capacity: 0, freePlaces: 0, isOpen: false),
        "G": Sector.init(name: "G", capacity: 0, freePlaces: 0, isOpen: false),
        "H1": Sector.init(name: "H1", capacity: 0, freePlaces: 0, isOpen: false),
        "H2": Sector.init(name: "H2", capacity: 0, freePlaces: 0, isOpen: false),
        "VIP1": Sector.init(name: "VIP1", capacity: 0, freePlaces: 0, isOpen: false),
        "VIP2": Sector.init(name: "VIP2", capacity: 0, freePlaces: 0, isOpen: false),
        "SUPER VIP": Sector.init(name: "SUPER VIP", capacity: 0, freePlaces: 0, isOpen: false),
        "OsNiep": Sector.init(name: "OsNiep", capacity: 0, freePlaces: 0, isOpen: false),
        "Prasa": Sector.init(name: "Prasa", capacity: 0, freePlaces: 0, isOpen: false)
    ]
    
    public func printDataModel() {
        for sector in SectorsDictionary {
            print(sector)
        }
    }
    
    public mutating func update() {
        checkHtmlSourceCode()
        
        if state == DataModelState.BuyTicket {
            var sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_121_266\">")?.lowerBound
            var eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_47\">")?.lowerBound
            parseSectorData(sectorName: "SUPER VIP", startIndex: sIndex!, endIndex: eIndex!)
            
            sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_47\">")?.lowerBound
            eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_268\">")?.lowerBound
            parseSectorData(sectorName: "VIP1", startIndex: sIndex!, endIndex: eIndex!)
        }
        
        printDataModel()
    }
    
    private mutating func checkHtmlSourceCode() {
        guard htmlSourceCode != nil else {
            state = DataModelState.Null
            return
        }
        if htmlSourceCode!.contains("<title>Bilety Online - Logowanie</title>") {
            state = DataModelState.SignIn
        }
        if htmlSourceCode!.contains("<title>Bilety Online - Kup bilet | KGHM Zagłębie Lubin -") {
            state = DataModelState.BuyTicket
        }
    }
    
    private mutating func parseSectorData(sectorName: String, startIndex: String.Index?, endIndex: String.Index?) {
        guard htmlSourceCode != nil && startIndex != nil && endIndex != nil else {
            return
        }
        
        let sectorData = htmlSourceCode![startIndex!..<endIndex!]
        
        if sectorData.contains("disabled") {
            SectorsDictionary[sectorName]?.freePlaces = 0
            SectorsDictionary[sectorName]?.isOpen = false
        }
        else {
            let startIndex = sectorData.range(of: "Wolnych miejsc: ")?.upperBound
            let endIndex = sectorData.range(of: "</span></a>")?.lowerBound
            let freePlaces = sectorData[startIndex!..<endIndex!]
            SectorsDictionary[sectorName]?.freePlaces = Int(freePlaces)
            SectorsDictionary[sectorName]?.isOpen = true
        }
    }
}

extension DataModel {
    struct Event {
        var name: String!
    }
    
    struct Sector {
        var name: String!
        var capacity: Int!
        var freePlaces: Int?
        var isOpen: Bool?
    }
}
