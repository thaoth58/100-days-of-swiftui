//
//  AddHabitView.swift
//  HabitTracking
//
//  Created by Thao Truong on 23/05/2021.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var habits: Habits
    
    @State private var title = ""
    @State private var description = ""
    @State private var target = 5
    @State private var selectedIcon = 0
    
    var isDisableSave: Bool {
        title.isEmpty || description.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Title", text: $title)
                    
                    TextField("Description", text: $description)
                    
                    Stepper(value: $target, in: 1...20) {
                        HStack {
                            Text("Target")
                            
                            Spacer()
                            
                            Text("\(target)")
                        }
                    }
                    
                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(0..<36) {
                            IconView(iconName: "icon-\($0 + 1)")
                        }
                    }
                }
            }
            .navigationBarTitle("Add new habit", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: saveHabit, label: {
                Text("Save")
            }).disabled(isDisableSave))
        }
    }
    
    func saveHabit() {
        let habit = HabitItem(title: title, description: description, target: target, iconName: "icon-\(selectedIcon + 1)")
        habits.items.append(habit)
        presentationMode.wrappedValue.dismiss()
    }
}

struct IconView: View {
    let iconName: String
    var iconSize: CGFloat = 30.0
    
    var body: some View {
        ZStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 2)
                )
                .shadow(radius: 10)
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habits: Habits())
    }
}
