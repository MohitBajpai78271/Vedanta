//
//  SettingsView.swift
//  Vedanta
//
//  Created by Mac on 21/12/24.
//

import SwiftUI

struct SettingsView: View {
      @State private var isDarkMode: Bool = false
      @State private var isNotificationsEnabled: Bool = true
      @State private var isSoundEnabled: Bool = true
      @State private var selectedLanguage: String = "English"
      
      var body: some View {
//          NavigationView {
              Form {
                  Section(header: Text("Appearance")) {
                      Toggle("Dark Mode", isOn: $isDarkMode)
                      Picker("Language", selection: $selectedLanguage) {
                          Text("English").tag("English")
                          Text("Spanish").tag("Spanish")
                          Text("French").tag("French")
                      }
                  }
                  
                  Section(header: Text("Notifications")) {
                      Toggle("Enable Notifications", isOn: $isNotificationsEnabled)
                  }
                  
                  Section(header: Text("Sounds & Vibration")) {
                      Toggle("Sound Effects", isOn: $isSoundEnabled)
                      Toggle("Vibrate on New Message", isOn: $isSoundEnabled) // You can set this separately if you want different controls
                  }
                  
                  Section(header: Text("Account")) {
                      Button("Profile Management") {
                          // Navigate to Profile view
                      }
                      Button("Logout") {
                          // Handle logout
                      }
                  }
                  
                  Section(header: Text("Privacy")) {
                      Button("Clear Chat History") {
                          // Clear the chat history
                      }
                      Toggle("Share Data for Analytics", isOn: $isSoundEnabled) // Example toggle
                  }
                  
                  Section(header: Text("App Info")) {
                      Text("App Version: 1.0.0")
                      Link("Terms of Service", destination: URL(string: "https")!)
                      Link("Privacy Policy", destination: URL(string: "https:")!)
                  }
                  
                  Section(header: Text("Help")) {
                      Button("FAQ") {
                          // Open FAQ page
                      }
                      Button("Contact Support") {
                          // Open contact support view
                      }
                  }
              }
              .navigationTitle("Settings")
          }
//      }
}

#Preview {
    SettingsView()
}
