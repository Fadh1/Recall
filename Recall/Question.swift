//
//  Question.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    var questionText: String
    var answerText: String
    
    init(id: UUID = UUID(), questionText: String, answerText: String) {
        self.id = id
        self.questionText = questionText
        self.answerText = answerText
    }
}

struct QuestionSet: Identifiable, Codable {
    let id: UUID
    var title: String
    var questions: [Question]
    var createdDate: Date
    
    init(id: UUID = UUID(), title: String, questions: [Question] = [], createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.questions = questions
        self.createdDate = createdDate
    }
}
