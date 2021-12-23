//
//  Event.swift
//  Balloon
//
//  Created by Oto Brglez on 23/12/2021.
//

import Foundation

struct BusInfo: Codable {
    let bus_id: UUID
    var bus_name: String
    let bus_group: String
    let lat: Double
    let lng: Double
    let rotation: Double
    let velocity: Double
}

struct Event: Codable {
    enum Kind: String, Codable {
        case Added, Updated, Removed
    }
    
    struct EventData: Codable {
        let busInfo: BusInfo
        let previous: BusInfo?
    }
    
    let kind: Kind
    let id: UUID
    let created_at: Date
    let data: EventData
    
    static func fromText(text: String) -> Event {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let event = try! decoder.decode(Event.self, from: text.data(using: .utf8)!)
        return event
    }
}
