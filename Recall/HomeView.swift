//
//  HomeView.swift
//  Recall
//
//  Created by Fad Rahim on 13/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedCategory: NoteCategory? = nil
    @State private var showingPracticeSets = false

    let categories = NoteCategory.allCases
    let sampleNotes = [
        Note(title: "Meeting Notes", preview: "Discussed project timeline and deliverables...", date: Date(), category: .work),
        Note(title: "Ideas for App", preview: "New feature ideas for the next release...", date: Date().addingTimeInterval(-86400), category: .ideas),
        Note(title: "Shopping List", preview: "Milk, eggs, bread, coffee...", date: Date().addingTimeInterval(-172800), category: .personal),
        Note(title: "Book Notes", preview: "Key takeaways from the chapter on SwiftUI...", date: Date().addingTimeInterval(-259200), category: .ideas)
    ]

    var filteredNotes: [Note] {
        var notes = sampleNotes

        if let category = selectedCategory {
            notes = notes.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            notes = notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.preview.localizedCaseInsensitiveContains(searchText) }
        }

        return notes
    }

    var body: some View {
        NavigationView {
            // Sidebar
            VStack(alignment: .leading, spacing: 0) {
                // Header
                Text("Recall")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                // Categories
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        CategoryButton(
                            title: "All Notes",
                            icon: "doc.text.fill",
                            isSelected: selectedCategory == nil
                        ) {
                            selectedCategory = nil
                        }

                        Divider()
                            .padding(.vertical, 8)

                        ForEach(categories) { category in
                            CategoryButton(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        CategoryButton(
                            title: "Practice Sets",
                            icon: "brain.fill",
                            isSelected: false
                        ) {
                            showingPracticeSets = true
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // Footer
                Button(action: {}) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .foregroundColor(.secondary)
                    .padding()
                }
            }
            .frame(width: 280)
            .background(Color(.systemGroupedBackground))

            // Main Content
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search notes...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()

                // Notes Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 20)
                    ], spacing: 20) {
                        ForEach(filteredNotes) { note in
                            NoteCard(note: note)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(selectedCategory?.rawValue ?? "All Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}) {
                        Label("New Note", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .navigationViewStyle(.columns)
        .sheet(isPresented: $showingPracticeSets) {
            QuestionSetsListView()
        }
    }
}

struct CategoryButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(title)
                    .font(.body)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
            .cornerRadius(8)
            .foregroundColor(isSelected ? .accentColor : .primary)
        }
        .buttonStyle(.plain)
    }
}

struct NoteCard: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: note.category.icon)
                    .foregroundColor(note.category.color)
                Spacer()
                Text(note.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(note.title)
                .font(.headline)
                .lineLimit(2)

            Text(note.preview)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)

            Spacer()
        }
        .padding()
        .frame(height: 180)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct Note: Identifiable {
    let id = UUID()
    let title: String
    let preview: String
    let date: Date
    let category: NoteCategory
}

enum NoteCategory: String, CaseIterable, Identifiable {
    case work = "Work"
    case personal = "Personal"
    case ideas = "Ideas"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .ideas: return "lightbulb.fill"
        }
    }

    var color: Color {
        switch self {
        case .work: return .blue
        case .personal: return .green
        case .ideas: return .orange
        }
    }
}

#Preview {
    HomeView()
}
