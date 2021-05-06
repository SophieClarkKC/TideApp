//
//  Stylesheet.swift
//  TideApp
//
//  Created by Sophie Clark on 29/04/2021.
//

import Foundation
import SwiftUI

// MARK: Colors

extension Color {
  static let titleColor = Color("titleColor")
  static let bodyTextColor = Color("bodyTextColor")
  static let subtitleColor = Color("subtitleColor")
  static let primaryActionColor = Color("primaryActionColor")
  static let secondaryActionColor = Color("secondaryActionColor")
  static let backgroundColor = Color("backgroundColor")
  static let primaryButtonTextColor = Color("primaryButtonTextColor")
  static let secondaryButtonTextColor = Color("secondaryButtonTextColor")
}

// MARK: Font size and weights

enum TextSize {
  case title
  case subTitle
  case body
  case button
  
  func size() -> CGFloat {
    switch self {
    case .title:
      return UIFont.preferredFont(forTextStyle: .title1).pointSize
    case .subTitle:
      return UIFont.preferredFont(forTextStyle: .title3).pointSize
    case .body:
      return UIFont.preferredFont(forTextStyle: .body).pointSize
    case .button:
      return UIFont.preferredFont(forTextStyle: .title2).pointSize
    }
  }
}

extension Font.Weight {
  static let titleWeight: Font.Weight = .bold
  static let subTitleWeight: Font.Weight = .medium
  static let bodyWeight: Font.Weight = .medium
  static let primaryButtonWeight: Font.Weight = .bold
  static let secondaryButtonWeight: Font.Weight = .regular
}

// MARK: Component Values

struct ComponentValues {
  static let buttonCornerRadius: CGFloat = 5.0
  static let buttonPressedStateAlpha: Double = 0.7
  static let buttonNormalStateAlpha: Double = 1.0
  static let buttonPadding: CGFloat = 5.0
  static let buttonMinimumHeight: CGFloat = 50.0
}

struct PaddingValues {
  static let huge: CGFloat = 32
  static let large: CGFloat = 24
  static let medium: CGFloat = 16
  static let small: CGFloat = 8
  static let tiny: CGFloat = 4
}

// MARK: Components - Labels

struct TitleLabel: View {
  var text: String
  var body: some View {
    Text(text)
      .foregroundColor(.titleColor)
      .font(.system(size: TextSize.title.size(), weight: .bold, design: .default))
  }
}

struct SubtitleLabel: View {
  var text: String
  var body: some View {
    Text(text)
      .foregroundColor(.subtitleColor)
      .font(.system(size: TextSize.subTitle.size(), weight: .bold, design: .default))
  }
}

struct BodyLabel: View {
  var text: String
  var body: some View {
    Text(text)
      .foregroundColor(.bodyTextColor)
      .font(.system(size: TextSize.body.size(), weight: .medium, design: .default))
      .multilineTextAlignment(.leading)
  }
}

// MARK: Components - Button styles

struct PrimaryActionStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(ComponentValues.buttonPadding)
      .frame(maxWidth: .infinity, minHeight: ComponentValues.buttonMinimumHeight)
      .foregroundColor(.primaryButtonTextColor)
      .font(.system(size: TextSize.button.size(), weight: .primaryButtonWeight, design: .default))
      .background(Color.primaryActionColor.opacity(configuration.isPressed ? ComponentValues.buttonPressedStateAlpha : ComponentValues.buttonNormalStateAlpha))
      .cornerRadius(ComponentValues.buttonCornerRadius)
  }
}

struct SecondaryActionStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(ComponentValues.buttonPadding)
      .frame(maxWidth: .infinity, minHeight: ComponentValues.buttonMinimumHeight)
      .foregroundColor(.secondaryButtonTextColor)
      .font(.system(size: TextSize.button.size(), weight: .secondaryButtonWeight, design: .default))
      .background(Color.secondaryActionColor.opacity(configuration.isPressed ? ComponentValues.buttonPressedStateAlpha : ComponentValues.buttonNormalStateAlpha))
      .cornerRadius(ComponentValues.buttonCornerRadius)
  }
}
