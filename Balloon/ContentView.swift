//
//  ContentView.swift
//  Balloon
//
//  Created by Oto Brglez on 22/12/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tocenLive: TocenLive

    
    var body: some View {
        ScrollView {
            ForEach(tocenLive.events.reversed(), id:\.id) { event in
                VStack {
                    HStack {
                        Image(systemName: "bus")
                        Text("\(event.data.busInfo.bus_name)").font(.title)
                    }
                    HStack {
                        Text(event.created_at, style: .time)
                    }
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom)
                        .foregroundColor(Color.purple)
                }
                .padding()
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
