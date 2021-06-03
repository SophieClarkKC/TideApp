//
//  ErrorView.swift
//  TideApp
//
//  Created by Sophie Clark on 12/05/2021.
//

import SwiftUI

struct ErrorView: View {
  @State var message: String
  var buttonAction: () -> Void

  var body: some View {
    VStack {
      TitleLabel(text: "Oops, something went wrong")
        .padding(PaddingValues.medium)
      BodyLabel(text: message)
        .padding(PaddingValues.small)
      Button("Retry", action: buttonAction)
        .buttonStyle(PrimaryActionStyle())
        .padding(PaddingValues.large)
    }
    .overlay(
      RoundedRectangle(cornerRadius: ComponentValues.errorCornerRadius)
        .stroke(Color.primaryActionColor, lineWidth: 3)
    )
    .padding(PaddingValues.tiny)
  }
}

struct ErrorView_Previews: PreviewProvider {
  static var previews: some View {
    ErrorView(message: NetworkError.invalidRequest.localizedDescription, buttonAction: {})
  }
}
