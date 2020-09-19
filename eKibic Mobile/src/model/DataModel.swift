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
    var sectorsDictionary = [
        "A1": Sector.init(name: "A1", capacity: 0, freePlaces: 0, isOpen: false, color: (205, 123, 42)),
        "A2": Sector.init(name: "A2", capacity: 0, freePlaces: 0, isOpen: false, color: (205, 123, 42)),
        "B1": Sector.init(name: "B1", capacity: 0, freePlaces: 0, isOpen: false, color: (112, 169, 65)),
        "B2": Sector.init(name: "B2", capacity: 0, freePlaces: 0, isOpen: false, color: (112, 169, 65)),
        "C": Sector.init(name: "C", capacity: 0, freePlaces: 0, isOpen: false, color: (66, 135, 67)),
        "D": Sector.init(name: "D", capacity: 0, freePlaces: 0, isOpen: false, color: (53, 103, 170)),
        "E1": Sector.init(name: "E1", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "E2": Sector.init(name: "E2", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "E3": Sector.init(name: "E3", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "F0": Sector.init(name: "F0", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "F1": Sector.init(name: "F1", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "F2": Sector.init(name: "F2", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "F3": Sector.init(name: "F3", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "G": Sector.init(name: "G", capacity: 0, freePlaces: 0, isOpen: false, color: (66, 135, 67)),
        "H1": Sector.init(name: "H1", capacity: 0, freePlaces: 0, isOpen: false, color: (53, 103, 170)),
        "H2": Sector.init(name: "H2", capacity: 0, freePlaces: 0, isOpen: false, color: (208, 87, 45)),
        "VIP1": Sector.init(name: "VIP1", capacity: 0, freePlaces: 0, isOpen: false, color: (92, 93, 94)),
        "VIP2": Sector.init(name: "VIP2", capacity: 0, freePlaces: 0, isOpen: false, color: (121, 121, 121)),
        "SUPER VIP": Sector.init(name: "SUPER VIP", capacity: 0, freePlaces: 0, isOpen: false, color: (151, 111, 63)),
        "OS NIEP": Sector.init(name: "OS NIEP", capacity: 0, freePlaces: 0, isOpen: false, color: (66, 142, 203)),
        "PRASA": Sector.init(name: "PRASA", capacity: 0, freePlaces: 0, isOpen: false, color: (27, 28, 27))
    ]
    let sectorsDictionaryKeys = [ "A1", "A2",
                                  "B1", "B2",
                                  "C", "D",
                                  "E1", "E2", "E3", "F0", "F1", "F2", "F3",
                                  "G", "H1", "H2",
                                  "VIP1", "VIP2", "SUPER VIP",
                                  "OS NIEP", "PRASA"
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
                sectorsDictionary[sectorName]?.freePlaces = 0
                sectorsDictionary[sectorName]?.isOpen = false
            }
            else {
                var startIndex = sectorData.range(of: "Wolnych miejsc: ")?.upperBound
                var endIndex = sectorData.range(of: "</span></a>")?.lowerBound
                let freePlaces: Int = Int(String(sectorData[startIndex!..<endIndex!])) ?? 0
                
                startIndex = sectorData.range(of: "href=\"")?.upperBound
                endIndex = sectorData.range(of: "style=\"white-space: normal;\"")?.lowerBound
                let linkData = String(sectorData[startIndex!..<endIndex!])
                
                startIndex = linkData.range(of: "/BuyTicket/SeatsSelect?sectorId=")?.upperBound
                endIndex = linkData.range(of: "\"")?.lowerBound
                let link = String(linkData[startIndex!..<endIndex!])
                
                sectorsDictionary[sectorName]?.freePlaces = freePlaces
                sectorsDictionary[sectorName]?.isOpen = true
                sectorsDictionary[sectorName]?.link = "https://ekibic.zaglebie.com/BuyTicket/SeatsSelect?sectorId=" + link
            }
            sectorsDictionary[sectorName]?.isLoaded = true
        }
        
        func parseMoreSectorData(sectorName: String) {
            let sectorData = sectorsDictionary[sectorName]?.htmlSourceCode
            
            guard sectorData != nil && sectorsDictionary[sectorName]?.link != nil else {
                return
            }
            
            var capacity = 0
            
            sectorData!.enumerateLines { (line, _) in
                if line.contains("unselectable=\"on\"") {
                    capacity += 1
                }
            }
            sectorsDictionary[sectorName]?.capacity = capacity
        }
        
        if sectorsDictionary["SUPER VIP"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_121_266\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_47\">")?.lowerBound
            parseSectorData(sectorName: "SUPER VIP", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "SUPER VIP")
        }
        if sectorsDictionary["VIP1"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_47\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_268\">")?.lowerBound
            parseSectorData(sectorName: "VIP1", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "VIP1")
        }
        if sectorsDictionary["VIP2"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_268\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_267\">")?.lowerBound
            parseSectorData(sectorName: "VIP2", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "VIP2")
        }
        if sectorsDictionary["PRASA"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_122_267\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_29\">")?.lowerBound
            parseSectorData(sectorName: "PRASA", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "PRASA")
        }
        if sectorsDictionary["A1"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_29\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_48\">")?.lowerBound
            parseSectorData(sectorName: "A1", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "A1")
        }
        if sectorsDictionary["A2"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_123_48\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_46\">")?.lowerBound
            parseSectorData(sectorName: "A2", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "A2")
        }
        if sectorsDictionary["B1"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_46\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_269\">")?.lowerBound
            parseSectorData(sectorName: "B1", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "B1")
        }
        if sectorsDictionary["B2"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_125_269\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_271\">")?.lowerBound
            parseSectorData(sectorName: "B2", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "B2")
        }
        if sectorsDictionary["E3"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_271\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_272\">")?.lowerBound
            parseSectorData(sectorName: "E3", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "E3")
        }
        if sectorsDictionary["F2"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_272\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_273\">")?.lowerBound
            parseSectorData(sectorName: "F2", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "F2")
        }
        if sectorsDictionary["F3"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_273\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_270\">")?.lowerBound
            parseSectorData(sectorName: "F3", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "F3")
        }
        if sectorsDictionary["E2"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_270\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_43\">")?.lowerBound
            parseSectorData(sectorName: "E2", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "E2")
        }
        if sectorsDictionary["E1"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_43\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_42\">")?.lowerBound
            parseSectorData(sectorName: "E1", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "E1")
        }
        if sectorsDictionary["F0"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_42\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_1020\">")?.lowerBound
            parseSectorData(sectorName: "F0", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "F0")
        }
        if sectorsDictionary["F1"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_1020\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_45\">")?.lowerBound
            parseSectorData(sectorName: "F1", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "F1")
        }
        if sectorsDictionary["C"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_45\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_274\">")?.lowerBound
            parseSectorData(sectorName: "C", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "C")
        }
        if sectorsDictionary["H2"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_274\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_40\">")?.lowerBound
            parseSectorData(sectorName: "H2", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "H2")
        }
        if sectorsDictionary["H1"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_124_40\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_127_44\">")?.lowerBound
            parseSectorData(sectorName: "H1", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "H1")
        }
        if sectorsDictionary["D"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_127_44\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_41\">")?.lowerBound
            parseSectorData(sectorName: "D", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "D")
        }
        if sectorsDictionary["G"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_41\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_283\">")?.lowerBound
            parseSectorData(sectorName: "G", startIndex: sIndex!, endIndex: eIndex!)
        }
        else {
            parseMoreSectorData(sectorName: "G")
        }
        if sectorsDictionary["OS NIEP"]?.isLoaded == false {
            let sIndex = htmlSourceCode!.range(of: "<div class=\"stadium_map_sector_small col-xs-6 col-sm-6\" id=\"sectorButtonDiv_126_283\">")?.lowerBound
            let eIndex = htmlSourceCode!.range(of: "Podgląd mapy stadionu")?.lowerBound
            parseSectorData(sectorName: "OS NIEP", startIndex: sIndex!, endIndex: eIndex!)
        } else {
            parseMoreSectorData(sectorName: "OS NIEP")
        }
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
        var name = ""
        var capacity = 0
        var freePlaces = 0
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
        var isOpen = false
        var isLoaded = false
        var color: (r: Int, g: Int, b: Int) = (0, 0, 0)
        var link: String? = nil
        var htmlSourceCode: String? = nil
    }
}
