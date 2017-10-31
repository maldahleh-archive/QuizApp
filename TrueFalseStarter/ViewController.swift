//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    // TODO: Audio Manager
    var gameSound: SystemSoundID = 0
    
    var gameManager: GameManager!
    
    var questionProvider: QuestionsProvider!
    var currentQuestion: Question!
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
        loadGameStartSound()
        playGameStartSound()
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
            
            secondaryDisplayMessage.text = "You're right!"
        } else {
            button.setTitleColor(UIColor.red, for: .normal)
            gameManager.logIncorrectAnswer()
            
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
        
        resetTitleColour()
        setButtonUsabilityTo(true)
        
        currentTask = DispatchWorkItem { self.displayTimedOut() }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15, execute: currentTask)
    }
    
    func displayTimedOut() {
        gameManager.logIncorrectAnswer()
        
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
        
        questionProvider = QuestionsProvider()
        gameManager = GameManager(questionProvider: questionProvider)
        displayQuestion()
    }
    
    func resetTitleColour() {
        answerOneBox.setTitleColor(.white, for: .normal)
        answerTwoBox.setTitleColor(.white, for: .normal)
        answerThreeBox.setTitleColor(.white, for: .normal)
        answerFourBox.setTitleColor(.white, for: .normal)
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
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}
