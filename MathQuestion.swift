//
//  MathQuestion.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import Foundation

struct MathQuestion: Identifiable, Codable {
    let id: String
    let subject: String
    let label: String
    let topic: String
    let questionLatex: String
    let answer: String
    let workingsLatex: String
    let examTip: String?
    let marks: Int
    let source: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case subject
        case label
        case topic
        case questionLatex = "question_latex"
        case answer
        case workingsLatex = "workings_latex"
        case examTip = "exam_tip"
        case marks
        case source
    }
}

struct MathQuestionSet: Identifiable, Codable {
    let id: UUID
    var title: String
    var questions: [MathQuestion]
    var createdDate: Date
    
    init(id: UUID = UUID(), title: String, questions: [MathQuestion] = [], createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.questions = questions
        self.createdDate = createdDate
    }
}

// Store user's answer and workings
struct UserAnswer: Identifiable {
    let id: String // matches question id
    var workingNotes: String
    var selectedAnswer: String
    var isCorrect: Bool?
    
    init(id: String, workingNotes: String = "", selectedAnswer: String = "", isCorrect: Bool? = nil) {
        self.id = id
        self.workingNotes = workingNotes
        self.selectedAnswer = selectedAnswer
        self.isCorrect = isCorrect
    }
}
