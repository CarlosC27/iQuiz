//
//  AnswerViewController.swift
//  iQuiz
//
//

import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentQuiz: [String: Any]?
    var questions: [[String: Any]] = []
    var currentQuestionIndex = 0
    var userAnswers: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentQuiz?["title"] as? String
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        displayResults()
    }
    
    func displayResults() {
        guard currentQuestionIndex < questions.count,
              let question = questions[currentQuestionIndex] as? [String: Any] else {
            return
        }
        
        questionLabel.text = question["text"] as? String

        let correctAnswerIndex = question["correctAnswer"] as? Int ?? 0
        let answers = question["answers"] as? [String] ?? []
        let correctAnswer = answers.count > correctAnswerIndex ? answers[correctAnswerIndex] : "Unknown"

        correctAnswerLabel.text = "Correct Answer: \(correctAnswer)"
        
        // Check if user answered correctly
        let userAnswerIndex = userAnswers.last ?? -1
        if userAnswerIndex == correctAnswerIndex {
            resultLabel.text = "Correct! 👍"
            resultLabel.textColor = UIColor.systemGreen
        } else {
            resultLabel.text = "Wrong! 😕"
            resultLabel.textColor = UIColor.systemRed
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questions.count {
            performSegue(withIdentifier: "toNextQuestion", sender: self)
        } else {
            performSegue(withIdentifier: "toFinishedScene", sender: self)
        }
    }
    
    @objc func handleSwipeRight() {
        nextButtonClicked(nextButton)
    }
     
    @objc func handleSwipeLeft() {
        userAnswers = []
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextQuestion" {
            if let destinationVC = segue.destination as? QuestionViewController {
                destinationVC.currentQuiz = currentQuiz
                destinationVC.questions = questions
                destinationVC.currentQuestionIndex = currentQuestionIndex
                destinationVC.userAnswers = userAnswers
            }
        } else if segue.identifier == "toFinishedScene" {
            if let destinationVC = segue.destination as? FinishedViewController {
                destinationVC.currentQuiz = currentQuiz
                destinationVC.userAnswers = userAnswers
                destinationVC.questions = questions
            }
        }
    }
    
}

