//
//  TidesContentView.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import SwiftUI

struct TidesContentView: View {
  var entry: Provider.Entry

  var body: some View {
    ZStack {
      Color.backgroundColor.ignoresSafeArea()
      VStack(alignment: .center, spacing: 0) {
        Spacer(minLength: 4)
        TitleLabel(text: "Tide App Widget")
        SubtitleLabel(text: "Last update \(entry.date.string(with: .time))")
        Spacer(minLength: 4)
      }
    }
  }
}
