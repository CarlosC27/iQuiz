//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/14/25.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateQuizData(_ quizzes: [[String: Any]])
    func didResetSettings()
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var checkNowButton: UIButton!
    @IBOutlet weak var intervalField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 12
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Round top corners only
        containerView.clipsToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
    
        urlTextField.text = SettingsManager.shared.quizUrl
        intervalField.text = String(Int(SettingsManager.shared.refreshInterval))
        statusLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        addDragIndicator()
        
        intervalField.keyboardType = .numberPad
        intervalField.isUserInteractionEnabled = true
        urlTextField.isUserInteractionEnabled = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium

    }
    
    private func addDragIndicator() {
        let dragIndicator = UIView()
        dragIndicator.backgroundColor = UIColor.systemGray3
        dragIndicator.layer.cornerRadius = 2.5
        dragIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dragIndicator)
        
        NSLayoutConstraint.activate([
            dragIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dragIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            dragIndicator.widthAnchor.constraint(equalToConstant: 36),
            dragIndicator.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
    @objc func handleSwipeDown() {
        dismiss(animated: true)
    }
        
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if translation.y < 0 {
            return
        }
        
        switch gesture.state {
        case .changed:
            containerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view)
            
            if velocity.y > 500 || translation.y > 200 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
                }) { (_) in
                    self.dismiss(animated: false)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.containerView.transform = .identity
                }
            }
            
        default:
            break
        }
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        if let urlText = urlTextField.text, !urlText.isEmpty {
            SettingsManager.shared.quizUrl = urlText
        }
        
        if let intervalText = intervalField.text,
           let interval = Double(intervalText) {
            SettingsManager.shared.refreshInterval = interval
        }
        
        statusLabel.text = "Settings saved!"
        statusLabel.textColor = .systemGreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func checkNowButtonClicked(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        statusLabel.text = "Checking for updates..."
        statusLabel.textColor = .systemBlue
        NetworkService.shared.downloadQuizzes(from: SettingsManager.shared.quizUrl) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.checkNowButton.isEnabled = true
                
                switch result {
                case .success(let quizzes):
                    SettingsManager.shared.lastRefreshTime = Date()
                    self?.statusLabel.text = "Update successful!"
                    self?.statusLabel.textColor = .systemGreen
                    self?.delegate?.didUpdateQuizData(quizzes)
                    
                case .failure(let error):
                    if (error as NSError).code == 1 {
                        self?.statusLabel.text = "Network unavailable. Please check your connection."
                    } else {
                        self?.statusLabel.text = "Error: \(error.localizedDescription)"
                    }
                    self?.statusLabel.textColor = .systemRed
                }
            }
        }
        
    }
    
   
    
    
}
