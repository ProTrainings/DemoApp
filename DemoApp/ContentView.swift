//
//  ContentView.swift
//  DemoApp
//
//  Created by Tim Bugai on 5/28/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      TabView {
        NewUserView()
          .tabItem {
            Label("New User", systemImage: "person.badge.plus")
          }
        ExistingUserView()
          .tabItem {
            Label("Existing User", systemImage: "person.circle")
          }
      }
    }
  }
}

#Preview {
  ContentView()
}
