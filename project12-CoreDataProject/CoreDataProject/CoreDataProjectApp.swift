//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Thao Truong on 26/05/2021.
//

import SwiftUI
import CoreData

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        persistenceController.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
