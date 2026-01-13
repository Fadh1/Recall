//
//  QuestionSetsListView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct QuestionSetsListView: View {
    @State private var questionSets: [QuestionSet] = [
        // Sample data for testing
        QuestionSet(
            title: "Swift Basics",
            questions: [
                Question(questionText: "What does SwiftUI use for state management?", answerText: "@State, @Binding, @ObservedObject, @StateObject, @EnvironmentObject"),
                Question(questionText: "What is the difference between a struct and a class?", answerText: "Structs are value types, classes are reference types. Structs don't support inheritance."),
                Question(questionText: "What is a closure in Swift?", answerText: "A self-contained block of functionality that can be passed around and used in your code.")
            ]
        ),
        QuestionSet(
            title: "History",
            questions: [
                Question(questionText: "When did World War II end?", answerText: "1945"),
                Question(questionText: "Who was the first president of the United States?", answerText: "George Washington")
            ]
        )
    ]
    
    @State private var showingCreateSheet = false
    @State private var selectedQuestionSet: QuestionSet? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(questionSets) { questionSet in
                    Button(action: { selectedQuestionSet = questionSet }) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(questionSet.title)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            
                            HStack {
                                Label("\(questionSet.questions.count) questions", systemImage: "questionmark.circle")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text(questionSet.createdDate, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteQuestionSets)
            }
            .navigationTitle("Practice Sets")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingCreateSheet = true }) {
                        Label("New Set", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                CreateQuestionSetView(questionSets: $questionSets)
            }
            .fullScreenCover(item: $selectedQuestionSet) { questionSet in
                PracticeView(questionSet: questionSet)
            }
            .overlay {
                if questionSets.isEmpty {
                    ContentUnavailableView(
                        "No Question Sets",
                        systemImage: "questionmark.folder",
                        description: Text("Create your first question set to start practicing")
                    )
                }
            }
        }
    }
    
    private func deleteQuestionSets(at offsets: IndexSet) {
        questionSets.remove(atOffsets: offsets)
    }
}

#Preview {
    QuestionSetsListView()
}
