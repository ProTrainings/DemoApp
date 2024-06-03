//
//  ProTrainingsWebView.swift
//  DemoApp
//
//  Created by Tim Bugai on 5/30/24.
//

import SwiftUI
import WebKit

struct ProTrainingsWebView: View {
  @Environment(\.dismiss) var dismiss

  @Binding var magicLink: String?
  @State private var isLoading: Bool = true
  
  var body: some View {
    VStack {
      WebView(
        link: magicLink!,
        isLoading: $isLoading
      )
    }
    .toolbar {
      ToolbarItemGroup(placement: .topBarTrailing) {
        ActivityIndicator(isAnimating: $isLoading, style: .large)
      }
    }
  }
}

#Preview {
  NavigationStack {
    ProTrainingsWebView(
      magicLink: .constant("http://www.google.com")
    )
  }
}

struct WebView: UIViewRepresentable {
  var link: String?
  @Binding var isLoading: Bool
  
  let webView: WKWebView = WKWebView(frame: .zero)
   
  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView
    
    init(_ parent: WebView) {
      self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      self.parent.isLoading = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      self.parent.isLoading = false
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  func makeUIView(context: Context) -> some UIView {
    return webView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    webView.navigationDelegate = context.coordinator
    
    print(self.link ?? "no link provided")
    if let link = link, let url = URL(string: link) {
      let urlRequest = URLRequest(url: url)
      webView.load(urlRequest)
    }
  }
}
