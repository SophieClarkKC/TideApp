//
//  TideChartView.swift
//  TideApp
//
//  Created by Sophie Clark on 13/05/2021.
//

import SwiftUI

struct TideChartView: View {
  typealias TideData = WeatherData.Weather.Tide.TideData
  
  @State var on = true
  
  var tideData: [TideData]
  var date = Date()
  var body: some View {
    VStack {
      GeometryReader { reader in
        let points = makePoints(in: reader.size)
        LineGraph(dataPoints: points)
          .trim(to: on ? 1 : 0)
          .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
          .foregroundColor(.titleColor)
        LineGraph(dataPoints: points)
          .trim(to: on ? getTimePercentage() : 0)
          .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
          .foregroundColor(.bodyTextColor)
        }
      Button("Animate") {
        withAnimation(.easeInOut(duration: 2)) {
          self.on.toggle()
        }
      }
    }
  }
  
  private func getTimePercentage() -> CGFloat {
    guard let latestTime = tideData.sorted(by: { $0.tideDateTime > $1.tideDateTime }).first?.tideDateTime else {
      return 0
    }
    guard let earliestTime = tideData.sorted(by: { $0.tideDateTime < $1.tideDateTime }).first?.tideDateTime else {
      return 0
    }
    let timeDifference = latestTime.difference(from: earliestTime)
    let differenceFromNow = date.difference(from: earliestTime)
    return CGFloat(differenceFromNow / timeDifference)
  }
  
  private func makePoints(in size: CGSize) -> [CGPoint] {
    guard let highestTide = tideData.sorted(by: { $0.tideHeightM > $1.tideHeightM }).first else {
      return []
    }
    guard let lowestTide = tideData.sorted(by: { $0.tideHeightM < $1.tideHeightM }).first else {
      return []
    }
    guard let latestTime = tideData.sorted(by: { $0.tideDateTime > $1.tideDateTime }).first?.tideDateTime else {
      return []
    }
    guard let earliestTime = tideData.sorted(by: { $0.tideDateTime < $1.tideDateTime }).first?.tideDateTime else {
      return []
    }
    guard let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
      return []
    }
    let highestTideNormalised = highestTide.tideHeightM - lowestTide.tideHeightM
    let latestTimeNormalised = latestTime.timeIntervalSince(dayBefore) - earliestTime.timeIntervalSince(dayBefore)
    let points: [CGPoint] = tideData.map({ data in
      let tidePoint = CGFloat((data.tideHeightM - lowestTide.tideHeightM) / highestTideNormalised) * size.height
      let timePoint = CGFloat((data.tideDateTime.timeIntervalSince(dayBefore) - earliestTime.timeIntervalSince(dayBefore)) / latestTimeNormalised) * size.width
      return CGPoint(x: timePoint, y: tidePoint)
    })
    return points
  }
}

struct TideChartView_Previews: PreviewProvider {
  static var previews: some View {
    TideChartView(tideData: [TideChartView.TideData(tideTime: "03:28 AM", tideHeightM: 6.97, tideDateTime: "2021-04-29 03:28".date(with: .dateTime)!, tideType: .high), TideChartView.TideData(tideTime: "09:28 AM", tideHeightM: 3.97, tideDateTime: "2021-04-29 09:28".date(with: .dateTime)!, tideType: .low), TideChartView.TideData(tideTime: "12:28 AM", tideHeightM: 6.97, tideDateTime: "2021-04-29 12:28".date(with: .dateTime)!, tideType: .high)])
  }
}
