//
//  ContentView.swift
//  iExpense
//
//  Created by Thao Truong on 20/05/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text("$\(item.amount)").amountStyle(amount: item.amount)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                                    showingAddExpense = true
                                }, label: {
                                    Image(systemName: "plus")
                                }))
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpense(expenses: expenses)
        }
    }
    
    func removeItems(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}

extension View {
    func amountStyle(amount: Int) -> some View {
        if amount < 10 {
            return self.foregroundColor(.black)
        } else if amount < 100 {
            return self.foregroundColor(.green)
        } else {
            return self.foregroundColor(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
