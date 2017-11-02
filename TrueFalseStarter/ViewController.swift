//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    // Store the audio manager that handles playing sound
    let audioManager = AudioManager()
    // Store the game manager that handles answers
    let gameManager = GameManager()
    
    // Access to colour information
    var colourProvider: ColourProvider!
    var colour: Colour!
    // Access to question information
    var questionProvider: QuestionsProvider!
    var currentQuestion: Question!
    // Store the task used for lightning mode
    var currentTask: DispatchWorkItem!
    
    // Outlets used for message labels
    @IBOutlet weak var mainDisplayMessage: UILabel!
    @IBOutlet weak var secondaryDisplayMessage: UILabel!
    
    // Outlets used for answer buttons
    @IBOutlet weak var answerOneBox: UIButton!
    @IBOutlet weak var answerTwoBox: UIButton!
    @IBOutlet weak var answerThreeBox: UIButton!
    @IBOutlet weak var answerFourBox: UIButton!
    
    @IBOutlet weak var mainInteractButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioManager.playGameStartSound()
        loadStartUI()
    }
    
    // MARK: Functions used for button interaction

    @IBAction func mainButtonClicked(_ sender: Any) {
        if let currentTitle = mainInteractButton.currentTitle {
            switch(currentTitle) {
            case "Start!", "Play Again!": prepareForNewGame()
            default: print("Unknown....")
            }
        }
    }
    
    @IBAction func questionButtonClicked(_ sender: Any) {
        cancelTaskNamed(currentTask)
        
        let button = sender as! UIButton
        let selectedAnswer = button.tag
        
        if currentQuestion.isAnswerCorrect(usingID: selectedAnswer) {
            button.setTitleColor(UIColor.green, for: .normal)
            gameManager.logCorrectAnswer()
            audioManager.playRightAnswerSound()
            
            secondaryDisplayMessage.text = "You're right!"
        } else {
            button.setTitleColor(UIColor.red, for: .normal)
            gameManager.logIncorrectAnswer()
            audioManager.playWrongAnswerSound()
            
            secondaryDisplayMessage.text = "Sorry, you're wrong!"
            
            switch(currentQuestion.answer) {
            case 0: answerOneBox.setTitleColor(UIColor.green, for: .normal)
            case 1: answerTwoBox.setTitleColor(UIColor.green, for: .normal)
            case 2: answerThreeBox.setTitleColor(UIColor.green, for: .normal)
            case 3: answerFourBox.setTitleColor(UIColor.green, for: .normal)
            default: return
            }
        }
        
        setButtonUsabilityTo(false)
        loadNextRoundWithDelay(seconds: 2)
    }
    
    // MARK: Main UI Methods
    
    func loadStartUI() {
        mainDisplayMessage.text = "Welcome!"
        secondaryDisplayMessage.text = "Click below to start."
        
        setButtonsHiddenTo(true)
        mainInteractButton.setTitle("Start!", for: .normal)
    }
    
    func displayQuestion() {
        if gameManager.isGameOver() {
            displayGameOver()
            return
        }
        
        currentQuestion = questionProvider.getNextQuestion()
        selectAndUpdateColour()
        
        switch(currentQuestion.answers.count) {
        case 2:
            answerOneBox.setTitle(currentQuestion.answers[0], for: .normal)
            answerTwoBox.setTitle(currentQuestion.answers[1], for: .normal)
            
            answerThreeBox.isHidden = true
            answerFourBox.isHidden = true
        case 3:
            answerOneBox.setTitle(currentQuestion.answers[0], for: .normal)
            answerTwoBox.setTitle(currentQuestion.answers[1], for: .normal)
            answerThreeBox.setTitle(currentQuestion.answers[2], for: .normal)
            
            answerThreeBox.isHidden = false
            answerFourBox.isHidden = true
        case 4:
            answerOneBox.setTitle(currentQuestion.answers[0], for: .normal)
            answerTwoBox.setTitle(currentQuestion.answers[1], for: .normal)
            answerThreeBox.setTitle(currentQuestion.answers[2], for: .normal)
            answerFourBox.setTitle(currentQuestion.answers[3], for: .normal)
            
            answerThreeBox.isHidden = false
            answerFourBox.isHidden = false
        default: return
        }
        
        mainDisplayMessage.text = currentQuestion.question
        secondaryDisplayMessage.text = ""
        
        setButtonUsabilityTo(true)
        
        currentTask = DispatchWorkItem { self.displayTimedOut() }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15, execute: currentTask)
    }
    
    func displayTimedOut() {
        gameManager.logIncorrectAnswer()
        audioManager.playWrongAnswerSound()
        
        secondaryDisplayMessage.text = "You ran out of time!"
        
        switch(currentQuestion.answer) {
        case 0: answerOneBox.setTitleColor(UIColor.green, for: .normal)
        case 1: answerTwoBox.setTitleColor(UIColor.green, for: .normal)
        case 2: answerThreeBox.setTitleColor(UIColor.green, for: .normal)
        case 3: answerFourBox.setTitleColor(UIColor.green, for: .normal)
        default: return
        }
        
        setButtonUsabilityTo(false)
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func displayGameOver() {
        resetUIColour()
        
        mainDisplayMessage.text = "Game Over!"
        secondaryDisplayMessage.text = "Your score is \(gameManager.correctAnswers) / \(gameManager.totalAnswers)"
        mainInteractButton.setTitle("Play Again!", for: .normal)
        
        setButtonsHiddenTo(true)
        setMainButtonHiddenTo(false)
    }
    
    // MARK: UI Helper Methods
    
    func prepareForNewGame() {
        setButtonsHiddenTo(false)
        setMainButtonHiddenTo(true)
        
        colourProvider = ColourProvider()
        questionProvider = QuestionsProvider()
        gameManager.setupWith(questionProvider: questionProvider)
        displayQuestion()
    }
    
    func selectAndUpdateColour() {
        colour = colourProvider.randomColour()
        
        self.view.backgroundColor = colour.mainColour
        
        mainDisplayMessage.textColor = colour.textColour
        secondaryDisplayMessage.textColor = colour.textColour
        
        answerOneBox.backgroundColor = colour.secondaryColour
        answerTwoBox.backgroundColor = colour.secondaryColour
        answerThreeBox.backgroundColor = colour.secondaryColour
        answerFourBox.backgroundColor = colour.secondaryColour
        
        setTitleColour()
    }
    
    func setTitleColour() {
        answerOneBox.setTitleColor(colour.textColour, for: .normal)
        answerTwoBox.setTitleColor(colour.textColour, for: .normal)
        answerThreeBox.setTitleColor(colour.textColour, for: .normal)
        answerFourBox.setTitleColor(colour.textColour, for: .normal)
    }
    
    func setButtonsHiddenTo(_ value: Bool) {
        answerOneBox.isHidden = value
        answerTwoBox.isHidden = value
        answerThreeBox.isHidden = value
        answerFourBox.isHidden = value
    }
    
    func setMainButtonHiddenTo(_ value: Bool) {
        mainInteractButton.isHidden = value
    }
    
    func setButtonUsabilityTo(_ value: Bool) {
        answerOneBox.isEnabled = value
        answerTwoBox.isEnabled = value
        answerThreeBox.isEnabled = value
        answerFourBox.isEnabled = value
    }
    
    func resetUIColour() {
        self.view.backgroundColor = colourProvider.startingColours.mainColour
        
        mainDisplayMessage.textColor = colourProvider.startingColours.textColour
        secondaryDisplayMessage.textColor = colourProvider.startingColours.textColour
    }
    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)

        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.displayQuestion()
        }
    }
    
    func cancelTaskNamed(_ task: DispatchWorkItem) {
        task.cancel()
    }
}
