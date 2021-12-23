//
//  TocenLive.swift
//  Balloon
//
//  Created by Oto Brglez on 23/12/2021.
//
import Foundation
import Starscream

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
