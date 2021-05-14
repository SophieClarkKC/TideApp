//
//  LocationsInfoView.swift
//  TideApp
//
//  Created by John Sanderson on 14/05/2021.
//

import SwiftUI

struct LocationInfoView: View {

  let weatherInfo: [WeatherInfo]

  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          ForEach(weatherInfo, id: \.locationName) { info in
            LocationButton(weatherInfo: info, type: .current)
          }
        }
        .padding([.top, .bottom])
      }
      .navigationTitle("My Locations")
      .navigationBarItems(trailing: Image(systemName: "magnifyingglass"))
    }
  }
}
