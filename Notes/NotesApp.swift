//
//  NotesApp.swift
//  Notes
//
//  Created by Lena Vadakkel on 03.11.23.
//

import SwiftUI

@main
struct NotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
