//
//  WaterTemperatureView.swift
//  TideApp
//
//  Created by Dan Smith on 19/05/2021.
//

import SwiftUI

struct WaterTemperatureView: View {
  @State var temperature: Int

  var body: some View {
    HStack {
      AnimatedDataLabel(title: "Water", value: temperature, symbol: "℃", systemAsset: .thermometer)
      ThermometerBarView(temperature: temperature)
    }
  }
}

// MARK: - AnimatedDataLabel -
struct AnimatedDataLabel: View {
  @State var appearing = false
  let title: String
  let value: Int
  let symbol: String
  let systemAsset: SystemAsset?
  let delay: Double

  init(title: String, value: Int, symbol: String = "", delay: Double = 1, systemAsset: SystemAsset?) {
    self.title = title
    self.value = value
    self.symbol = symbol
    self.delay = delay
    self.systemAsset = systemAsset
  }

  var body: some View {
    VStack {
      HStack {
        Text(title)
        .font(.title3)

        if let systemAsset = systemAsset {
          Image(systemAsset)
        }
      }

      Text("\(value)\(symbol)")
        .font(.largeTitle)
        .scaleEffect(appearing ? 1 : 0)
        .animation(Animation.spring(response: 0.2,
                                    dampingFraction: 0.4,
                                    blendDuration: 0.7)
                    .delay(delay))
    }
    .onAppear {
      withAnimation {
        appearing.toggle()
      }
    }
    .foregroundColor(.titleColor)
  }
}

// MARK: - ThermometerBarView -
struct ThermometerBarView: View {
  @State var temperature: Int
  @State var appearing = false

  var maxTemp: Int = 26 // NB: The highest ever recorded sea temperature was 25.9 ℃
  var safeMax: Int { max(temperature, maxTemp) }
  var barPercentage: CGFloat { CGFloat(temperature) / CGFloat(safeMax) }
  var barColors: [Color] = [.bodyTextColor, .subtitleColor]

  var body: some View {
    HStack {
      AnimatedGradientBar(colors: barColors, percentageFilled: barPercentage)
      ThermometerScale(maxValue: safeMax, minValue: 0)
    }
  }
}

// MARK: - AnimatedGradientBar -
struct AnimatedGradientBar: View {
  @State var appearing = false
  let colors: [Color]
  let percentageFilled: CGFloat

  var body: some View {
    ZStack {
      GeometryReader { geometry in
        Group {
          Capsule()
            .foregroundColor(.titleColor)
            .opacity(0.15)

          LinearGradient(gradient: Gradient(colors: colors),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
            .frame(width: 15,
                   height: appearing ? percentageFilled * geometry.size.height : 0)
            .clipShape(Capsule())
        }
      }
      .frame(width: 15)
      .animation(Animation.easeInOut.delay(0.7))
    }
    .rotationEffect(.init(degrees: 180))
    .onAppear{
      withAnimation {
        appearing.toggle()
      }
    }
  }
}

// MARK: - ThermometerScale
struct ThermometerScale: View {
  let maxValue: Int
  let minValue: Int
  var midValue: String {
    let midValue = Double((maxValue - minValue) / 2)
    return midValue.cleanValue()
  }

  var body: some View {
    VStack {
      Text("\(maxValue)")
      Spacer()
      Text(midValue)
      Spacer()
      Text("\(minValue)")
    }
    .font(.caption)
    .frame(minWidth: 10)
    .foregroundColor(.bodyTextColor)
  }
}

struct WaterTemperatureView_Previews: PreviewProvider {
  static var previews: some View {
    WaterTemperatureView(temperature: 18)
  }
}
