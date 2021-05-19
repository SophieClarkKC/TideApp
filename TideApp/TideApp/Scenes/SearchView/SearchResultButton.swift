//
//  SearchResultButton.swift
//  TideApp
//
//  Created by John Sanderson on 19/05/2021.
//

import SwiftUI
import MapKit

struct SearchResultButton: View {

  let placemark: MKPlacemark
  @State private var showSheet = false

  var body: some View {
    Button(action: {
      showSheet.toggle()
    }) {
      VStack(alignment: .leading, spacing: PaddingValues.tiny) {
        SubtitleLabel(text: placemark.name ?? "")
        BodyLabel(text: placemark.title ?? "")
      }
      .padding(PaddingValues.small)
    }
    .sheet(isPresented: $showSheet, content: {
      TideTimesView(viewModel: TideTimesNetworkViewModel(location: placemark.location))
    })
  }
}

struct SearchResultButton_Previews: PreviewProvider {
  static var previews: some View {
    SearchResultButton(placemark: MKPlacemark())
  }
}
