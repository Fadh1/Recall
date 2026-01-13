//
//  MathResultsView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct MathResultsView: View {
    let questionSet: MathQuestionSet
    @Binding var userAnswers: [String: UserAnswer]
    let onDismiss: () -> Void
    let onRetry: () -> Void
    
    @State private var selectedQuestionId: String?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Review Your Answers")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\(questionSet.questions.count) questions")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemBackground))
            
            // Questions List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(questionSet.questions) { question in
                        Button(action: { selectedQuestionId = question.id }) {
                            questionCard(for: question)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            
            // Bottom Actions
            HStack(spacing: 12) {
                Button(action: onRetry) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Try Again")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundStyle(.primary)
                    .cornerRadius(12)
                }
                
                Button(action: onDismiss) {
                    HStack {
                        Text("Done")
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .sheet(item: $selectedQuestionId) { questionId in
            if let question = questionSet.questions.first(where: { $0.id == questionId }) {
                MathAnswerDetailView(
                    question: question,
                    userAnswer: userAnswers[questionId]
                )
            }
        }
    }
    
    @ViewBuilder
    private func questionCard(for question: MathQuestion) -> some View {
        HStack(spacing: 16) {
            // Question Number Circle
            VStack {
                Text(question.label)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(question.topic)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(question.marks) mark\(question.marks > 1 ? "s" : "")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                LaTeXView(latex: question.questionLatex, fontSize: 14)
                    .frame(height: 40)
                
                if let userAnswer = userAnswers[question.id], !userAnswer.workingNotes.isEmpty {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundStyle(.green)
                        Text("Work shown")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(.orange)
                        Text("No work shown")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
        userAnswers: .constant([:]),
        onDismiss: {},
        onRetry: {}
    )
}
