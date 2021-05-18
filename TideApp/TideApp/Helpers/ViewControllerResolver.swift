//
//  ViewControllerResolver.swift
//  TideApp
//
//  Created by John Sanderson on 17/05/2021.
//

import SwiftUI
import UIKit

/// Resolves the parent view controller of a swift UI view
final class ViewControllerResolver: UIViewControllerRepresentable {

  private let onResolve: (UIViewController) -> Void

  init(onResolve: @escaping (UIViewController) -> Void) {
    self.onResolve = onResolve
  }

  func makeUIViewController(context: Context) -> ParentResolverViewController {
    ParentResolverViewController(onResolve: onResolve)
  }

  func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
}

final class ParentResolverViewController: UIViewController {

  private let onResolve: (UIViewController) -> Void

  fileprivate init(onResolve: @escaping (UIViewController) -> Void) {
    self.onResolve = onResolve
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)
    if let parent = parent {
      onResolve(parent)
    }
  }
}
