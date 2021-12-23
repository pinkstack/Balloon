//
//  BusesView.swift
//  Balloon
//
//  Created by Oto Brglez on 23/12/2021.
//

import SwiftUI
import Combine

struct BusesView: View {
    @StateObject var viewModel: ViewModel
    
    init(viewModel: ViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 2) {
                ForEach(viewModel.buses, id:\.bus_id) { busInfo in
                    LazyHStack(alignment: .center, spacing: 5) {
                        Image(systemName: "bus")
                        
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Text(busInfo.bus_name)
                                Spacer().frame(width: 20, height: 1)
                                Text(busInfo.bus_group).bold()
                            }.font(.title3)
                            HStack {
                                Text(String(format:"%.2f km/h", busInfo.velocity))
                                Text("at")
                                Text(String(format:"%.2f", busInfo.lat))
                                Text(String(format:"%.2f", busInfo.lng))
                            }.font(.caption)
                        }
                    }
                    .padding()
                }
            }
            
        }
        .overlay(Group {
            if viewModel.buses.isEmpty {
                HStack {
                    Image(systemName: "arrow.clockwise.circle.fill")
                    Text("Please wait a second,...")
                }
            }
        })
        .onAppear(perform: viewModel.connect)
        .onDisappear(perform: viewModel.disconnect)
    }
}

struct BusesView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = BusesView.ViewModel()
        vm.buses = [
            BusInfo(bus_id: UUID.init(),
                             bus_name: "LJ BX123",
                             bus_group: "N1",
                             lat: 1.1,
                             lng: 2.2,
                             rotation: 123,
                             velocity: 45.23),
            BusInfo(bus_id: UUID.init(),
                             bus_name: "LJ LPP-418",
                             bus_group: "6",
                             lat: 1.1,
                             lng: 2.2,
                             rotation: 123,
                             velocity: 45.23),
            BusInfo(bus_id: UUID.init(),
                             bus_name: "LJ LPP-114",
                             bus_group: "N2",
                             lat: 1.1,
                             lng: 2.2,
                             rotation: 123,
                             velocity: 45.23),
            BusInfo(bus_id: UUID.init(),
                             bus_name: "LJ LPP-486",
                             bus_group: "",
                             lat: 1.1,
                             lng: 2.2,
                             rotation: 123,
                             velocity: 45.23),
            
        ]
        return BusesView(viewModel: vm)
    }
}
