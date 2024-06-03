//
//  NewUserView.swift
//  DemoApp
//
//  Created by Tim Bugai on 5/29/24.
//

import SwiftUI
import ProTrainingsKit

struct NewUserView: View {
  @State var client: ProTrainingsClient?
  @State var apiKey = "API Key Missing!"
  @State private var showAlert: Bool = false
  @State private var alertMessage: String = ""
  
  @State private var firstName: String = ""
  @State private var lastName: String = ""
  @State private var login: String = ""
  @State private var email: String = ""
 
  @State private var magicLink: String = ""
  @State private var webViewVisible: Bool = false
  
  var body: some View {
    VStack {
      Form {
        Section("User Info") {
          HStack {
            Text("First Name")
              .bold()
            TextField("John", text: $firstName)
          }
          HStack{
            Text("Last Name")
              .bold()
            TextField("Doe", text: $lastName)
          }
          HStack {
            Text("Login")
              .bold()
            TextField("jdoe", text: $login)
              .textInputAutocapitalization(.never)
              .autocorrectionDisabled()
              .keyboardType(.emailAddress)
          }
          HStack {
            Text("Email")
              .bold()
            TextField("jdoe@example.com", text: $email)
              .textInputAutocapitalization(.never)
              .autocorrectionDisabled()
          }
        }
        Button(action: {
          Task {
            if let client = client {
              let (newUser, err) = await client.createUser(
                login: login,
                email: email,
                lastName: lastName,
                firstName: firstName)
              
              if err != nil {
                if err == .invalidData || err == .userAlreadyExists{
                  showAlert = true
                  alertMessage = err?.localizedDescription ?? "Generic Error"
                } else {
                  showAlert = true
                  alertMessage = "An unknown error occured..."
                }
              } else {
                if let user = newUser, 
                    let link = await client.getMagicLink(login: user.login) {
                  
                  self.magicLink = link
                  self.webViewVisible = true
                }
              }
            }
          }
        }, label: {
          Text("Create New User")
        })
        .alert("Uh oh!", isPresented: $showAlert) {
          Button("Ok", role: .cancel) {}
        } message: {
          Text(alertMessage)
        }
        
        Section("Developer Notes") {
          Text("Upon user creation, this demo app will automatically login with the created credentials.")
          Text("It is up to the developer to store their password securely for use later.")
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
    NewUserView()
}
