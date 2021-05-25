//
//  AddBookView.swift
//  Bookworm
//
//  Created by Thao Truong on 25/05/2021.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var review = ""
    @State private var rating = 3
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name'", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)
                    
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        saveBook()
                    }
                }
            }
            .navigationTitle("Add book")
        }
    }
    
    func saveBook() {
        let book = Book(context: moc)
        book.id = UUID()
        book.title = title
        book.author = author
        book.genre = genre
        book.review = review
        book.rating = Int16(rating)
        
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
