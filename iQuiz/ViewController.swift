//
//  ViewController.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/5/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var quizTableView: UITableView!
    let quizzes = QuizData.quizzes
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.text = quiz["title"] as? String
        cell.detailTextLabel?.text = quiz["description"] as? String
        cell.imageView?.image = UIImage(named: quiz["icon"] as? String ?? "default")
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "iQuiz"
        navigationItem.backButtonTitle = "Back"
        
        quizTableView.delegate = self
        quizTableView.dataSource = self
    }

    @IBOutlet weak var showSettings: UIToolbar!
    
    @IBAction func showSettings(_ sender: Any) {
        let alert = UIAlertController(title:"Settings", message: "Settings Go Here", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showQuestions", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestions", let indexPath = sender as? IndexPath {
            if let destinationVC = segue.destination as? QuestionViewController {
                destinationVC.currentQuiz = quizzes[indexPath.row]
                destinationVC.questions = quizzes[indexPath.row]["questions"] as? [[String: Any]] ?? []
            }
        }
    }
    
}

