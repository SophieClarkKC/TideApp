//
//  BezierCodk.swift
//  TideApp
//
//  Created by Sophie Clark on 17/05/2021.
//

import SwiftUI

struct BezierSegmentControlPoints {
  var firstControlPoint: CGPoint
  var secondControlPoint: CGPoint
}

class BezierConfiguration {
  var firstControlPoints: [CGPoint?] = []
  var secondControlPoints: [CGPoint?] = []
  
  func configureControlPoints(data: [CGPoint]) -> [BezierSegmentControlPoints] {
    let segments = data.count - 1
    
    if segments == 1 {
      
      // straight line calculation here
      let p0 = data[0]
      let p3 = data[1]
      
      return [BezierSegmentControlPoints(firstControlPoint: p0, secondControlPoint: p3)]
    } else if segments > 1 {
      
      //left hand side coefficients
      var aboveDiagonal = [CGFloat]()
      var diagonal = [CGFloat]()
      var belowDiagonal = [CGFloat]()
      
      var rhsArray = [CGPoint]()
      
      for i in 0..<segments {
        
        var rhsXValue : CGFloat = 0
        var rhsYValue : CGFloat = 0
        
        let p0 = data[i]
        let p3 = data[i+1]
        
        if i == 0 {
          belowDiagonal.append(0.0)
          diagonal.append(2.0)
          aboveDiagonal.append(1.0)
          
          rhsXValue = p0.x + 2*p3.x
          rhsYValue = p0.y + 2*p3.y
          
        } else if i == segments - 1 {
          belowDiagonal.append(2.0)
          diagonal.append(7.0)
          aboveDiagonal.append(0.0)
          
          rhsXValue = 8 * p0.x + p3.x
          rhsYValue = 8 * p0.y + p3.y
        } else {
          belowDiagonal.append(1.0)
          diagonal.append(4.0)
          aboveDiagonal.append(1.0)
          
          rhsXValue = 4 * p0.x + 2 * p3.x
          rhsYValue = 4 * p0.y + 2 * p3.y
        }
        
        rhsArray.append(CGPoint(x: rhsXValue, y: rhsYValue))
      }
      return thomasAlgorithm(belowDiagonal: belowDiagonal, diagonal: diagonal, aboveDiagonal: aboveDiagonal, rhsArray: rhsArray, segments: segments, data: data)
    }
    
    return []
  }
  
  func thomasAlgorithm(belowDiagonal: [CGFloat], diagonal: [CGFloat], aboveDiagonal: [CGFloat], rhsArray: [CGPoint], segments: Int, data: [CGPoint]) -> [BezierSegmentControlPoints] {
    
    var controlPoints : [BezierSegmentControlPoints] = []
    var rhsArray = rhsArray
    let segments = segments
    
    var solutionSet1 = [CGPoint?]()
    solutionSet1 = Array(repeating: nil, count: segments)
    var aboveDiagonal = aboveDiagonal
    
    //First segment
    aboveDiagonal[0] = aboveDiagonal[0] / diagonal[0]
    rhsArray[0].x = rhsArray[0].x / diagonal[0]
    rhsArray[0].y = rhsArray[0].y / diagonal[0]
    
    //Middle Elements
    if segments > 2 {
      for i in 1...segments - 2  {
        let rhsValueX = rhsArray[i].x
        let prevRhsValueX = rhsArray[i - 1].x
        
        let rhsValueY = rhsArray[i].y
        let prevRhsValueY = rhsArray[i - 1].y
        
        aboveDiagonal[i] = aboveDiagonal[i] / (diagonal[i] - belowDiagonal[i]*aboveDiagonal[i-1]);
        
        let exp1x = (rhsValueX - (belowDiagonal[i]*prevRhsValueX))
        let exp1y = (rhsValueY - (belowDiagonal[i]*prevRhsValueY))
        let exp2 = (diagonal[i] - belowDiagonal[i]*aboveDiagonal[i-1])
        
        rhsArray[i].x = exp1x / exp2
        rhsArray[i].y = exp1y / exp2
      }
    }
    
    //Last Element
    let lastElementIndex = segments - 1
    let exp1 = (rhsArray[lastElementIndex].x - belowDiagonal[lastElementIndex] * rhsArray[lastElementIndex - 1].x)
    let exp1y = (rhsArray[lastElementIndex].y - belowDiagonal[lastElementIndex] * rhsArray[lastElementIndex - 1].y)
    let exp2 = (diagonal[lastElementIndex] - belowDiagonal[lastElementIndex] * aboveDiagonal[lastElementIndex - 1])
    rhsArray[lastElementIndex].x = exp1 / exp2
    rhsArray[lastElementIndex].y = exp1y / exp2
    
    solutionSet1[lastElementIndex] = rhsArray[lastElementIndex]
    
    for i in (0..<lastElementIndex).reversed() {
      let controlPointX = rhsArray[i].x - (aboveDiagonal[i] * solutionSet1[i + 1]!.x)
      let controlPointY = rhsArray[i].y - (aboveDiagonal[i] * solutionSet1[i + 1]!.y)
      
      solutionSet1[i] = CGPoint(x: controlPointX, y: controlPointY)
    }
    
    firstControlPoints = solutionSet1
    
    for i in (0..<segments) {
      if i == (segments - 1) {
        
        let lastDataPoint = data[i + 1]
        let p1 = firstControlPoints[i]
        guard let controlPoint1 = p1 else { continue }
        
        let controlPoint2X = (0.5)*(lastDataPoint.x + controlPoint1.x)
        let controlPoint2y = (0.5)*(lastDataPoint.y + controlPoint1.y)
        
        let controlPoint2 = CGPoint(x: controlPoint2X, y: controlPoint2y)
        secondControlPoints.append(controlPoint2)
      }else {
        
        let dataPoint = data[i+1]
        let p1 = firstControlPoints[i+1]
        guard let controlPoint1 = p1 else { continue }
        
        let controlPoint2X = 2*dataPoint.x - controlPoint1.x
        let controlPoint2Y = 2*dataPoint.y - controlPoint1.y
        
        secondControlPoints.append(CGPoint(x: controlPoint2X, y: controlPoint2Y))
      }
    }
    
    for i in (0..<segments) {
      guard let firstCP = firstControlPoints[i] else { continue }
      guard let secondCP = secondControlPoints[i] else { continue }
      
      let segmentControlPoint = BezierSegmentControlPoints(firstControlPoint: firstCP, secondControlPoint: secondCP)
      controlPoints.append(segmentControlPoint)
    }
    
    return controlPoints
  }
  
}
