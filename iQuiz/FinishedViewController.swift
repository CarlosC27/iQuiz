//
//  FinishedViewController.swift
//  iQuiz

//

import UIKit

class FinishedViewController: UIViewController {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var performanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentQuiz: [String: Any]?
    var questions: [[String: Any]] = []
    var userAnswers: [Int] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentQuiz?["title"] as? String
        
        calculateAndDisplayScore()
    }
    
    func calculateAndDisplayScore() {
        var correctCount = 0
        for (index, userAnswer) in userAnswers.enumerated() {
            if index < questions.count {
                let correctAnswer = questions[index]["correctAnswer"] as? Int ?? 0
                if userAnswer == correctAnswer {
                    correctCount += 1
                }
            }
        }
        scoreLabel.text = "You got \(correctCount) out of \(questions.count) correct!"
        
        let percentage = Double(correctCount) / Double(questions.count)
        
        if percentage == 1.0 {
            performanceLabel.text = "Perfect! 🎉"
            performanceLabel.textColor = UIColor.systemGreen
        } else if percentage >= 0.8 {
            performanceLabel.text = "Great job! 👍"
            performanceLabel.textColor = UIColor.systemGreen
        } else if percentage >= 0.5 {
            performanceLabel.text = "Not bad! 👌"
            performanceLabel.textColor = UIColor.systemOrange
        } else {
            performanceLabel.text = "Keep practicing! 📚"
            performanceLabel.textColor = UIColor.systemRed
        }
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
