//
//  VedantaApp.swift
//  Vedanta
//
//  Created by Mac on 21/12/24.
//

import SwiftUI

@main
struct VedantaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
