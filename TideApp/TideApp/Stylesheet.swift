//
//  Stylesheet.swift
//  TideApp
//
//  Created by Sophie Clark on 29/04/2021.
//

import Foundation
import SwiftUI

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

enum TextSize {
    case title
    case subTitle
    case body
    case button
    
    func size() -> CGFloat {
        switch self {
        case .title:
            return 23.0
        case .subTitle:
            return 18.0
        case .body:
            return 15.0
        case .button:
            return 21.0
        }
    }
}

struct ComponentValues {
    static let buttonCornerRadius: CGFloat = 5.0
    static let buttonPressedStateAlpha: Double = 0.7
    static let buttonNormalStateAlpha: Double = 1.0
    static let buttonPadding: CGFloat = 5.0
}

extension Font.Weight {
    static let titleWeight: Font.Weight = .bold
    static let subTitleWeight: Font.Weight = .medium
    static let bodyWeight: Font.Weight = .medium
    static let primaryButtonWeight: Font.Weight = .bold
    static let secondaryButtonWeight: Font.Weight = .regular
}

struct TitleLabel: View {
    @State var text: String
    var body: some View {
        Text(text)
            .foregroundColor(.titleColor)
            .font(.system(size: TextSize.title.size(), weight: .bold, design: .default))
    }
}

struct SubtitleLabel: View {
    @State var text: String
    var body: some View {
        Text(text)
            .foregroundColor(.subtitleColor)
            .font(.system(size: TextSize.subTitle.size(), weight: .bold, design: .default))
    }
}

struct BodyLabel: View {
    @State var text: String
    var body: some View {
        Text(text)
            .foregroundColor(.bodyTextColor)
            .font(.system(size: TextSize.body.size(), weight: .medium, design: .default))
            .multilineTextAlignment(.leading)
    }
}

struct PrimaryActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(ComponentValues.buttonPadding)
            .frame(maxWidth: .infinity, minHeight: 50)
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
            .frame(maxWidth: .infinity, minHeight: 50)
            .foregroundColor(.secondaryButtonTextColor)
            .font(.system(size: TextSize.button.size(), weight: .secondaryButtonWeight, design: .default))
            .background(Color.secondaryActionColor.opacity(configuration.isPressed ? ComponentValues.buttonPressedStateAlpha : ComponentValues.buttonNormalStateAlpha))
            .cornerRadius(ComponentValues.buttonCornerRadius)
    }
}
