//
//  ContentView.swift
//  Balloon
//
//  Created by Oto Brglez on 22/12/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tocenLive: TocenLive

    func printKind(kind: Event.Kind) -> String {
        switch kind {
            case .Added: return "Added"
            case .Removed: return "Removed"
            case .Updated: return "Updated"
        }
    }
    
    var body: some View {
        ScrollView {
            ForEach(tocenLive.events.reversed(), id:\.id) { event in
                VStack {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("\(event.data.busInfo.bus_name) @ \(event.data.busInfo.bus_group)")
                            .bold()
                    }
                    HStack {
                        Text("\(printKind(kind: event.kind))")
                        Text(event.created_at, style: .time)
                        Text(String(format:"%.2f km/h", event.data.busInfo.velocity))
                        
                    }
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom)
                        .foregroundColor(Color.purple)
                }
                // .padding()
            }
            
            if (tocenLive.events.count == 0) {
                VStack(alignment: .center, spacing: 1.1) {
                    Text("Waiting for events,...")
                }
            }
        }
        .onAppear(perform: onApear)
        .onDisappear(perform: onDisappear)
    }
    
    func onApear() {
        tocenLive.connect()
    }
    
    func onDisappear() {
        tocenLive.disconnect()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
