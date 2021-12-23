//
//  BussesView_ViewModel.swift
//  Balloon
//
//  Created by Oto Brglez on 24/12/2021.
//

import Foundation
import Combine

extension BusesView {
    class ViewModel: ObservableObject {
        @Published var buses = [BusInfo]()
        private var tocenLive = TocenLive()
        var eventCancellable: AnyCancellable?

        func connect() {
            tocenLive.connect()
            eventCancellable = tocenLive.currentEvent
                .filter { $0.kind == Event.Kind.Updated }
                .map { $0.data.busInfo }
                .sink { [weak self] busInfo in
                    self?.updateBusInfo(busInfo: busInfo)
                }
        }
        
        func updateBusInfo(busInfo: BusInfo) {
            if let busInfoIndex = self.buses.firstIndex(where: {
                $0.bus_id == busInfo.bus_id
            }) {
                self.buses[busInfoIndex] = busInfo
            } else {
                self.buses.append(busInfo)
                self.buses.sort(by: {
                    $0.bus_group > $1.bus_group
                    // && $0.bus_name > $1.bus_name
                })
            }
        }
        
        func disconnect() {
            tocenLive.disconnect()
            eventCancellable?.cancel()
        }
    }
}
