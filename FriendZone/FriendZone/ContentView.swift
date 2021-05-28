//
//  ContentView.swift
//  FriendZone
//
//  Created by Thao Truong on 27/05/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        Text("Hello")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
