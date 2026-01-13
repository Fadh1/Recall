//
//  MathResultsView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct MathResultsView: View {
    let questionSet: MathQuestionSet
    let currentPracticeQuestions: [MathQuestion]
    @Binding var userAnswers: [String: UserAnswer]
    let onDismiss: () -> Void
    let onRetryWrongQuestions: ([MathQuestion]) -> Void
    
    @State private var currentReviewIndex = 0
    @State private var wrongQuestions: [MathQuestion] = []
    @State private var showingCompletion = false
    
    init(questionSet: MathQuestionSet, currentPracticeQuestions: [MathQuestion], userAnswers: Binding<[String: UserAnswer]>, onDismiss: @escaping () -> Void, onRetryWrongQuestions: @escaping ([MathQuestion]) -> Void) {
        self.questionSet = questionSet
        self.currentPracticeQuestions = currentPracticeQuestions
        self._userAnswers = userAnswers
        self.onDismiss = onDismiss
        self.onRetryWrongQuestions = onRetryWrongQuestions
    }
    
    private var currentQuestion: MathQuestion? {
        guard currentReviewIndex < currentPracticeQuestions.count else { return nil }
        return currentPracticeQuestions[currentReviewIndex]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if showingCompletion {
                completionView
            } else if let question = currentQuestion {
                reviewQuestionView(for: question)
            }
        }
    }
    
    @ViewBuilder
    private func reviewQuestionView(for question: MathQuestion) -> some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                HStack {
                    Text("Review \(currentReviewIndex + 1) of \(currentPracticeQuestions.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Text(question.label)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(question.marks) mark\(question.marks > 1 ? "s" : "")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                ProgressView(value: Double(currentReviewIndex + 1) / Double(currentPracticeQuestions.count))
                    .tint(.green)
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Question and Model Solution
            ScrollView {
                VStack(spacing: 16) {
                    // Question Card
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
                    
                    // Model Solution Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Model Solution", systemImage: "doc.text.fill")
                                .font(.caption)
                                .foregroundStyle(.purple)
                                .textCase(.uppercase)
                            
                            Spacer()
                        }
                        
                        LaTeXView(latex: question.workingsLatex, fontSize: 16)
                            .frame(minHeight: 80)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            
            // Correct/Wrong Buttons
            VStack(spacing: 12) {
                Button(action: { markAsCorrect(question: question) }) {
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
                
                Button(action: { markAsWrong(question: question) }) {
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
            .background(Color(.systemBackground))
        }
    }
    
    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: wrongQuestions.isEmpty ? "star.circle.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(wrongQuestions.isEmpty ? .yellow : .orange)
            
            Text(wrongQuestions.isEmpty ? "All Correct!" : "Round Complete")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if wrongQuestions.isEmpty {
                Text("You got all questions right!")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                VStack(spacing: 8) {
                    Text("You have \(wrongQuestions.count) question\(wrongQuestions.count > 1 ? "s" : "") to review")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    Text("Let's practice them again!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            if wrongQuestions.isEmpty {
                Button(action: onDismiss) {
                    Text("Done")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .padding()
            } else {
                VStack(spacing: 12) {
                    Button(action: continueWithWrongQuestions) {
                        HStack {
                            Text("Continue")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: onDismiss) {
                        Text("Finish for Now")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray5))
                            .foregroundStyle(.primary)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func markAsCorrect(question: MathQuestion) {
        withAnimation {
            moveToNextQuestion()
        }
    }
    
    private func markAsWrong(question: MathQuestion) {
        withAnimation {
            wrongQuestions.append(question)
            moveToNextQuestion()
        }
    }
    
    private func moveToNextQuestion() {
        if currentReviewIndex < currentPracticeQuestions.count - 1 {
            currentReviewIndex += 1
        } else {
            // Round complete
            showingCompletion = true
        }
    }
    
    private func continueWithWrongQuestions() {
        // Go back to practice mode with only wrong questions
        onRetryWrongQuestions(wrongQuestions)
    }
}

extension String: Identifiable {
    public var id: String { self }
}

#Preview {
    MathResultsView(
        questionSet: MathQuestionSet(
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
        ),
        currentPracticeQuestions: [
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
        ],
        userAnswers: .constant([:]),
        onDismiss: {},
        onRetryWrongQuestions: { _ in }
    )
}
