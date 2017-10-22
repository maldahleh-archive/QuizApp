//
//  Question.swift
//  TrueFalseStarter
//
//  Created by Mohammed Al-Dahleh on 2017-10-22.
//  Copyright © 2017 Treehouse. All rights reserved.
//

struct Question {
    // Store the question
    let question: String
    // List to store the possible answers
    let answers: [String]
    // ID (0 to total answers less one) of the correct answer
    let answer: Int
    
    /*
         Verify that the answer selected is the correct one
     */
    func isAnswerCorrect(usingID id: Int) -> Bool {
        return id == answer
    }
}
