//
//  ContentView.swift
//  Bookworm
//
//  Created by Thao Truong on 25/05/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddBook = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        
                            Spacer(minLength: 8)
                        
                            Text("\(book.rating)")
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }.onDelete(perform: deleteBooks)
            }
            .navigationTitle("Book worm")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                showingAddBook.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddBook) {
                AddBookView().environment(\.managedObjectContext, moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
