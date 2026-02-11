//
//  Subject.swift
//  Recall
//
//  Created by Fad Rahim on 11/02/26.
//

import SwiftUI

enum Subject: String, CaseIterable, Identifiable {
    case english = "English"
    case malay = "Malay"
    case math = "Math"
    case science = "Science"
    case socialStudies = "Social Studies"
    case history = "History"
    case principlesOfAccounts = "Principles of Accounts"
    case physics = "Physics"
    case chemistry = "Chemistry"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .english: return "text.book.closed"
        case .malay: return "quote.bubble"
        case .math: return "x.squareroot"
        case .science: return "flask"
        case .socialStudies: return "person.3"
        case .history: return "clock.arrow.circlepath"
        case .principlesOfAccounts: return "chart.bar.doc.horizontal"
        case .physics: return "atom"
        case .chemistry: return "ivfluid.bag"
        }
    }

    var color: Color {
        switch self {
        case .english: return .blue
        case .malay: return .green
        case .math: return .orange
        case .science: return .purple
        case .socialStudies: return .pink
        case .history: return .brown
        case .principlesOfAccounts: return .teal
        case .physics: return .indigo
        case .chemistry: return .cyan
        }
    }
}
