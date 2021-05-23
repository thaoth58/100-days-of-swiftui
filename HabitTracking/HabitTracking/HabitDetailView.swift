//
//  HabitDetailView.swift
//  HabitTracking
//
//  Created by Thao Truong on 23/05/2021.
//

import SwiftUI

struct HabitDetailView: View {
    @State var habit: HabitItem
    @ObservedObject var habits: Habits
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                IconView(iconName: habit.iconName, iconSize: 60)
                
                Text(habit.title)
                    .font(.largeTitle)
                
                Spacer()
            }
            
            Text(habit.description)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Progress \(habit.currentAmount)/\(habit.target)")
                ProgressView(currentAmount: habit.currentAmount, target: habit.target)
                    .frame(height: 10)
            }
            
            Button("Done for today") {
                withAnimation {
                    habit.currentAmount += 1
                    
                    // Must update original item in array too, not just copy item
                    if let index = habits.items.firstIndex(where: { $0.id == habit.id }) {
                        habits.items[index].currentAmount += 1
                    }
                }
            }.disabled(habit.currentAmount >= habit.target)
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProgressView: View {
    let currentAmount: Int
    let target: Int
    
    var perecent: CGFloat {
        CGFloat(currentAmount) / CGFloat(target)
    }
    var progressColor: Color {
        if perecent < 0.3 {
            return .red
        } else if perecent < 1 {
            return .blue
        }
        return .green
    }
    
    var body: some View {
        ZStack {
            LineProgress(percent: 1)
                .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            
            LineProgress(percent: perecent)
                .strokeBorder(progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
        }
    }
}

struct LineProgress: InsettableShape {
    var percent: CGFloat
    private var insetAmount: CGFloat = 0
    
    var animatableData: CGFloat {
        get { percent }
        set { self.percent = newValue }
    }
    
    init(percent: CGFloat) {
        self.percent = percent
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0 + insetAmount, y: rect.midY))
        
        // Calculate length of line based on percent
        let lineLength = (rect.maxX - insetAmount) * percent
        
        path.addLine(to: CGPoint(x: lineLength, y: rect.midY))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var line = self
        line.insetAmount += amount
        return line
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let habit = HabitItem(title: "Walking", description: "Walking is good", target: 10, iconName: "icon-1")
        HabitDetailView(habit: habit, habits: Habits())
    }
}
