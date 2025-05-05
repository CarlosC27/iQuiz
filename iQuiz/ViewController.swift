//
//  ViewController.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/5/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var quizTableView: UITableView!
    let quizzes = [
        ["title": "Mathematics", "description": "Test your math skills", "icon": "math-icon-orange"],
        ["title": "Marvel Super Heroes", "description": "How well do you know about Marvels heroes?", "icon": "marvel-logo-purple"],
        ["title": "Science", "description": "Test youw knowledge about science", "icon": "science-orange"],
        ["title": "Pop Culture", "description": "Test your knowledge about pop culture", "icon": "pop-culture-purple"]
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.text = quiz["title"]
        cell.detailTextLabel?.text = quiz["description"]
        cell.imageView?.image = UIImage(named: quiz["icon"] ?? "default")
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "iQuiz"
        
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
    
}

