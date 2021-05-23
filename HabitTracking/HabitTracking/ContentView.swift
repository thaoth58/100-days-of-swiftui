//
//  ContentView.swift
//  HabitTracking
//
//  Created by Thao Truong on 23/05/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits()
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { item in
                    NavigationLink(
                        destination: HabitDetailView(habit: item)) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 10) {
                                IconView(iconName: item.iconName)
                                
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    
                                    Text(item.description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                            }
                            
                            ProgressView(currentAmount: item.currentAmount, target: item.target)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                showingAddHabit = true
            }, label: {
                Image(systemName: "plus")
            }))
            .navigationTitle("Habit Tracking")
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView(habits: habits)
        }
    }
    
    func removeItems(at offset: IndexSet) {
        habits.items.remove(atOffsets: offset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
