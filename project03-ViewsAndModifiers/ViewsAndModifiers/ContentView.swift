//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Thao Truong on 17/05/2021.
//

import SwiftUI

struct ContentView: View {
    private let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var selectedMove = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var totalQuestion = 0
    @State private var totalPoint = 0
    
    var isGameEnded: Bool {
        return totalQuestion == 10
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green, .purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Text("My move")
                        .font(.title)
                    MoveImage(imageName: moves[selectedMove])
                }
                
                Text("Select your move to \(shouldWin ? "WIN" : "LOSE") this game")
                HStack {
                    ForEach(0..<moves.count) { number in
                        Button (action: {
                            self.selectedMove(number: number)
                        }, label: {
                            MoveImage(imageName: moves[number])
                        })
                    }
                }
                
                if isGameEnded {
                    Text("Your point: \(totalPoint)")
                } else {
                    Text("\(10 - totalQuestion) matches left")
                }
                Spacer()
                
            }
            .foregroundColor(.white)
        }
        .disabled(isGameEnded)
    }
    
    func selectedMove(number: Int) {
        totalQuestion += 1
        
        let result = (number - selectedMove) * (shouldWin ? 1: -1)
        
        if (result == 1 || result == -2) {
            totalPoint += 1
        }
        
        if !isGameEnded {
            resetQuestion()
        }
    }
    
    func resetQuestion() {
        selectedMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

struct MoveImage: View {
    var imageName: String
    
    let rounded = RoundedRectangle(cornerRadius: 10)
    
    var body: some View {
        Text(imageName)
            .frame(width: 100, height: 100)
            .clipShape(rounded)
            .overlay(rounded.stroke(Color.black, lineWidth: 1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
