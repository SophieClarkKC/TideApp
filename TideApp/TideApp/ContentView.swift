//
//  ContentView.swift
//  TideApp
//
//  Created by Sophie Clark on 29/04/2021.
//

import SwiftUI

struct ContentView: View {
  
  @StateObject var viewModel = TideDataViewModel()
  
  var body: some View {
    VStack {
      Spacer()
      Text("Tide App!")
        .padding()
      Spacer()
      Text("\(viewModel.requestLocation)")
    }
    .onAppear {
      viewModel.getTideData()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
