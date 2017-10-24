//
//  GameManager.swift
//  TrueFalseStarter
//
//  Created by Mohammed Al-Dahleh on 2017-10-23.
//  Copyright © 2017 Treehouse. All rights reserved.
//

class GameManager {
    let questionProvider: QuestionsProvider
    
    var correctAnswers: Int = 0
    var totalAnswers: Int = 0
    
    init(questionProvider: QuestionsProvider) {
        self.questionProvider = questionProvider
    }
    
    func logCorrectAnswer() {
        correctAnswers += 1
        totalAnswers += 1
    }
    
    func logIncorrectAnswer() {
        totalAnswers += 1
    }
    
    func isGameOver() -> Bool {
        return totalAnswers == questionProvider.questions.count
    }
}
