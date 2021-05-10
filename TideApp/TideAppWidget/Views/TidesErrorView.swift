//
//  TidesErrorView.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import SwiftUI

struct TidesErrorView: View {
  var body: some View {
    ZStack {
      Spacer(minLength: 4)
      Color.red.ignoresSafeArea()
      TitleLabel(text: "Error")
      Spacer(minLength: 4)
    }
  }
}
