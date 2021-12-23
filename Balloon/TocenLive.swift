//
//  TocenLive.swift
//  Balloon
//
//  Created by Oto Brglez on 23/12/2021.
//
import SwiftUI
import Foundation
import Starscream

struct Event: Codable {
    enum Kind: String, Codable {
        case Added, Updated, Removed
    }
    
    struct BusInfo: Codable {
        let bus_id: UUID
        let bus_name: String
        let bus_group: String
        let lat: Double
        let lng: Double
        let rotation: Double
        let velocity: Double
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

class TocenLive: ObservableObject, WebSocketDelegate {
    @Published private(set) var isConnected = false
    @Published private(set) var events: [Event] = []
    
    private var socket: WebSocket!
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("Websocket connected \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("Disconnected \(code) - \(reason)")
        case .text(let text):
            self.receivedText(text: text)
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            receivedError(error: error)
        case .binary(let data):
            print("Received binary data: \(data.count)")
        }
    }
    
    private func receivedText(text: String) {
        let event = Event.fromText(text: text)
        self.events.append(event)
    }
    
    private func receivedError(error: Error?) {
        print(error!)
    }
    
    func connect() {
        guard isConnected == false else {
            print("Already connected")
            return
        }
        
        let tocenLiveEndpoint = "http://tocen-live.pinkstack.com:8077/ws/changes"
        socket = WebSocket(request: URLRequest(url: URL(string: tocenLiveEndpoint)!, timeoutInterval: 3))
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        guard isConnected == false else {
            print("Not connected.")
            return
        }
        
        socket.disconnect()
    }
}
