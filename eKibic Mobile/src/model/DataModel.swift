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
    case MyTickets
    case ForSale
}

struct DataModel {
    let eKibicURL = [
        "main": "https://ekibic.zaglebie.com/Home",
        "signIn": "https://ekibic.zaglebie.com/Account/Login/loginLink",
        "myTickets": "https://ekibic.zaglebie.com/Home/MyTickets",
        "forSale": "https://ekibic.zaglebie.com/Home/ForSale"
    ]
    var htmlSourceCode: String?
    var state: DataModelState = DataModelState.Null
    var events: [Event] = []
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
        "OS NIEP": Sector.init(name: "OS NIEP", capacity: 0, freePlaces: 0, isOpen: false),
        "Prasa": Sector.init(name: "Prasa", capacity: 0, freePlaces: 0, isOpen: false)
    ]
    
    public mutating func update() {
        checkHtmlSourceCode()
    
        switch state {
        case .SignIn:
            break
        case .BuyTicket:
            parseSectorsData()
            break
        case .MyTickets:
            break
        case .ForSale:
            parseEventsData()
            break
        case .Null:
            break
        }
    }
    
    private mutating func checkHtmlSourceCode() {
        guard htmlSourceCode != nil else {
            state = .Null
            return
        }
        if htmlSourceCode!.contains("Bilety Online - Logowanie") {
            state = .SignIn
        }
        if htmlSourceCode!.contains("Bilety Online - Kup bilet") {
            state = .BuyTicket
        }
        if htmlSourceCode!.contains("Bilety Online - Moje bilety") {
            state = .MyTickets
        }
        if htmlSourceCode!.contains("Bilety Online - W sprzedaży") {
            state = .ForSale
        }
    }
    
    private mutating func parseEventsData() {
    
        func findFirstSubstringIndex(string: String, substring: String) -> Int? {
            var index = 0
            
            for char in string {
                if char == substring.first {
                    let startOfFoundCharacter = string.index(string.startIndex, offsetBy: index)
                    let lengthOfFoundCharacter = string.index(string.startIndex, offsetBy: (substring.count + index))
                    
                    if string[startOfFoundCharacter..<lengthOfFoundCharacter] == substring {
                        return index
                    }
                }
                index += 1
            }
            return nil
        }
        
        func parseEventData(startIndex: Int?, endIndex: Int?) {
            guard htmlSourceCode != nil && startIndex != nil && endIndex != nil else {
                return
            }
            
            let eventData = htmlSourceCode![startIndex!..<endIndex!]
            
            var startIndex = eventData.range(of: "<h5>")?.upperBound
            var endIndex = eventData.range(of: "<div class=\"date\">")?.lowerBound
            let nameData = eventData[startIndex!..<endIndex!]
            
            endIndex = nameData.range(of: "</h5>")?.lowerBound
            let name = nameData[..<endIndex!]
            
            startIndex = eventData.range(of: "<div class=\"date\">")?.upperBound
            endIndex = eventData.range(of: "<div class=\"p2\">")?.lowerBound
            let dateData = eventData[startIndex!..<endIndex!]
            
            startIndex = dateData.range(of: "<div class=\"p1\">")?.upperBound
            endIndex = dateData.range(of: "</div>")?.lowerBound
            let date = dateData[startIndex!..<endIndex!]
            
            startIndex = eventData.range(of: "<div class=\"p2\">")?.upperBound
            endIndex = eventData.range(of: "<div class=\"match\">")?.lowerBound
            let timeData = eventData[startIndex!..<endIndex!]
            
            endIndex = timeData.range(of: "</div>")?.lowerBound
            let time = timeData[..<endIndex!]
            
            startIndex = eventData.range(of: "<div class=\"c1\">")?.upperBound
            endIndex = eventData.range(of: "<div class=\"c2\">")?.lowerBound
            let hostData = eventData[startIndex!..<endIndex!]
            
            startIndex = hostData.range(of: "alt=\"")?.upperBound
            endIndex = hostData.range(of: "\" />")?.lowerBound
            let host = eventData[startIndex!..<endIndex!]
            
            startIndex = hostData.range(of: "<img src=\"")?.upperBound
            endIndex = hostData.range(of: "\" alt")?.lowerBound
            let hostImgLink = "https://ekibic.zaglebie.com" + eventData[startIndex!..<endIndex!]
            
            startIndex = eventData.range(of: "<div class=\"c2\">")?.upperBound
            endIndex = eventData.range(of: "<div class=\"bg-img\">")?.lowerBound
            let opponentData = eventData[startIndex!..<endIndex!]
            
            startIndex = opponentData.range(of: "alt=\"")?.upperBound
            endIndex = opponentData.range(of: "\" />")?.lowerBound
            let opponent = eventData[startIndex!..<endIndex!]
            
            startIndex = opponentData.range(of: "<img src=\"")?.upperBound
            endIndex = opponentData.range(of: "\" alt")?.lowerBound
            let opponentImgLink = "https://ekibic.zaglebie.com" + eventData[startIndex!..<endIndex!]
            
            startIndex = eventData.range(of: "<a href=\"")?.upperBound
            endIndex = eventData.range(of: "\" class=\"btn btn-primary\"")?.lowerBound
            let link = "https://ekibic.zaglebie.com" + String(eventData[startIndex!..<endIndex!])
            
            let event = Event(name: String(name), date: String(date), time: String(time),host: String(host), hostImgLink: String(hostImgLink), opponent: String(opponent), opponentImgLink: String(opponentImgLink), link: String(link))
            events.append(event)
        }
        
        let sIndex = findFirstSubstringIndex(string: htmlSourceCode!, substring: "item-event\">")
        let eIndex = findFirstSubstringIndex(string: htmlSourceCode!, substring: "role=\"button\">Kup bilet</a>")
        parseEventData(startIndex: sIndex, endIndex: eIndex)
    }
    
    private mutating func parseSectorsData() {
        func parseSectorData(sectorName: String, startIndex: String.Index?, endIndex: String.Index?) {
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
        
        var sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_121_266\">")?.lowerBound
        var eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_47\">")?.lowerBound
        parseSectorData(sectorName: "SUPER VIP", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_47\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_268\">")?.lowerBound
        parseSectorData(sectorName: "VIP1", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_268\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_267\">")?.lowerBound
        parseSectorData(sectorName: "VIP2", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_267\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_29\">")?.lowerBound
        parseSectorData(sectorName: "PRASA", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_29\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_48\">")?.lowerBound
        parseSectorData(sectorName: "A1", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_48\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_46\">")?.lowerBound
        parseSectorData(sectorName: "A2", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_46\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_269\">")?.lowerBound
        parseSectorData(sectorName: "B1", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_269\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_271\">")?.lowerBound
        parseSectorData(sectorName: "B2", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_271\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_272\">")?.lowerBound
        parseSectorData(sectorName: "E3", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_272\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_273\">")?.lowerBound
        parseSectorData(sectorName: "F2", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_273\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_270\">")?.lowerBound
        parseSectorData(sectorName: "F3", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_270\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_43\">")?.lowerBound
        parseSectorData(sectorName: "E2", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_43\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_42\">")?.lowerBound
        parseSectorData(sectorName: "E1", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_42\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_1020\">")?.lowerBound
        parseSectorData(sectorName: "F0", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_1020\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_45\">")?.lowerBound
        parseSectorData(sectorName: "F1", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_45\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_274\">")?.lowerBound
        parseSectorData(sectorName: "C", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_274\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_40\">")?.lowerBound
        parseSectorData(sectorName: "H2", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_40\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_127_44\">")?.lowerBound
        parseSectorData(sectorName: "H1", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_127_44\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_41\">")?.lowerBound
        parseSectorData(sectorName: "D", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_41\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_283\">")?.lowerBound
        parseSectorData(sectorName: "G", startIndex: sIndex!, endIndex: eIndex!)
        
        sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_283\">")?.lowerBound
        eIndex = htmlSourceCode!.range(of: "Podgląd mapy stadionu")?.lowerBound
        parseSectorData(sectorName: "OS NIEP", startIndex: sIndex!, endIndex: eIndex!)
    }
}

extension DataModel {
    struct Event {
        var name: String?
        var date: String?
        var time: String?
        var host: String?
        var hostImgLink: String?
        var opponent: String?
        var opponentImgLink: String?
        var link: String?
    }
    
    struct Sector {
        var name: String!
        var capacity: Int!
        var freePlaces: Int?
        var isOpen: Bool?
    }
}
