//
//  LocationsInfoView.swift
//  TideApp
//
//  Created by John Sanderson on 14/05/2021.
//

import SwiftUI

struct LocationInfoView: View {

  @State private var showSearch: Bool = false
  let weatherInfo: Set<WeatherInfo>

  var body: some View {
    NavigationView {
      ScrollView(showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          ForEach(Array(weatherInfo), id: \.locationName) { info in
            LocationButton(weatherInfo: info, type: .current)
          }
        }
        .padding([.top, .bottom])
      }
      .navigationTitle("My Locations")
      .background(Color.backgroundColor.ignoresSafeArea())
      .navigationBarItems(trailing: Button(action: {
        showSearch.toggle()
      }) { Image(.search) }
      .accentColor(.titleColor)
      .sheet(isPresented: $showSearch) {
        SearchView(viewModel: SearchViewModel())
      })
    }
  }
}
