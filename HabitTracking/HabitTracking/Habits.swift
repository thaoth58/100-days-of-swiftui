//
//  Habits.swift
//  HabitTracking
//
//  Created by Thao Truong on 23/05/2021.
//

import Foundation

struct HabitItem: Codable, Identifiable {
    var id = UUID()
    let title: String
    let description: String
    let target: Int
    let iconName: String
    var currentAmount = 1
}

class Habits: ObservableObject {
    private static let savedKey = "items"
    
    @Published var items: [HabitItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: Habits.savedKey)
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Habits.savedKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([HabitItem].self, from: data) {
                items = decoded
                return
            }
        }
        self.items = [HabitItem]()
    }
}
