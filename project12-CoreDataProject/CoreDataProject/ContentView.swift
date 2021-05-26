//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Thao Truong on 26/05/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc

    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(countries, id: \.self) { country in
                        Section(header: Text(country.wrappedFullName)) {
                            ForEach(country.candyArray, id: \.self) { candy in
                                Text(candy.wrappedName)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Core Data Example")
            .navigationBarItems(trailing: Button(action: {
                addMockData()
            }) {
                Image(systemName: "plus")
            })
        }
    }
    
    func addMockData() {
        let candy1 = Candy(context: self.moc)
        candy1.name = "Mars"
        candy1.origin = Country(context: self.moc)
        candy1.origin?.shortName = "UK"
        candy1.origin?.fullName = "United Kingdom"

        let candy2 = Candy(context: self.moc)
        candy2.name = "KitKat"
        candy2.origin = Country(context: self.moc)
        candy2.origin?.shortName = "UK"
        candy2.origin?.fullName = "United Kingdom"

        let candy3 = Candy(context: self.moc)
        candy3.name = "Twix"
        candy3.origin = Country(context: self.moc)
        candy3.origin?.shortName = "UK"
        candy3.origin?.fullName = "United Kingdom"

        let candy4 = Candy(context: self.moc)
        candy4.name = "Toblerone"
        candy4.origin = Country(context: self.moc)
        candy4.origin?.shortName = "CH"
        candy4.origin?.fullName = "Switzerland"

        try? self.moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}