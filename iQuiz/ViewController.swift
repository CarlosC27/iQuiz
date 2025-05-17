//
//  ViewController.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/5/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsViewControllerDelegate {
    
    
    func didUpdateQuizData(_ quizzes: [[String : Any]]) {
        self.quizzes = quizzes
        quizTableView.reloadData()
    }
    
    
    @IBOutlet weak var showSettings: UIToolbar!
    @IBOutlet weak var quizTableView: UITableView!
    
    var quizzes = QuizData.quizzes
    var refreshControl = UIRefreshControl()
    var refreshTimer: Timer?
    
    
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
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        quizTableView.refreshControl = refreshControl
        checkIfRefreshNeeded()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRefreshTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer?.invalidate()
    }
    
    @objc func refreshData() {
        NetworkService.shared.downloadQuizzes(from: SettingsManager.shared.quizUrl) { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                
                switch result {
                case .success(let downloadedQuizzes):
                    self?.quizzes = downloadedQuizzes
                    self?.quizTableView.reloadData()
                    SettingsManager.shared.lastRefreshTime = Date()
                    
                case .failure(let error):
                    if (error as NSError).code == 1 {
                        self?.showNetworkAlert()
                    } else {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setupRefreshTimer() {
        refreshTimer?.invalidate()
        let interval = SettingsManager.shared.refreshInterval * 60
        refreshTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timedRefresh), userInfo: nil, repeats: true)
    }
    
    @objc func timedRefresh() {
        refreshData()
    }
    
    func checkIfRefreshNeeded() {
        if let lastRefresh = SettingsManager.shared.lastRefreshTime {
            let now = Date()
            let timeSinceLastRefresh = now.timeIntervalSince(lastRefresh) / 60
            
            if timeSinceLastRefresh > SettingsManager.shared.refreshInterval {
                refreshData()
            }
        } else {
            refreshData()
        }
    }
    
    func showNetworkAlert() {
        let alert = UIAlertController(
            title: "Network Unavailable",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func showSettings(_ sender: Any) {
        if let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            settingsVC.delegate = self
            
            if #available(iOS 15.0, *) {
                settingsVC.modalPresentationStyle = .pageSheet
                
                if let sheet = settingsVC.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 24
                }
            } else {
                settingsVC.modalPresentationStyle = .formSheet
            }
            
            present(settingsVC, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showQuestions", sender: indexPath)
    }
    
    func didResetSettings() {
        self.quizzes = QuizData.quizzes
        quizTableView.reloadData()
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

