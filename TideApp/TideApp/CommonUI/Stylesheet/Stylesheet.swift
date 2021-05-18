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
  static let titleColor = Color("Colors/titleColor")
  static let bodyTextColor = Color("Colors/bodyTextColor")
  static let subtitleColor = Color("Colors/subtitleColor")
  static let primaryActionColor = Color("Colors/primaryActionColor")
  static let secondaryActionColor = Color("Colors/secondaryActionColor")
  static let backgroundColor = Color("Colors/backgroundColor")
  static let primaryButtonTextColor = Color("Colors/primaryButtonTextColor")
  static let secondaryButtonTextColor = Color("Colors/secondaryButtonTextColor")
}

// MARK: Assets

enum SystemAsset: String {
  case location = "location.fill"
  case favouriteEmpty = "star"
  case favouriteFilled = "star.fill"
  case search = "magnifyingglass"
}

extension Image {

  init(_ systemAsset: SystemAsset) {
    self.init(systemName: systemAsset.rawValue)
  }
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
  static let subTitleWeight: Font.Weight = .bold
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
  static let errorCornerRadius: CGFloat = 10.0
}

struct PaddingValues {
  static let huge: CGFloat = 32
  static let large: CGFloat = 24
  static let medium: CGFloat = 16
  static let small: CGFloat = 8
  static let tiny: CGFloat = 4
}

struct ScaledFont: ViewModifier {
  @Environment(\.sizeCategory) var sizeCategory
  var size: TextSize
  var weight: Font.Weight
  
  func body(content: Content) -> some View {
    let scaledSize = UIFontMetrics.default.scaledValue(for: size.size())
    return content.font(.system(size: scaledSize, weight: weight, design: .default))
  }
}

// MARK: Components - Labels

struct TitleLabel: View {
  var text: String
  var body: some View {
    Text(text)
      .foregroundColor(.titleColor)
      .modifier(ScaledFont(size: TextSize.title, weight: .titleWeight))
  }
}

struct SubtitleLabel: View {
  var text: String
  var body: some View {
    Text(text)
      .foregroundColor(.subtitleColor)
      .modifier(ScaledFont(size: TextSize.subTitle, weight: .subTitleWeight))
  }
}

struct BodyLabel: View {
  var text: String
  var body: some View {
    Text(text)
      .foregroundColor(.bodyTextColor)
      .modifier(ScaledFont(size: TextSize.body, weight: .bodyWeight))
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
      .modifier(ScaledFont(size: TextSize.button, weight: .primaryButtonWeight))
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
      .modifier(ScaledFont(size: TextSize.button, weight: .secondaryButtonWeight))
      .background(Color.secondaryActionColor.opacity(configuration.isPressed ? ComponentValues.buttonPressedStateAlpha : ComponentValues.buttonNormalStateAlpha))
      .cornerRadius(ComponentValues.buttonCornerRadius)
  }
}
