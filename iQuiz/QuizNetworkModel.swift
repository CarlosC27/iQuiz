//
//  QuizNetworkModel.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/14/25.
//

import Foundation

struct QuizNetworkModel: Codable {
    var title: String
    var desc: String
    var questions: [QuestionModel]
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "description": desc,
            "icon": getIconName(for: title),
            "questions": questions.map { $0.toDictionary() }
        ]
    }
    
    private func getIconName(for title: String) -> String {
        let normalizedTitle = title.lowercased()
        if normalizedTitle.contains("math") {
            return "math-icon-orange"
        } else if normalizedTitle.contains("marvel") || normalizedTitle.contains("super") || normalizedTitle.contains("hero") {
            return "marvel-logo-purple"
        } else if normalizedTitle.contains("science") {
            return "science-orange"
        } else {
            return "pop-culture-purple"
        }
    }
}

struct QuestionModel: Codable {
    var text: String
    var answer: String
    var answers: [String]
    
    func toDictionary() -> [String: Any] {
        let correctAnswerIndex = answers.firstIndex(of: answer) ?? 0
        
        return [
            "text": text,
            "answers": answers,
            "correctAnswer": correctAnswerIndex
        ]
    }
}

typealias QuizzesNetworkModel = [QuizNetworkModel]
