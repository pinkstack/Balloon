//
//  BalloonApp.swift
//  Balloon
//
//  Created by Oto Brglez on 22/12/2021.
//

import SwiftUI

@main
struct BalloonApp: App {
    var tocenLive = TocenLive()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tocenLive)
        }
    }
}
