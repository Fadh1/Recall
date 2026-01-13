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
    
    private var currentQuestion: MathQuestion? {
        guard currentQuestionIndex < questionSet.questions.count else { return nil }
        return questionSet.questions[currentQuestionIndex]
    }
    
    private var progress: Double {
        guard !questionSet.questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(questionSet.questions.count)
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
                    Text("Question \(currentQuestionIndex + 1) of \(questionSet.questions.count)")
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Question Label and Topic
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(question.label)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(question.topic)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .cornerRadius(6)
                        }
                        
                        if let examTip = question.examTip {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.caption)
                                
                                LaTeXView(latex: examTip, fontSize: 14)
                                    .frame(height: 60)
                            }
                            .padding(12)
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Question Display
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Question")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                            .textCase(.uppercase)
                        
                        LaTeXView(latex: question.questionLatex, fontSize: 20)
                            .frame(minHeight: 80)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Working Space
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(.orange)
                            Text("Your Working")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.orange)
                                .textCase(.uppercase)
                        }
                        
                        TextEditor(text: workingBinding(for: question.id))
                            .frame(minHeight: 200)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .font(.system(.body, design: .monospaced))
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            
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
                
                if currentQuestionIndex < questionSet.questions.count - 1 {
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
            userAnswers: $userAnswers,
            onDismiss: { dismiss() },
            onRetry: {
                currentQuestionIndex = 0
                showResults = false
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
            currentQuestionIndex = min(questionSet.questions.count - 1, currentQuestionIndex + 1)
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
