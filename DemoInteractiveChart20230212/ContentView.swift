//
//  ContentView.swift
//  DemoInteractiveChart20230212
//
//  Created by Xavier on 2/12/23.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var selectedRecord: (String, Int)? = nil
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    ForEach(salesRecords) { record in
                        AreaMark(
                            x: .value("Office Location", record.office),
                            y: .value("Sales Volume", record.salesVolume)
                        )
                        .foregroundStyle(.linearGradient(colors: [.cyan, .cyan.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                        .foregroundStyle(.pink.opacity(0.7))
                        if let selectedRecord {
                            if (selectedRecord.1 > 0 && selectedRecord.1 < 5000) {
                                RuleMark(y: .value("Sales", selectedRecord.1))
                                    .foregroundStyle(.pink)
                                    .annotation {
                                        Text("\(selectedRecord.1)")
                                            .foregroundColor(.secondary)
                                    }
                            }
                        }
                    }
                }
                .frame(height: 200)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(DragGesture()
                                .onChanged { value in
                                    // get plot area coordiate from gesture location
                                    let origin = geometry[proxy.plotAreaFrame].origin
                                    let location = CGPoint(
                                        x: value.location.x - origin.x,
                                        y: value.location.y - origin.y)
                                    print(location)
                                    // update state
                                    selectedRecord = proxy.value(at: location, as: ((String, Int).self))
                                }
                                .onEnded{ _ in
                                    // reset state when gesture ends
                                    selectedRecord = nil
                                }
                            )
                    }
                }
                .padding()
                .navigationTitle("Sales Report")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: Data Source
//Model
struct SalesRecord: Identifiable {
    let id = UUID()
    let office: String
    let salesVolume: Int
}

//Data
let salesRecords: [SalesRecord] = [
    .init(office: "New York", salesVolume: 3000),
    .init(office: "San Fran", salesVolume: 2750),
    .init(office: "California", salesVolume: 4020),
    .init(office: "Denver", salesVolume: 930),
    .init(office: "Kansas", salesVolume: 2100)
]
