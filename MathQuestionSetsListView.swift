//
//  MathQuestionSetsListView.swift
//  Recall
//
//  Created by Fad Rahim on 13/01/26.
//

import SwiftUI

struct MathQuestionSetsListView: View {
    @State private var questionSets: [MathQuestionSet] = []
    @State private var selectedQuestionSet: MathQuestionSet? = nil
    
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
                                Label("\(questionSet.questions.count) questions", systemImage: "function")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                if let firstQuestion = questionSet.questions.first {
                                    Text(firstQuestion.topic)
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Math Practice Sets")
            .fullScreenCover(item: $selectedQuestionSet) { questionSet in
                MathPracticeSessionView(questionSet: questionSet)
            }
            .overlay {
                if questionSets.isEmpty {
                    ContentUnavailableView(
                        "No Question Sets",
                        systemImage: "function",
                        description: Text("Loading demo questions...")
                    )
                }
            }
            .onAppear {
                loadDemoData()
            }
        }
    }
    
    private func loadDemoData() {
        // Parse the JSON data
        let jsonString = """
        [
          {
            "id": "math-q1a",
            "subject": "Math",
            "label": "1(a)",
            "topic": "Numbers and their Operations",
            "question_latex": "a^3 \\\\times a^{\\\\frac{1}{2}} = a^n. \\\\text{ Find the value of } n.",
            "answer": "n = \\\\frac{5}{2}",
            "workings_latex": "a^{3 + \\\\left(\\\\frac{1}{2}\\\\right)} = a^n \\\\\\\\ a^{\\\\frac{5}{2}} = a^n \\\\\\\\ n = \\\\frac{5}{2}",
            "exam_tip": "Apply a^m \\\\times a^n = a^{m+n}.",
            "marks": 1,
            "source": "S21/I/12"
          },
          {
            "id": "math-q1b",
            "subject": "Math",
            "label": "1(b)",
            "topic": "Numbers and their Operations",
            "question_latex": "16^{\\\\frac{3}{4}} \\\\div 8^4 = 2^k. \\\\text{ Find the value of } k.",
            "answer": "k = -9",
            "workings_latex": "(2^4)^{\\\\frac{3}{4}} \\\\div (2^3)^4 = 2^k \\\\\\\\ 2^3 \\\\div 2^{12} = 2^k \\\\\\\\ 2^{3-12} = 2^k \\\\\\\\ 2^{-9} = 2^k \\\\\\\\ k = -9",
            "exam_tip": "Apply a^m \\\\div a^n = a^{m-n} \\\\text{ and } (a^m)^n = a^{mn}.",
            "marks": 2,
            "source": "S21/I/12"
          },
          {
            "id": "math-q2",
            "subject": "Math",
            "label": "2",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\text{By writing each number correct to 1 significant figure, estimate the value of } \\\\frac{\\\\sqrt{54.3 \\\\times 7.9}}{3.56}",
            "answer": "5",
            "workings_latex": "\\\\frac{\\\\sqrt{54.3 \\\\times 7.9}}{3.56} \\\\approx \\\\frac{\\\\sqrt{50 \\\\times 8}}{4} \\\\\\\\ = \\\\frac{\\\\sqrt{400}}{4} \\\\\\\\ = \\\\frac{20}{4} \\\\\\\\ = 5",
            "exam_tip": "For numbers more than 1, no decimal point should be written because any digit after the decimal point is significant.",
            "marks": 2,
            "source": "S20/I/1"
          },
          {
            "id": "math-q3",
            "subject": "Math",
            "label": "3",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\frac{19}{6}, \\\\quad 3.3, \\\\quad 320\\\\%, \\\\quad \\\\pi \\\\\\\\ \\\\text{Write these numbers in order, starting with the smallest.}",
            "answer": "\\\\pi, \\\\frac{19}{6}, 320\\\\%, 3.3",
            "workings_latex": "320\\\\% = \\\\frac{320}{100} = 3.2 \\\\\\\\ \\\\pi \\\\approx 3.14159... \\\\\\\\ \\\\frac{19}{6} \\\\approx 3.166... \\\\\\\\ 3.3 = 3.3",
            "exam_tip": "Convert each value to a decimal first and arrange them accordingly.",
            "marks": 2,
            "source": "S20/I/9(b)"
          },
          {
            "id": "math-q4a",
            "subject": "Math",
            "label": "4(a)",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\text{Given that } \\\\frac{3^5 \\\\times 3^0}{3^{-4}} = 3^m, \\\\text{ find } m.",
            "answer": "m = 9",
            "workings_latex": "\\\\frac{3^5 \\\\times 3^0}{3^{-4}} = 3^m \\\\\\\\ 3^{5+0-(-4)} = 3^m \\\\\\\\ 3^9 = 3^m \\\\\\\\ m = 9",
            "exam_tip": "Apply a^m \\\\times a^n = a^{m+n} \\\\text{ and } a^m \\\\div a^n = a^{m-n}.",
            "marks": 1,
            "source": "S19/I/6"
          },
          {
            "id": "math-q4b",
            "subject": "Math",
            "label": "4(b)",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\text{Given that } 64^{\\\\frac{4}{3}} = 2^n, \\\\text{ find } n.",
            "answer": "n = 8",
            "workings_latex": "64^{\\\\frac{4}{3}} = 2^n \\\\\\\\ (2^6)^{\\\\frac{4}{3}} = 2^n \\\\\\\\ 2^8 = 2^n \\\\\\\\ n = 8",
            "exam_tip": "Apply (a^m)^n = a^{mn}.",
            "marks": 1,
            "source": "S19/I/6"
          },
          {
            "id": "math-q5a",
            "subject": "Math",
            "label": "5(a)",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\text{Calculate } \\\\frac{6.19 + 9.53}{6.4 - 4.8}",
            "answer": "9.825",
            "workings_latex": "\\\\frac{6.19 + 9.53}{6.4 - 4.8} = 9.825",
            "exam_tip": null,
            "marks": 1,
            "source": "S18/I/1"
          },
          {
            "id": "math-q5b",
            "subject": "Math",
            "label": "5(b)",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\text{Calculate } \\\\sqrt{2.4^3 - 3.7}, \\\\text{ giving your answer correct to 1 decimal place.}",
            "answer": "3.2",
            "workings_latex": "\\\\sqrt{2.4^3 - 3.7} = 3.2 \\\\text{ (to 1 d.p.)}",
            "exam_tip": null,
            "marks": 1,
            "source": "S18/I/1"
          },
          {
            "id": "math-q6",
            "subject": "Math",
            "label": "6",
            "topic": "Numbers and their Operations",
            "question_latex": "75\\\\%, \\\\quad \\\\frac{3}{5}, \\\\quad \\\\frac{\\\\sqrt{3}}{2}, \\\\quad \\\\frac{\\\\pi}{4}, \\\\quad 0.57 \\\\\\\\ \\\\text{Write these numbers in order of size, starting with the smallest.}",
            "answer": "0.57, \\\\frac{3}{5}, 75\\\\%, \\\\frac{\\\\pi}{4}, \\\\frac{\\\\sqrt{3}}{2}",
            "workings_latex": "0.57 = 0.57 \\\\\\\\ \\\\frac{3}{5} = 0.6 \\\\\\\\ 75\\\\% = 0.75 \\\\\\\\ \\\\frac{\\\\pi}{4} \\\\approx 0.785 \\\\\\\\ \\\\frac{\\\\sqrt{3}}{2} \\\\approx 0.866",
            "exam_tip": "Convert each value to a decimal first and arrange them accordingly.",
            "marks": 2,
            "source": "S18/I/2"
          },
          {
            "id": "math-q7a",
            "subject": "Math",
            "label": "7(a)",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\text{Write } \\\\frac{2^3 \\\\times 2^2}{2^8} \\\\text{ as a single power of 2.}",
            "answer": "2^{-3}",
            "workings_latex": "\\\\frac{2^3 \\\\times 2^2}{2^8} = 2^{(3+2)-8} \\\\\\\\ = 2^{-3}",
            "exam_tip": "Apply a^m \\\\times a^n = a^{m+n} \\\\text{ and } a^m \\\\div a^n = a^{m-n}.",
            "marks": 1,
            "source": "S18/I/6"
          },
          {
            "id": "math-q7b",
            "subject": "Math",
            "label": "7(b)",
            "topic": "Numbers and their Operations",
            "question_latex": "\\\\text{Given that } 8^{\\\\frac{1}{2}} = 2^m, \\\\text{ find } m.",
            "answer": "m = 1.5 \\\\text{ or } 1 \\\\frac{1}{2}",
            "workings_latex": "8^{\\\\frac{1}{2}} = (2^3)^{\\\\frac{1}{2}} \\\\\\\\ = 2^{\\\\frac{3}{2}} \\\\\\\\ 2^m = 2^{\\\\frac{3}{2}} \\\\\\\\ \\\\therefore m = \\\\frac{3}{2} = 1 \\\\frac{1}{2}",
            "exam_tip": "Express 8 as a power of 2.",
            "marks": 1,
            "source": "S18/I/6"
          }
        ]
        """
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let questions = try decoder.decode([MathQuestion].self, from: jsonData)
                
                // Create a question set
                let questionSet = MathQuestionSet(
                    title: "Numbers and their Operations",
                    questions: questions
                )
                
                questionSets = [questionSet]
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
}

#Preview {
    MathQuestionSetsListView()
}
