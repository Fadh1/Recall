//
//  MathPracticeSessionView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct MathPracticeSessionView: View {
    let questionSet: MathQuestionSet
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var userAnswers: [String: UserAnswer] = [:]
    @State private var showResults = false
    @State private var currentPracticeQuestions: [MathQuestion]
    
    init(questionSet: MathQuestionSet) {
        self.questionSet = questionSet
        self._currentPracticeQuestions = State(initialValue: questionSet.questions)
    }
    
    private var currentQuestion: MathQuestion? {
        guard currentQuestionIndex < currentPracticeQuestions.count else { return nil }
        return currentPracticeQuestions[currentQuestionIndex]
    }
    
    private var progress: Double {
        guard !currentPracticeQuestions.isEmpty else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(currentPracticeQuestions.count)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showResults {
                    resultsView
                } else if let question = currentQuestion {
                    questionView(for: question)
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
    private func questionView(for question: MathQuestion) -> some View {
        VStack(spacing: 0) {
            // Progress bar
            VStack(spacing: 8) {
                HStack {
                    Text("Question \(currentQuestionIndex + 1) of \(currentPracticeQuestions.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(question.marks) mark\(question.marks > 1 ? "s" : "")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(8)
                }
                
                ProgressView(value: progress)
                    .tint(.accentColor)
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Canvas-style working area with question overlay
            ZStack(alignment: .top) {
                // Background canvas for writing
                TextEditor(text: workingBinding(for: question.id))
                    .padding(.top, 120) // Space for question overlay
                    .font(.system(.body, design: .monospaced))
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGroupedBackground))
                
                // Question overlay at the top
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(question.label)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(question.topic)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .cornerRadius(6)
                        
                        Spacer()
                    }
                    
                    LaTeXView(latex: question.questionLatex, fontSize: 18)
                        .frame(minHeight: 60)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                .padding()
            }
            
            // Navigation Buttons
            HStack(spacing: 12) {
                if currentQuestionIndex > 0 {
                    Button(action: previousQuestion) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Previous")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundStyle(.primary)
                        .cornerRadius(12)
                    }
                }
                
                if currentQuestionIndex < currentPracticeQuestions.count - 1 {
                    Button(action: nextQuestion) {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                } else {
                    Button(action: finishQuestions) {
                        HStack {
                            Text("Check Answers")
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
    
    private var resultsView: some View {
        MathResultsView(
            questionSet: questionSet,
            currentPracticeQuestions: currentPracticeQuestions,
            userAnswers: $userAnswers,
            onDismiss: { dismiss() },
            onRetryWrongQuestions: { wrongQuestions in
                // Reset for next round with only wrong questions
                currentPracticeQuestions = wrongQuestions
                currentQuestionIndex = 0
                showResults = false
                
                // Clear working notes for wrong questions so they can start fresh
                for question in wrongQuestions {
                    if var answer = userAnswers[question.id] {
                        answer.workingNotes = ""
                        userAnswers[question.id] = answer
                    }
                }
            }
        )
    }
    
    private func workingBinding(for questionId: String) -> Binding<String> {
        Binding(
            get: { userAnswers[questionId]?.workingNotes ?? "" },
            set: { newValue in
                if userAnswers[questionId] == nil {
                    userAnswers[questionId] = UserAnswer(id: questionId)
                }
                userAnswers[questionId]?.workingNotes = newValue
            }
        )
    }
    
    private func previousQuestion() {
        withAnimation {
            currentQuestionIndex = max(0, currentQuestionIndex - 1)
        }
    }
    
    private func nextQuestion() {
        withAnimation {
            currentQuestionIndex = min(currentPracticeQuestions.count - 1, currentQuestionIndex + 1)
        }
    }
    
    private func finishQuestions() {
        withAnimation {
            showResults = true
        }
    }
}

#Preview {
    MathPracticeSessionView(questionSet: MathQuestionSet(
        title: "Numbers and Operations",
        questions: [
            MathQuestion(
                id: "math-q1a",
                subject: "Math",
                label: "1(a)",
                topic: "Numbers and their Operations",
                questionLatex: "a^3 \\times a^{\\frac{1}{2}} = a^n. \\text{ Find the value of } n.",
                answer: "n = \\frac{5}{2}",
                workingsLatex: "a^{3 + \\left(\\frac{1}{2}\\right)} = a^n \\\\ a^{\\frac{5}{2}} = a^n \\\\ n = \\frac{5}{2}",
                examTip: "Apply a^m \\times a^n = a^{m+n}.",
                marks: 1,
                source: "S21/I/12"
            )
        ]
    ))
}
