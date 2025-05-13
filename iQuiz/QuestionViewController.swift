//
//  QuestionViewController.swift
//  iQuiz
//
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var currentQuiz: [String: Any]?
    var questions: [[String: Any]] = []
    var currentQuestionIndex = 0
    var selectedAnswerIndex: Int?
    var userAnswers: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentQuiz?["title"] as? String
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.rowHeight = UITableView.automaticDimension
        answerTableView.estimatedRowHeight = 44
        
        NotificationCenter.default.addObserver(self,selector: #selector(orientationDidChange),name: UIDevice.orientationDidChangeNotification,object: nil)
           
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        loadCurrentQuestion()
        
    }
    
    @objc func orientationDidChange() {
        answerTableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            performSegue(withIdentifier: "toFinishedScene", sender: self)
            return
        } 
        
        let question = questions[currentQuestionIndex]
        questionLabel.text = question["text"] as? String
        answerTableView.reloadData()
        
        selectedAnswerIndex = nil
        submitButton.isEnabled = false
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if let selectedIndex = selectedAnswerIndex {
            userAnswers.append(selectedIndex)
            performSegue(withIdentifier: "toAnswerScene", sender: self)
        }
    }
    
    @objc func handleSwipeRight() {
        if let _ = selectedAnswerIndex {
            submitButtonClicked(submitButton)
        }
    }
    
    @objc func handleSwipeLeft() {
        userAnswers = []
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentQuestionIndex < questions.count {
            if let answers = questions[currentQuestionIndex]["answers"] as? [String] {
                return answers.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        if let answers = questions[currentQuestionIndex]["answers"] as? [String] {
            cell.textLabel?.text = answers[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        }
        
        if indexPath.row == selectedAnswerIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        submitButton.isEnabled = true
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswerScene" {
            if let destinationVC = segue.destination as? AnswerViewController {
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
