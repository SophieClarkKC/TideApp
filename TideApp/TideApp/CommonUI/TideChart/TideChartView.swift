//
//  TideChartView.swift
//  TideApp
//
//  Created by Sophie Clark on 13/05/2021.
//

import SwiftUI

struct TideChartView: View {
  typealias TideData = WeatherData.Weather.Tide.TideData
  
  var animate = false
  
  var tideData: [TideData]
  var tideHeight: String?
  var date = Date()
  
  var body: some View {
    ZStack {
      TimeLines()
        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
        .foregroundColor(.gray)
        .padding(PaddingValues.small)
      
      VStack(alignment: .leading) {
        BodyLabel(text: "high tide")
          .frame(alignment: .topLeading)
          .padding(PaddingValues.small)
        
        GeometryReader { proxy in
          let points = makePoints(in: proxy.size)
          LineGraph(dataPoints: points)
            .trim(to: animate ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .foregroundColor(.titleColor)
          
          let timePercentage = getTimePercentage(for: date)
          LineGraph(dataPoints: points)
            .trim(to: animate ? timePercentage : 0)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
            .foregroundColor(.bodyTextColor)
          
          let timePoint = getTimePoint(for: points, percentageTimePassed: timePercentage, in: proxy.size)
          if let tideHeight = tideHeight {
            BodyLabel(text: tideHeight)
              .padding(PaddingValues.tiny)
              .background(Capsule()
                            .foregroundColor(Color.backgroundColor.opacity(0.5)))
              .offset(x: timePoint.x, y: timePoint.y)
              .opacity(animate ? 1 : 0)
              .animation(Animation.linear.delay(ComponentValues.tideAnimationTime))
          }
        }
        
        BodyLabel(text: "low tide")
          .frame(alignment: .bottomLeading)
          .padding(PaddingValues.small)
      }
      HStack(alignment: .center, content: {
        GeometryReader { proxy in
          if let quarterTimes = getQuarterTimes() {
            ForEach(0..<quarterTimes.count) { index in
              BodyLabel(text: quarterTimes[index], alignment: .center)
                .offset(x: proxy.size.width * (CGFloat((index + 1)) / 4), y: proxy.size.height)
            }
          }
        }
      })
    }
  }
  
  private func getQuarterTimes() -> [String]? {
    guard let latestTime = tideData.sorted(by: { $0.tideDateTime > $1.tideDateTime }).first?.tideDateTime else {
      return nil
    }
    guard let earliestTime = tideData.sorted(by: { $0.tideDateTime < $1.tideDateTime }).first?.tideDateTime else {
      return nil
    }
    let timeDifference = latestTime.difference(from: earliestTime)
    let quarter = earliestTime.addingTimeInterval(timeDifference * 0.25).string(with: .time)
    let half = earliestTime.addingTimeInterval(timeDifference * 0.5).string(with: .time)
    let threeQuarters = earliestTime.addingTimeInterval(timeDifference * 0.75).string(with: .time)
    return [quarter, half, threeQuarters]
  }
  
  private func getTimePercentage(for date: Date) -> CGFloat {
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
    guard let peakTides = getHighestAndLowestTides() else {
      return []
    }
    guard let normalisedData = getNormalisedPeakData(with: peakTides) else {
      return []
    }
    guard let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
      return []
    }
    guard let earliestAndLatestTime = getEarliestAndLatestTime() else {
      return []
    }
    let points: [CGPoint] = tideData.map({ data in
      let tidePoint = size.height - (CGFloat((data.tideHeightM - peakTides.lowest.tideHeightM) / normalisedData.highestTide) * size.height)
      let timePoint = CGFloat((data.tideDateTime.timeIntervalSince(dayBefore) - earliestAndLatestTime.earliest.timeIntervalSince(dayBefore)) / normalisedData.latestTime) * size.width
      return CGPoint(x: timePoint, y: tidePoint)
    })
    return points
  }
  
  private func getEarliestAndLatestTime() -> (earliest: Date, latest: Date)? {
    guard let latestTime = tideData.sorted(by: { $0.tideDateTime > $1.tideDateTime }).first?.tideDateTime else {
      return nil
    }
    guard let earliestTime = tideData.sorted(by: { $0.tideDateTime < $1.tideDateTime }).first?.tideDateTime else {
      return nil
    }
    return (earliest: earliestTime, latest: latestTime)
  }
  
  private func getNormalisedPeakData(with peakTides: (highest: TideData, lowest: TideData)) -> (highestTide: Double, latestTime: TimeInterval)? {
    guard let earliestAndLatestTime = getEarliestAndLatestTime() else {
      return nil
    }
    guard let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: date) else {
      return nil
    }
    let highestTideNormalised = peakTides.highest.tideHeightM - peakTides.lowest.tideHeightM
    let latestTimeNormalised = earliestAndLatestTime.latest.timeIntervalSince(dayBefore) - earliestAndLatestTime.earliest.timeIntervalSince(dayBefore)
    return (highestTide: highestTideNormalised, latestTime: latestTimeNormalised)
  }
  
  private func getHighestAndLowestTides() -> (highest: TideData, lowest: TideData)? {
    guard let highestTide = tideData.sorted(by: { $0.tideHeightM > $1.tideHeightM }).first,
          let lowestTide = tideData.sorted(by: { $0.tideHeightM < $1.tideHeightM }).first else {
      return nil
    }
    return (highestTide, lowestTide)
  }
  
  private func getTimePoint(for points: [CGPoint], percentageTimePassed: CGFloat, in size: CGSize) -> CGPoint {
    var points = points
    let tidesWithPoints = tideData.map { data in
      return (data, points.removeFirst())
    }
    guard let peakTides = getHighestAndLowestTides(), let normalisedData = getNormalisedPeakData(with: peakTides) else {
      return tidesWithPoints.first?.1 ?? .zero
    }
    for (index, tidePoint) in tidesWithPoints.enumerated() {
      if index == 0, tidePoint.0.tideDateTime > date {
        let x = size.width * 0.1
        let y = tidePoint.1.y
        return CGPoint(x: x, y: y)
      } else if index < tidesWithPoints.count - 1 {
        let nextTide = tidesWithPoints[index + 1]
        if tidePoint.0.tideDateTime < date, nextTide.0.tideDateTime > date {
          let percentageTimePassedAtLastTidePoint = getTimePercentage(for: tidePoint.0.tideDateTime)
          let xOffset = (percentageTimePassed - percentageTimePassedAtLastTidePoint) * size.width
          let currentHeight = GeneralHelpers.getWeightedValue(from: tidePoint.0.tideDateTime, middleDate: date, endDate: nextTide.0.tideDateTime, startValue: tidePoint.0.tideHeightM, endValue: nextTide.0.tideHeightM)
          let y = size.height - (CGFloat((currentHeight - peakTides.lowest.tideHeightM) / normalisedData.highestTide) * size.height)
          var x: CGFloat
          if tidePoint.1.x + xOffset > size.width * 0.9 {
            x = tidePoint.1.x + (CGFloat(xOffset) * 0.8)
          } else {
            x = tidePoint.1.x + CGFloat(xOffset)
          }
          return CGPoint(x: x, y: y)
        }
      } else if index == tidesWithPoints.count - 1, date > tidePoint.0.tideDateTime {
        return CGPoint(x: size.width * 0.9, y: tidePoint.1.y)
      }
    }
    return .zero
  }
}

struct TideChartView_Previews: PreviewProvider {
  static var previews: some View {
    TideChartView(tideData: [TideChartView.TideData(tideTime: "03:28 AM", tideHeightM: 6.97, tideDateTime: "2021-04-29 03:28".date(with: .dateTime)!, tideType: .high), TideChartView.TideData(tideTime: "09:28 AM", tideHeightM: 3.97, tideDateTime: "2021-04-29 09:28".date(with: .dateTime)!, tideType: .low), TideChartView.TideData(tideTime: "12:28 AM", tideHeightM: 6.97, tideDateTime: "2021-04-29 12:28".date(with: .dateTime)!, tideType: .high)])
  }
}
