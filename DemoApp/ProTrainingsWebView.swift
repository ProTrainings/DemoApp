//
//  ProTrainingsWebView.swift
//  DemoApp
//
//  Created by Tim Bugai on 5/30/24.
//

import SwiftUI
import WebKit

struct ProTrainingsWebView: View {
  @Binding var isVisible: Bool
  @State var magicLink: String
  
  var body: some View {
    VStack {
      HStack {
        Button("Logout") {
          isVisible = false
        }
        Spacer()
      }.padding()

      WebView(link: magicLink)
    }
  }
}

#Preview {
  ProTrainingsWebView(
    isVisible: .constant(true),
    magicLink: "http://www.google.com"
  )
}

struct WebView: UIViewRepresentable {
  var link: String?
  let webView: WKWebView
  
  init() {
    webView = WKWebView(frame: .zero)
  }
  
  init(link: String) {
    webView = WKWebView(frame: .zero)
    self.link = link
  }
  
  func makeUIView(context: Context) -> some UIView {
    return webView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    if let link = link, let url = URL(string: link) {
      let urlRequest = URLRequest(url: url)
      webView.load(urlRequest)
    }
  }
}
