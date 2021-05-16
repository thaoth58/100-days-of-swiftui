//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Thao Truong on 16/05/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var totalQuestions = 0
    @State private var correctQuestions = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(Color.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }, label: {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    })
                }
                
                VStack {
                    Text("Total: \(totalQuestions)")
                        .foregroundColor(.white)
                    
                    Text("Correct: \(correctQuestions)")
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text(""), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            correctQuestions += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        totalQuestions += 1
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
