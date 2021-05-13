//
//  MockServerConfigurationView.swift
//  
//
//  Created by Marco Guerrieri on 13/05/2021.
//

import SwiftUI

struct RouteConfigEntry: Hashable, Identifiable {
  let id = UUID()
  let route: String
  let response: MockServerConfig.BasicResponse
}

struct MockServerConfigurationView: View {
  @State private var showStatusPicker = false
  @State private var entries: [RouteConfigEntry] = []
  @State private var selectedRouteCurrentStatus = 0
  @State private var selectedRouteName = ""

  private var selectableStatus: [MockServerConfig.BasicResponse] = []

  init(entries: [RouteConfigEntry], selectableStatus: [MockServerConfig.BasicResponse]) {
    self.entries = entries
    self.selectableStatus = selectableStatus
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        VStack {
          Spacer(minLength: 4)
          Text("Mock Configuration").font(.title2).bold().textCase(.uppercase)
          Spacer(minLength: 4)
          List(self.entries, id: \.self) { entry in
            Button(action: {
              self.selectedRouteCurrentStatus = selectableStatus.firstIndex(where: { $0.rawValue == entry.response.rawValue }) ?? 0
              self.selectedRouteName = entry.route
              self.showStatusPicker = true
            }) {
              RouteCell(entry: entry)
            }
          }
          if showStatusPicker {
            VStack {
              Divider()
              Text("SELECT RETURN STATUS")
                .bold()
              Divider()
              Picker("Return Status", selection: $selectedRouteCurrentStatus) {
                ForEach(0..<selectableStatus.count, content: { index in
                  Text(selectableStatus[index].rawValue)
                })
              }
              .onChange(of: selectedRouteCurrentStatus, perform: { value in
                updateRouteStatus(for: self.selectedRouteName,
                                  with: self.selectableStatus[selectedRouteCurrentStatus])
              })
              .frame(width: geometry.size.width,
                      height: 80,
                      alignment: .center)
              .clipped()
              Divider()
              Button(action: {
                self.showStatusPicker = false
              }, label: {
                Text("CLOSE").bold()
              }).frame(width: geometry.size.width,
                       height: 30,
                       alignment: .center)
            }
          }
        }
      }
    }
  }

  private func updateRouteStatus(for route: String, with response: MockServerConfig.BasicResponse) {
    guard let targetIndex = entries.firstIndex(where: { $0.route == route } ) else { return }
    MockServerStore.shared.store(key: route, response: response)
    entries[targetIndex] = RouteConfigEntry(route: route, response: response)
  }
}

fileprivate struct RouteCell: View {
  let entry: RouteConfigEntry

  var body: some View {
    HStack {
      Text(entry.route).bold().foregroundColor(.black)
      Spacer()
      Text(entry.response.rawValue)
        .italic()
        .foregroundColor(entry.response == .success ? .green : .red)
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    MockServerConfigurationView(entries: [RouteConfigEntry(route: "Route1", response: .success),
                                          RouteConfigEntry(route: "Route2", response: .failure),
                                          RouteConfigEntry(route: "Route3", response: .success)], selectableStatus: [.success, .failure])
  }
}
