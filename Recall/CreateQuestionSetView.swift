//
//  CreateQuestionSetView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct CreateQuestionSetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var questionSets: [QuestionSet]
    
    @State private var title = ""
    @State private var questions: [Question] = []
    @State private var showingAddQuestion = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Question Set Details") {
                    TextField("Title", text: $title)
                }
                
                Section {
                    ForEach(questions) { question in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(question.questionText)
                                .font(.headline)
                                .lineLimit(2)
                            Text(question.answerText)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteQuestions)
                    
                    Button(action: { showingAddQuestion = true }) {
                        Label("Add Question", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Questions (\(questions.count))")
                }
            }
            .navigationTitle("New Question Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveQuestionSet()
                    }
                    .disabled(title.isEmpty || questions.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddQuestion) {
                AddQuestionView(questions: $questions)
            }
        }
    }
    
    private func deleteQuestions(at offsets: IndexSet) {
        questions.remove(atOffsets: offsets)
    }
    
    private func saveQuestionSet() {
        let newSet = QuestionSet(title: title, questions: questions)
        questionSets.append(newSet)
        dismiss()
    }
}

struct AddQuestionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var questions: [Question]
    
    @State private var questionText = ""
    @State private var answerText = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Question") {
                    TextEditor(text: $questionText)
                        .frame(minHeight: 100)
                }
                
                Section("Answer") {
                    TextEditor(text: $answerText)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Add Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addQuestion()
                    }
                    .disabled(questionText.isEmpty || answerText.isEmpty)
                }
            }
        }
    }
    
    private func addQuestion() {
        let newQuestion = Question(questionText: questionText, answerText: answerText)
        questions.append(newQuestion)
        dismiss()
    }
}

#Preview {
    CreateQuestionSetView(questionSets: .constant([]))
}
