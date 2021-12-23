//
//  TocenLive.swift
//  Balloon
//
//  Created by Oto Brglez on 23/12/2021.
//
import Foundation
import Starscream
import Combine

let TOCEN_LIVE_CHANGES_ENDPOINT = "ws://tocen-live.pinkstack.com:8077/ws/changes"

class TocenLive: ObservableObject, WebSocketDelegate {
    @Published private(set) var isConnected = false
    private(set) var currentEvent = PassthroughSubject<Event, Never>()

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
        self.currentEvent.send(Event.fromText(text: text))
    }
    
    private func receivedError(error: Error?) {
        print(error!)
    }
    
    func connect() {
        guard isConnected == false else {
            print("Already connected.")
            return
        }
        
        socket = WebSocket(request: URLRequest(url: URL(string: TOCEN_LIVE_CHANGES_ENDPOINT)!, timeoutInterval: 3))
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
