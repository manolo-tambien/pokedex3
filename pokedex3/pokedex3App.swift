//
//  pokedex3App.swift
//  pokedex3
//
//  Created by Manolo on 14/02/24.
//

import SwiftUI

@main
struct pokedex3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
