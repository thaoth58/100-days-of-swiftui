//
//  ContentView.swift
//  EasyMultiplication
//
//  Created by Thao Truong on 19/05/2021.
//

import SwiftUI

enum GameState {
    case selectTable
    case selectNumberQuestion
    case start
}

struct Question: Equatable {
    var num1: Int
    var num2: Int
    var result: Int {
        num1 * num2
    }
    
}

struct ContentView: View {
    @State private var gameState: GameState = .selectTable
    
    @State private var selectedNumber = 1
    @State private var numQuestions = 0
    
    @State private var questions = [Question]()
    
    @State private var currentQuestion = 0
    
    @State private var score = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green, .yellow]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Group {
                if gameState == .selectTable {
                    TableSelection { number in
                        selectMultiplication(number: number)
                    }
                    .transition(.scale)
                } else if gameState == .selectNumberQuestion {
                    NumQuestionSelection { item in
                        selectNumQuestion(item: item)
                    }
                    .transition(.scale)
                } else if gameState == .start {
                    if currentQuestion % 2 == 0 {
                        QuestionAnswer(question: questions[currentQuestion]) { isCorrect in
                            if isCorrect {
                                score += 1
                            }
                            self.nextQuestion()
                        }
                        .transition(.slide)
                    } else {
                        QuestionAnswer(question: questions[currentQuestion]) { isCorrect in
                            if isCorrect {
                                score += 1
                            }
                            self.nextQuestion()
                        }
                        .transition(.slide)
                    }
                }
            }
        }
    }
    
    func selectMultiplication(number: Int) {
        withAnimation {
            gameState = .selectNumberQuestion
            selectedNumber = number + 1
        }
    }
    
    func selectNumQuestion(item: String) {
        numQuestions = Int(item) ?? selectedNumber
        generateQuestions()
    }
    
    func generateQuestions() {
        // Generate all combinations from 1 to selectedNumber
        if selectedNumber == numQuestions {
            questions = (1...selectedNumber).map {
                Question(num1: selectedNumber, num2: $0)
            }.shuffled()
        } else {
            questions = (1...numQuestions).map {_ in
                let num2 = Int.random(in: 1...selectedNumber)
                return Question(num1: selectedNumber, num2: num2)
            }.shuffled()
        }
        
        withAnimation {
            gameState = .start
        }
    }
    
    func nextQuestion() {
        guard currentQuestion < questions.count - 1 else { return }
        
        withAnimation {
            currentQuestion += 1
        }
    }
}

struct Option: View {
    let title: String
    let action: () -> ()
    
    @State private var scaleAmount: CGFloat = 1.0
    @State private var degreeAmount = 0.0
    
    var body: some View {
        Button(action: buttonAction, label: {
            ZStack {
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.purple)
                Text(title)
                    .foregroundColor(.white)
                    .font(.title)
            }
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple, lineWidth: 1))
        .shadow(color: .black, radius: 2)
        .scaleEffect(scaleAmount)
        .rotation3DEffect(
            .degrees(degreeAmount),
            axis: (x: 0, y: 0, z: 1)
        )
    }
    
    func buttonAction() {
        // Perform animation
        
        withAnimation(.easeIn(duration: 0.2)) {
            scaleAmount = 1.2
        }
        
        degreeAmount = -10
        withAnimation(.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true)) {
            degreeAmount = 20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            action()
            scaleAmount = 1
            degreeAmount = 0
        }
    }
}

struct TableSelection: View {
    var didSelectNumber: (Int) -> Void
    
    @State private var selectedNumber = -1
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Pick a number")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(20)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 15) {
                ForEach(0..<4) { number in
                    Option(title: "\(number + 1)") {
                        didSelectNumber(number)
                    }
                }
            }
            
            HStack(spacing: 15) {
                ForEach(5..<9) { number in
                    Option(title: "\(number + 1)") {
                        didSelectNumber(number)
                    }
                }
            }
            
            HStack(spacing: 15) {
                ForEach(9..<12) { number in
                    Option(title: "\(number + 1)") {
                        didSelectNumber(number)
                    }
                }
            }
        }
    }
}

struct NumQuestionSelection: View {
    let numQuestions = ["5", "10", "20", "All"]
    var didSelectNumQuestion: (String) -> Void
    
    var body: some View {
        VStack {
            Text("How many questions do you want?")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(20)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 15) {
                ForEach(numQuestions, id: \.self) { item in
                    Option(title: item) {
                        didSelectNumQuestion(item)
                    }
                }
            }
        }
    }
}

struct QuestionAnswer: View {
    @State private var answer = ""
    
    var question: Question
    var didAnswer: (Bool) -> Void
    
    var body: some View {
        VStack {
            Text("Answer this")
            Text("\(question.num1) x \(question.num2)")
                .font(.largeTitle)
            
            TextField("", text: $answer, onCommit: onCommit)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(40)
                .foregroundColor(.black)
            
            Spacer()
        }
        .foregroundColor(.white)
        .onChange(of: question, perform: { value in
            
        })
    }
    
    func onCommit() {
        let answerInt = Int(answer) ?? -1
        didAnswer(answerInt == question.result)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
