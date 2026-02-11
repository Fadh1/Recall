//
//  TutorSession.swift
//  Recall
//
//  Created by Fad Rahim on 11/02/26.
//

import Foundation
import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id: UUID = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

@MainActor
class TutorSession: ObservableObject {
    let subject: Subject
    @Published var messages: [ChatMessage] = []
    @Published var writingContent: String = ""
    @Published var isAgentThinking: Bool = false
    
    // In a real app, this would persist to disk/database
    // For now, it's in-memory per session instance
    
    init(subject: Subject) {
        self.subject = subject
        // Add an initial greeting from the agent
        self.messages = [
            ChatMessage(
                content: "Hello! I'm your \(subject.rawValue) tutor. How can I help you today?",
                isUser: false,
                timestamp: Date()
            )
        ]
    }
    
    func sendMessage(_ content: String) {
        let userMsg = ChatMessage(content: content, isUser: true, timestamp: Date())
        messages.append(userMsg)
        
        // Simulate agent response
        isAgentThinking = true
        
        // Mock async response
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            
            let agentMsg = ChatMessage(
                content: "I see you're working on that. Let's break it down further. What do you think is the next step?",
                isUser: false,
                timestamp: Date()
            )
            
            await MainActor.run {
                messages.append(agentMsg)
                isAgentThinking = false
            }
        }
    }
}
