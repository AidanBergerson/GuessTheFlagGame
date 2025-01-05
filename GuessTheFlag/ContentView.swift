//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aidan Bergerson on 12/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany" ,"Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var userScore = 0
    
    @State private var showingReset = false
    @State private var resetGame = false
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack {
            // MARK: Linear Gradient
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.7, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                
                VStack(spacing: 15) {
                    // MARK: Text Content
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            
                    }
                  
                    // MARK: Country Flags
                    ForEach(0..<3, id: \.self) { number in
                        Button {
                            if userScore < 7 {
                                flagTapped(number)
                                print(userScore)
                            } else {
                                resetGame = true
                            }
                            
                            withAnimation {
                                animationAmount += 360
                            }
                            
                        } label: {
                            FlagImage(number)
                        }
                        .rotation3DEffect(.degrees(animationAmount), axis: number == correctAnswer ? (x: 0, y: 1, z: 0) : (x: 0, y: 0, z: 0))
                       
                        
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        .alert("Yay, You Won!", isPresented: $resetGame) {
            Button("New Game", action: reset)
        } message: {
            Text("Do you want to play again?")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the \(countries[number]) flag"
            userScore = 0
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
            askQuestion()
            userScore = 0
    }
    
    @ViewBuilder func FlagImage(_ number: Int) -> some View {
        Image(countries[number])
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
