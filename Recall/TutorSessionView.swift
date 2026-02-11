//
//  TutorSessionView.swift
//  Recall
//
//  Created by Fad Rahim on 11/02/26.
//

import SwiftUI

struct TutorSessionView: View {
    let subject: Subject
    @StateObject private var session: TutorSession
    @State private var chatInput: String = ""
    @FocusState private var isInputFocused: Bool
    
    init(subject: Subject) {
        self.subject = subject
        self._session = StateObject(wrappedValue: TutorSession(subject: subject))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Writing Area (Top Half)
                VStack(alignment: .leading) {
                    Text("Working Area")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    TextEditor(text: $session.writingContent)
                        .font(.system(.body, design: .monospaced))
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .frame(height: geometry.size.height * 0.5) // Take up 50% of screen
                
                Divider()
                
                // Chat Area (Bottom Half)
                VStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(session.messages) { message in
                                    ChatBubble(message: message)
                                }
                                
                                if session.isAgentThinking {
                                    HStack {
                                        ProgressView()
                                            .padding(10)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(16)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding()
                        }
                        .onChange(of: session.messages) { _ in
                            if let lastId = session.messages.last?.id {
                                withAnimation {
                                    proxy.scrollTo(lastId, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    // Input Area
                    HStack(spacing: 10) {
                        TextField("Ask your tutor...", text: $chatInput)
                            .textFieldStyle(.roundedBorder)
                            .focused($isInputFocused)
                            .submitLabel(.send)
                            .onSubmit(sendMessage)
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(chatInput.isEmpty ? Color.gray : subject.color)
                        }
                        .disabled(chatInput.isEmpty)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
                }
            }
        }
        .navigationTitle(subject.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        guard !chatInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        session.sendMessage(chatInput)
        chatInput = ""
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(16)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 4,
                            topTrailingRadius: 16
                        )
                    )
            } else {
                Text(message.content)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundStyle(.primary)
                    .cornerRadius(16)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 4,
                            bottomTrailingRadius: 16,
                            topTrailingRadius: 16
                        )
                    )
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        TutorSessionView(subject: .math)
    }
}
