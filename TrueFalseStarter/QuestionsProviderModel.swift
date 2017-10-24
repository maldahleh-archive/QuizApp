//
//  QuestionsProviderModel.swift
//  TrueFalseStarter
//
//  Created by Mohammed Al-Dahleh on 2017-10-22.
//  Copyright © 2017 Treehouse. All rights reserved.
//
import GameKit

class QuestionsProvider {
    // Store the total number of questions
    let totalQuestions = 10
    // Store a list of all the questions
    var questions: [Question] = [
        Question(question: "Who was the only US president to serve more than two consecutive terms?",
                 answers: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"],
                 answer: 1),
        Question(question: "Which of the following countries has the most residents?",
                 answers: ["Nigeria", "Russia", "Iran", "Vietnam"],
                 answer: 0),
        Question(question: "In what year was the United Nations founded?",
                 answers: ["1918", "1919", "1945", "1954"],
                 answer: 2),
        Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?",
                 answers: ["Paris", "Washington D.C.", "New York City", "Boston"],
                 answer: 2),
        Question(question: "Which nation produces the most oil?",
                 answers: ["Iran", "Iraq", "Brazil", "Canada"],
                 answer: 3),
        Question(question: "Which country has most recently won consecutive World Cups in Soccer?",
                 answers: ["Italy", "Brazil", "Argentina", "Spain"],
                 answer: 1),
        Question(question: "Which of the following rivers is longest?",
                 answers: ["Yangtze", "Mississippi", "Congo", "Mekong"],
                 answer: 1),
        Question(question: "Which city is the oldest?",
                 answers: ["Mexico City", "Cape Town", "San Juan", "Sydney"],
                 answer: 0),
        Question(question: "Which country was the first to allow women to vote in national elections?",
                 answers: ["Poland", "United States", "Sweden", "Senegal"],
                 answer: 0),
        Question(question: "Which of these countries won the most medals in the 2012 Summer Games?",
                 answers: ["France", "Germany", "Japan", "Great Britian"],
                 answer: 3)
    ]
    
    /*
         Function to return the next question
     */
    func getNextQuestion() -> Question {
        let selected = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        let questionSelected = questions[selected]
        
        questions.remove(at: selected)
        return questionSelected
    }
}
