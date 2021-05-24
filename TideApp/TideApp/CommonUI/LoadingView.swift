//
//  LoadingView.swift
//  TideApp
//
//  Created by Dan Smith on 24/05/2021.
//

import SwiftUI

struct LoadingView: View {

  var body: some View {
    ZStack {
      Color.backgroundColor
        .ignoresSafeArea()

        Spinner()

        TitleLabel(text: "Loading")
    }
  }
}

struct Spinner: View {
  let animationTime: Double = 1.9
  let rotationTime: Double = 0.75
  let fullRotation: Angle = .degrees(360)
  static let initialDegree: Angle = .degrees(270)

  @State var spinnerStart: CGFloat = 0.0
  @State var spinnerEndS1: CGFloat = 0.03
  @State var spinnerEndS2S3: CGFloat = 0.03

  @State var rotationDegreesS1 = initialDegree
  @State var rotationDegreesS2 = initialDegree
  @State var rotationDegreesS3 = initialDegree

  var body: some View {
    ZStack {
      Color.backgroundColor
        .opacity(0.1)
        .ignoresSafeArea()

      ZStack {
        // Spinner 3
        SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreesS3, color: .titleColor)
          .opacity(0.25)

        // Spinner 2
        SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreesS2, color: .titleColor)
          .opacity(0.75)

        // Spinner 1
        SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreesS1, color: .titleColor)
          .opacity(1)
      }
      .frame(width: 200, height: 200)
    }
    .onAppear() {
      Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { (mainTimer) in
        self.animateSpinner()
      }
    }
  }

  // MARK: - Animation methods
  func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
    Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
      withAnimation(Animation.easeInOut(duration: self.rotationTime)) {
        completion()
      }
    }
  }

  func animateSpinner() {
    animateSpinner(with: rotationTime) {
      self.spinnerEndS1 = 1.0
    }

    animateSpinner(with: (rotationTime * 2) - 0.025) {
      self.rotationDegreesS1 += fullRotation
      self.spinnerEndS2S3 = 0.8
    }

    animateSpinner(with: (rotationTime * 2)) {
      self.spinnerEndS1 = 0.03
      self.spinnerEndS2S3 = 0.03
    }

    animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreesS2 += fullRotation }

    animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreesS3 += fullRotation }
  }
}

struct SpinnerCircle: View {
  var start: CGFloat
  var end: CGFloat
  var rotation: Angle
  var color: Color

  var body: some View {
    Circle()
      .trim(from: start, to: end)
      .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
      .fill(color)
      .rotationEffect(rotation)
  }
}

struct Spinner_Previews: PreviewProvider {
  static var previews: some View {
    Spinner()
  }
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingView()
  }
}
