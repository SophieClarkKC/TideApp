//
//  TimeLines.swift
//  TideApp
//
//  Created by Sophie Clark on 19/05/2021.
//

import SwiftUI

struct TimeLines: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.width * 0.25, y: 0))
    path.addLine(to: CGPoint(x: rect.width * 0.25, y: rect.height))
    path.move(to: CGPoint(x: rect.width * 0.5, y: 0))
    path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height))
    path.move(to: CGPoint(x: rect.width * 0.75, y: 0))
    path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.height))
    
    return path
  }
}
