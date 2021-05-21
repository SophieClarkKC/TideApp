//
//  LineGraph.swift
//  TideApp
//
//  Created by Sophie Clark on 18/05/2021.
//

import SwiftUI

struct LineGraph: Shape {
  let dataPoints: [CGPoint]
  let maxValue: CGPoint
  let controlPoints: [BezierSegmentControlPoints]
  
  init(dataPoints: [CGPoint]) {
    self.dataPoints = dataPoints
    
    let highestPoint = dataPoints.max { $0.y < $1.y }
    maxValue = highestPoint ?? .zero
    let config = BezierConfiguration()
    controlPoints = config.configureControlPoints(data: dataPoints)
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    for (index, dataPoint) in dataPoints.enumerated() {
      if index == 0 {
        path.move(to: dataPoint)
      } else {
        let segment = controlPoints[index - 1]
        path.addCurve(to: dataPoint, control1: segment.firstControlPoint, control2: segment.secondControlPoint)
      }
    }
    
    return path
  }
}
