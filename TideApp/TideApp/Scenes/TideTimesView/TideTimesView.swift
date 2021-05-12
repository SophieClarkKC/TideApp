//
//  TideTimesView.swift
//  TideApp
//
//  Created by Sophie Clark on 04/05/2021.
//

import SwiftUI
import Combine
import CoreLocation

struct TideTimesView: View {
  @ObservedObject var viewModel: TideTimesViewModel
  @StateObject var userLocator = UserLocator()
  var lastLatitude = Double()
  var lastLongitude = Double()

  var body: some View {
    ScrollView(.vertical, showsIndicators: false, content: {

      VStack(alignment: .leading, spacing: nil, content: {

        TitleLabel(text: viewModel.locationName)
          .accessibility(label: Text("You are looking at tide times for \(viewModel.locationName)"))
          .padding([.bottom, .top], PaddingValues.medium)

        SubtitleLabel(text: viewModel.subTitle)
          .padding(.bottom, PaddingValues.tiny)

        if let tideStatus = viewModel.tideStatus {
          BodyLabel(text: tideStatus).padding(.bottom, PaddingValues.tiny)
        }

        ForEach(viewModel.tideTimes) { tideTime in
          BodyLabel(text: "\(tideTime.tideType.rawValue.capitalized): \(tideTime.tideTime)")
        }

        if let tideHeight = viewModel.tideHeight {
          SubtitleLabel(text: tideHeight)
            .padding([.bottom, .top], PaddingValues.small)
        }
        
        if let waterTemperature = viewModel.waterTemperature {
          SubtitleLabel(text: waterTemperature)
            .padding([.bottom, .top], PaddingValues.small)
        }
      })
      .padding([.leading, .trailing], PaddingValues.medium)
    })
    .onChange(of: userLocator.location, perform: {
      updateTides(for: $0)
    })
    .onAppear {
      userLocator.start()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.backgroundColor.ignoresSafeArea(.all, edges: [.top, .bottom]))
  }

  func updateTides(for newLocation: CLLocation) {
    let newLatitude = Double(newLocation.coordinate.latitude)
    let newLongitude = Double(newLocation.coordinate.longitude)

    if newLatitude == lastLatitude && newLongitude == lastLongitude { return }

    viewModel.getTideTimes(lat: newLatitude, lon: newLongitude)
  }
}

struct TideTimesView_Previews: PreviewProvider {
  static var previews: some View {
    TideTimesView(viewModel: TideTimesViewModel(weatherFetcher: WeatherDataFetcher()))
  }
}
