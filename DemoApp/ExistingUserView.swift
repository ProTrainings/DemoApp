//
//  NewUserView.swift
//  DemoApp
//
//  Created by Tim Bugai on 5/29/24.
//

import SwiftUI
import ProTrainingsKit

struct ExistingUserView: View {
  @State var client: ProTrainingsClient?
  @State var apiKey = "API Key Missing!"
  @State private var showAlert: Bool = false
  @State private var alertMessage: String = ""
  
  @State private var login: String = ""
  @State private var password: String = ""
  
  @State private var webViewVisible: Bool = false
  @State private var magicLink: String?
  
  var body: some View {
    VStack {
      Form {
        Section("User Info") {
          HStack {
            Text("Login")
              .bold()
            TextField("jdoe", text: $login)
              .autocapitalization(.none)
              .autocorrectionDisabled()
          }
          HStack {
            Text("Password")
              .bold()

            SecureField("Password", text: $password)
          }
        }
        Button(action: {
          Task {
            if let client = client, let magicLink =  await client.getMagicLink(login: login) {
              self.magicLink = magicLink
              self.webViewVisible = true
            } else {
              showAlert = true
              alertMessage = "No user found with that login."
            }
          }
        }, label: {
          Text("Login")
        })
        .alert("Uh oh!", isPresented: $showAlert) {
          Button("Ok", role: .cancel) {}
        } message: {
          Text(alertMessage)
        }
      }
      HStack {
        Text("API Key:")
          .font(.caption2)
        Text(apiKey)
          .font(.caption)
      }
    }
    .task {
      if let apiKey = Bundle.main.object(forInfoDictionaryKey: "ProTrainings API Key") as? String {
        
        self.apiKey = apiKey
        self.client = ProTrainingsClient(apiKey: apiKey)
      }
    }
    .navigationDestination(isPresented: $webViewVisible) { 
      ProTrainingsWebView(magicLink: self.$magicLink)
    }
  }
}

#Preview {
  ExistingUserView()
}
