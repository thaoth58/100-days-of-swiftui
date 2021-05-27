//
//  FriendZoneApp.swift
//  FriendZone
//
//  Created by Thao Truong on 27/05/2021.
//

import SwiftUI

@main
struct FriendZoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
