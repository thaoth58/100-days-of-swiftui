//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Thao Truong on 16/05/2021.
//

import SwiftUI

enum AnswerType {
    case normal
    case correct
    case wrong
    case notSelect
}

struct ContentView: View {
    @State private var totalQuestions = 0
    @State private var correctQuestions = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var answerTypes = [AnswerType](repeating: .normal, count: 3)
    
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var result = ""
    
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
                        FlagImage(imageName: self.countries[number], answerType: self.answerTypes[number])
                    })
                }
                
                VStack {
                    Text("Total: \(totalQuestions)")
                    Text("Correct: \(correctQuestions)")
                }
                .foregroundColor(.white)
                
                if !result.isEmpty {
                    Text(result)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .transition(.scale)
                }
                
                Spacer()
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        totalQuestions += 1
        if number == correctAnswer {
            correctQuestions += 1
            answerTypes[number] = .correct
            withAnimation {
                result = "Exactly"
            }
        } else {
            answerTypes[number] = .wrong
            withAnimation {
                result = "Wrong"
            }
        }
        
        answerTypes = answerTypes.enumerated().map { index, element in
            if index != number {
                return .notSelect
            }
            return element
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            askQuestion()
        }
    }
    
    func askQuestion() {
        result = ""
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        answerTypes = [AnswerType](repeating: .normal, count: 3)
    }
}

struct FlagImage: View {
    var imageName: String
    var answerType: AnswerType
    
    @State private var rotateDegree = 0.0
    @State private var wrongDegree = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount: CGFloat = 1.0
    
    var body: some View {
        return Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
            .rotation3DEffect(
                .degrees(rotateDegree),
                axis: (x: 0, y: 1, z: 0)
            )
            .rotation3DEffect(
                .degrees(wrongDegree),
                axis: (x: 0, y: 0, z: 1)
            )
            .opacity(opacityAmount)
            .scaleEffect(scaleAmount)
            .onChange(of: answerType, perform: { value in
                if value == .correct {
                    withAnimation(.easeInOut(duration: 1)) {
                        rotateDegree = 360
                    }
                } else if value == .wrong {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        scaleAmount = 1.1
                    }
                    wrongDegree = -20
                    withAnimation(.easeIn(duration: 0.25).repeatCount(4, autoreverses: true)) {
                        wrongDegree = 20
                    }
                } else if value == .notSelect {
                    withAnimation(.easeIn(duration: 0.5)) {
                        opacityAmount = 0.6
                    }
                } else if value == .normal {
                    wrongDegree = 0
                    rotateDegree = 0
                    opacityAmount = 1.0
                    scaleAmount = 1.0
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
