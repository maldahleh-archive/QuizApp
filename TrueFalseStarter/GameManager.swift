//
//  GameManager.swift
//  TrueFalseStarter
//
//  Created by Mohammed Al-Dahleh on 2017-10-23.
//  Copyright © 2017 Treehouse. All rights reserved.
//

class GameManager {
    // Store reference to the question provider
    var questionProvider: QuestionsProvider! = nil
    
    // Store the number of correct answers vs total answers
    var correctAnswers: Int = 0
    var totalAnswers: Int = 0
    
    // Store a correct answer
    func logCorrectAnswer() {
        correctAnswers += 1
        totalAnswers += 1
    }
    
    // Store an incorrect answer
    func logIncorrectAnswer() {
        totalAnswers += 1
    }
    
    // Check whether the game is over (total questions = total answers)
    func isGameOver() -> Bool {
        return totalAnswers == questionProvider.totalQuestions
    }
    
    // Reset the manager for a new game
    func setupWith(questionProvider: QuestionsProvider) {
        self.questionProvider = questionProvider
        
        correctAnswers = 0
        totalAnswers = 0
    }
}
