//
//  StylesheetComponentExample.swift
//  TideApp
//
//  Created by Sophie Clark on 30/04/2021.
//

import SwiftUI

struct StylesheetComponentExample: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10, content: {
      TitleLabel(text: "This is an example of a title label")
      SubtitleLabel(text: "This is an example of a subtitle label")
      BodyLabel(text: "This is an example of a body label")
      HStack(spacing: ComponentValues.buttonPadding) {
        Button("secondary button", action: {}).buttonStyle(SecondaryActionStyle())
        Button("primary button", action: {}).buttonStyle(PrimaryActionStyle())
      }.padding()
    })
    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    .background(Color.backgroundColor)
  }
}

struct StylesheetComponentExample_Previews: PreviewProvider {
  static var previews: some View {
    StylesheetComponentExample()
      .preferredColorScheme(.dark)
  }
}
