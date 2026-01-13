//
//  PracticeView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct PracticeView: View {
    let questionSet: QuestionSet
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var showingAnswer = false
    @State private var wrongQuestions: [Question] = []
    @State private var currentRound: [Question] = []
    @State private var isComplete = false
    @State private var totalQuestionsAnswered = 0
    
    init(questionSet: QuestionSet) {
        self.questionSet = questionSet
        _currentRound = State(initialValue: questionSet.questions)
    }
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < currentRound.count else { return nil }
        return currentRound[currentQuestionIndex]
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isComplete {
                    completionView
                } else if let question = currentQuestion {
                    practiceCard(for: question)
                } else {
                    Text("No questions available")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(questionSet.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Exit") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func practiceCard(for question: Question) -> some View {
        VStack(spacing: 20) {
            // Progress indicator
            HStack {
                Text("\(currentQuestionIndex + 1) of \(currentRound.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if !wrongQuestions.isEmpty {
                    Text("Wrong: \(wrongQuestions.count)")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Question Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Question")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                                .textCase(.uppercase)
                            Spacer()
                        }
                        
                        Text(question.questionText)
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
                    
                    // Answer Card (revealed on tap)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Answer")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.green)
                                .textCase(.uppercase)
                            Spacer()
                            if !showingAnswer {
                                Text("Tap to reveal")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if showingAnswer {
                            Text(question.answerText)
                                .font(.body)
                                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        } else {
                            Text("Think about your answer first...")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(showingAnswer ? Color.green.opacity(0.05) : Color(.systemGray6))
                    .cornerRadius(16)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            showingAnswer = true
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Action Buttons
            if showingAnswer {
                VStack(spacing: 12) {
                    Button(action: markAsCorrect) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Got it Right")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: markAsWrong) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Got it Wrong")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "star.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
            
            Text("Practice Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("You answered all questions correctly!")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Total Questions:")
                    Spacer()
                    Text("\(totalQuestionsAnswered)")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Questions Set:")
                    Spacer()
                    Text(questionSet.title)
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Done")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func markAsCorrect() {
        withAnimation {
            totalQuestionsAnswered += 1
            moveToNextQuestion()
        }
    }
    
    private func markAsWrong() {
        withAnimation {
            if let question = currentQuestion {
                wrongQuestions.append(question)
            }
            totalQuestionsAnswered += 1
            moveToNextQuestion()
        }
    }
    
    private func moveToNextQuestion() {
        showingAnswer = false
        
        if currentQuestionIndex < currentRound.count - 1 {
            // Move to next question
            currentQuestionIndex += 1
        } else {
            // Round complete
            if wrongQuestions.isEmpty {
                // All done!
                isComplete = true
            } else {
                // Start new round with wrong questions
                currentRound = wrongQuestions
                wrongQuestions = []
                currentQuestionIndex = 0
            }
        }
    }
}

#Preview {
    PracticeView(questionSet: QuestionSet(
        title: "Swift Basics",
        questions: [
            Question(questionText: "What does SwiftUI use for state management?", answerText: "@State, @Binding, @ObservedObject, @StateObject, @EnvironmentObject"),
            Question(questionText: "What is the difference between a struct and a class?", answerText: "Structs are value types, classes are reference types. Structs don't support inheritance."),
            Question(questionText: "What is a closure in Swift?", answerText: "A self-contained block of functionality that can be passed around and used in your code.")
        ]
    ))
}
