//
//  ActivityIndicator.swift
//  DemoApp
//
//  Created by Tim Bugai on 5/31/24.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  @Binding var isAnimating: Bool
  let style: UIActivityIndicatorView.Style
  
  func makeUIView(context: Context) -> some UIView {
    return UIActivityIndicatorView(style: style)
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    if let view = uiView as? UIActivityIndicatorView {
      isAnimating ? view.startAnimating() : view.stopAnimating()
    }
  }
}
