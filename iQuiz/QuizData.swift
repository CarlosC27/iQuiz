//
//  QuizData.swift
//  iQuiz
//
//  Created by Carlos Carrillo-Sandoval on 5/13/25.
//

import Foundation

struct QuizData {
    
    static var mathQuestions: [[String: Any]] = [
        [
            "text": "What is the square root of 169?",
            "answers": ["12", "14.3746347", "13", "13.48462"],
            "correctAnswer": 2
        ],
        [
            "text": "Solve for x: 2x + 5 = 13",
            "answers": ["3", "4", "5", "6"],
            "correctAnswer": 1
        ],
        [
            "text": "If f(x) = x² - 3x + 2, what is f(4)?",
            "answers": ["6", "10", "14", "18"],
            "correctAnswer": 1
        ],
        [
            "text": "What is the value of log₁₀(100)?",
            "answers": ["1", "2", "10", "100"],
            "correctAnswer": 1
        ],
        [
            "text": "if the function is 1/x, What is the value of x as it approches 0?",
            "answers": ["1", "THE LIMIT DOES NOT EXISTS!", "0", "-1"],
            "correctAnswer": 1
        ]
    ]
    
    static var marvelQuestions: [[String: Any]] = [
        [
            "text": "What color is the Reality Stone?",
            "answers": ["Blue", "Purple", "Red", "Green"],
            "correctAnswer": 2
        ],
        [
            "text": "Which metal is used to make Captain America's shield?",
            "answers": ["Adamantium", "Vibranium", "Titanium", "Promethium"],
            "correctAnswer": 1
        ],
        [
            "text": "What is Scarlet Witch's real name?",
            "answers": ["Natasha Romanoff", "Wanda Maximoff", "Pepper Potts", "Peggy Carter"],
            "correctAnswer": 1
        ],
        [
            "text": "What is Peter Parker's aunt's name?",
            "answers": ["May", "April", "June", "July"],
            "correctAnswer": 0
        ],
        [
            "text": "Which Infinity Stone gives Scarlet Witch her powers?",
            "answers": ["Mind Stone", "Reality Stone", "Power Stone", "Soul Stone"],
            "correctAnswer": 0
        ]
    ]
    
    static var scienceQuestions: [[String: Any]] = [
        [
            "text": "What is the unit of electrical resistance?",
            "answers": ["Ampere", "Volt", "Watt", "Ohm"],
            "correctAnswer": 3
        ],
        [
            "text": "Which blood type is known as the universal donor?",
            "answers": ["Type A", "Type B", "Type AB", "Type O-negative"],
            "correctAnswer": 3
        ],
        [
            "text": "What is the study of fossils called?",
            "answers": ["Geology", "Archaeology", "Paleontology", "Anthropology"],
            "correctAnswer": 2
        ],
        [
            "text": "Which of these planets rotates on its side?",
            "answers": ["Jupiter", "Saturn", "Uranus", "Neptune"],
            "correctAnswer": 2
        ],
        [
            "text": "What is the Earth's primary source of energy?",
            "answers": ["Wind", "The Sun", "Water", "Fossil fuels"],
            "correctAnswer": 1
        ]
    ]
    
    static var popCultureQuestions: [[String: Any]] = [
        [
            "text": "What is the famous catchphrase RuPaul says at the end of each episode?",
            "answers": ["Shantay, you stay!", "If you can't love yourself, how in the hell you gonna love somebody else?", "The time has come to lip-sync for your life!", "Everybody say love!"],
            "correctAnswer": 1
        ],
        [
            "text": "Which artist has won the most Grammy Awards of all time?",
            "answers": ["Beyoncé", "Georg Solti", "Quincy Jones", "Stevie Wonder"],
            "correctAnswer": 0
        ],
        [
            "text": "What is the title of Sabrina Carpenter's 2024 album?",
            "answers": ["Emails I Can't Send", "Short n' Sweet", "Evolution", "Singular"],
            "correctAnswer": 1
        ],
        [
            "text": "In 'Wicked', what is Glinda's full name before she changes it?",
            "answers": ["Glinda Upland", "Galinda Upland", "Glinda Arduenna", "Galinda Arduenna"],
            "correctAnswer": 1
        ],
        [
            "text": "Which Taylor Swift album was recorded entirely in secret?",
            "answers": ["1989", "Folklore", "Midnights", "Reputation"],
            "correctAnswer": 1
        ]
    ]
    
    static var quizzes: [[String: Any]] = [
        [
            "title": "Mathematics",
            "description": "Test your math skills",
            "icon": "math-icon-orange",
            "questions": mathQuestions
        ],
        [
            "title": "Marvel Super Heroes",
            "description": "How well do you know about Marvels heroes?",
            "icon": "marvel-logo-purple",
            "questions": marvelQuestions
        ],
        [
            "title": "Science",
            "description": "Test youw knowledge about science",
            "icon": "science-orange",
            "questions": scienceQuestions
        ]
            ,
        [
            "title": "Pop Culture",
            "description": "Test your knowledge about pop culture",
            "icon": "pop-culture-purple",
            "questions": popCultureQuestions
        ]
    ]
}
