//
//  SubjectGridView.swift
//  Recall
//
//  Created by Fad Rahim on 11/02/26.
//

import SwiftUI

struct SubjectGridView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Subject.allCases) { subject in
                        NavigationLink(destination: TutorSessionView(subject: subject)) {
                            SubjectCard(subject: subject)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Subject Tutor")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct SubjectCard: View {
    let subject: Subject
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: subject.icon)
                .font(.system(size: 40))
                .foregroundStyle(subject.color)
                .frame(width: 80, height: 80)
                .background(subject.color.opacity(0.1))
                .clipShape(Circle())
            
            Text(subject.rawValue)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SubjectGridView()
}
