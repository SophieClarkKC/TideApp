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
  var startPoint = CGPoint.zero
  var body: some View {
    VStack {
      GeometryReader { reader in
        LineGraph(points: tideData.map { CGFloat($0.tideHeightM) })
          .trim(to: on ? 1 : 0)
          .stroke(Color.black, lineWidth: 2)
          .aspectRatio(reader.size, contentMode: .fit)
          .padding()
        Button("Animate") {
          withAnimation(.easeInOut(duration: 2)) {
            self.on.toggle()
          }
        }
      }
    }
  }
}

struct LineGraph: Shape {
  var points: [CGFloat]
  func path(in rect: CGRect) -> Path {
    func point(at index: Int) -> CGPoint {
      let point = points[index]
      let x = rect.width * CGFloat(index) / CGFloat(points.count - 1)
      let y = (1-point) * rect.height
      return CGPoint(x: x, y: y)
    }
    
    return Path { p in
      guard points.count > 1 else { return }
      let start = points[0]
      p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
      for index in points.indices {
        p.addLine(to: point(at: index))
      }
    }
  }
}

struct TideChartView_Previews: PreviewProvider {
  static var previews: some View {
    TideChartView(tideData: [TideChartView.TideData(tideTime: "03:28 AM", tideHeightM: 6.97, tideDateTime: "2021-04-29 03:28".date(with: .dateTime)!, tideType: .high), TideChartView.TideData(tideTime: "09:28 AM", tideHeightM: 3.97, tideDateTime: "2021-04-29 09:28".date(with: .dateTime)!, tideType: .low), TideChartView.TideData(tideTime: "12:28 AM", tideHeightM: 6.97, tideDateTime: "2021-04-29 12:28".date(with: .dateTime)!, tideType: .high)])
  }
}
