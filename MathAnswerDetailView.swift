//
//  MathAnswerDetailView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct MathAnswerDetailView: View {
    let question: MathQuestion
    let userAnswer: UserAnswer?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Question Label
                    HStack {
                        Text(question.label)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("\(question.marks) mark\(question.marks > 1 ? "s" : "")")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    
                    // Topic
                    Text(question.topic)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(6)
                    
                    Divider()
                    
                    // Question
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Question", systemImage: "questionmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.blue)
                        
                        LaTeXView(latex: question.questionLatex, fontSize: 18)
                            .frame(minHeight: 60)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Your Working
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Your Working", systemImage: "pencil.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        
                        if let workingNotes = userAnswer?.workingNotes, !workingNotes.isEmpty {
                            Text(workingNotes)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        } else {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                Text("No working provided")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Correct Answer
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Correct Answer", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.green)
                        
                        LaTeXView(latex: question.answer, fontSize: 18)
                            .frame(minHeight: 50)
                    }
                    .padding()
                    .background(Color.green.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Model Solution
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Model Solution", systemImage: "doc.text.fill")
                            .font(.headline)
                            .foregroundStyle(.purple)
                        
                        LaTeXView(latex: question.workingsLatex, fontSize: 16)
                            .frame(minHeight: 100)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Exam Tip
                    if let examTip = question.examTip {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Exam Tip", systemImage: "lightbulb.fill")
                                .font(.headline)
                                .foregroundStyle(.yellow)
                            
                            LaTeXView(latex: examTip, fontSize: 14)
                                .frame(minHeight: 50)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Source
                    HStack {
                        Image(systemName: "doc.on.doc")
                            .foregroundStyle(.secondary)
                        Text("Source: \(question.source)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Answer Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MathAnswerDetailView(
        question: MathQuestion(
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
        ),
        userAnswer: UserAnswer(id: "math-q1a", workingNotes: "a^3 * a^(1/2) = a^(3 + 1/2) = a^(5/2)\nTherefore n = 5/2")
    )
}
