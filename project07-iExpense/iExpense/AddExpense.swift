//
//  AddExpense.swift
//  iExpense
//
//  Created by Thao Truong on 20/05/2021.
//

import SwiftUI

struct AddExpense: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    let types = ["Business", "Personal"]
    
    @ObservedObject var expenses: Expenses
    
    private var isItemInvalid: Bool {
        guard Int(amount) != nil else { return true }
        return name.isEmpty || type.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text("\($0)")
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add new expense")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: name, type: type, amount: actualAmount)
                    expenses.items.append(item)
                    presentationMode.wrappedValue.dismiss()
                }
            }.disabled(isItemInvalid))
        }
    }
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense(expenses: Expenses())
    }
}
