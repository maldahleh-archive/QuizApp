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
    // TODO: Game Manager, Audio Manager
    var gameSound: SystemSoundID = 0
    
    var questionProvider: QuestionsProvider = QuestionsProvider()
    var currentQuestion: Question = Question(question: "Who was the only US president to serve more than two consecutive terms?",
                                             answers: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"],
                                             answer: 1)
    
    @IBOutlet weak var mainDisplayMessage: UILabel!
    @IBOutlet weak var secondaryDisplayMessage: UILabel!
    
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
    
//    func displayQuestion() {
//        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
//        let questionDictionary = trivia[indexOfSelectedQuestion]
//        questionField.text = questionDictionary["Question"]
//        playAgainButton.isHidden = true
//    }
//
//    func displayScore() {
//        // Hide the answer buttons
//        trueButton.isHidden = true
//        falseButton.isHidden = true
//
//        // Display play again button
//        playAgainButton.isHidden = false
//
//        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
//
//    }
//
//    @IBAction func checkAnswer(_ sender: UIButton) {
//        // Increment the questions asked counter
//        questionsAsked += 1
//
//        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
//        let correctAnswer = selectedQuestionDict["Answer"]
//
//        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
//            correctQuestions += 1
//            questionField.text = "Correct!"
//        } else {
//            questionField.text = "Sorry, wrong answer!"
//        }
//
//        loadNextRoundWithDelay(seconds: 2)
//    }
//
//    @IBAction func playAgain() {
//        // Show the answer buttons
//        trueButton.isHidden = false
//        falseButton.isHidden = false
//
//        questionsAsked = 0
//        correctQuestions = 0
//        nextRound()
//    }
    @IBAction func mainButtonClicked(_ sender: Any) {
        if let currentTitle = mainInteractButton.currentTitle {
            switch(currentTitle) {
            case "Start!":
                setButtonsHiddenTo(value: false)
                
                displayQuestion()
            default:
                print("Unknown....")
            }
        }
    }
    
    @IBAction func questionButtonClicked(_ sender: Any) {
        let button = sender as! UIButton
        let selectedAnswer = button.tag
        
        if currentQuestion.isAnswerCorrect(usingID: selectedAnswer) {
            button.setTitleColor(UIColor.green, for: .normal)
            
            secondaryDisplayMessage.text = "You're right!"
        } else {
            button.setTitleColor(UIColor.red, for: .normal)
            
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
        
        setButtonsHiddenTo(value: true)
        mainInteractButton.setTitle("Start!", for: .normal)
    }
    
    func displayQuestion() {
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
        setVisibilityOfMainButtonTo(value: true)
        setButtonUsabilityTo(true)
    }
    
    // MARK: UI Helper Methods
    
    func setButtonsHiddenTo(value: Bool) {
        answerOneBox.isHidden = value
        answerTwoBox.isHidden = value
        answerThreeBox.isHidden = value
        answerFourBox.isHidden = value
    }
    
    func setVisibilityOfMainButtonTo(value: Bool) {
        mainInteractButton.isHidden = value
    }
    
    func setButtonUsabilityTo(_ value: Bool) {
        answerOneBox.isEnabled = value
        answerTwoBox.isEnabled = value
        answerThreeBox.isEnabled = value
        answerFourBox.isEnabled = value
    }
    
    func resetTitleColour() {
        answerOneBox.setTitleColor(UIColor.black, for: .normal)
        answerTwoBox.setTitleColor(UIColor.black, for: .normal)
        answerThreeBox.setTitleColor(UIColor.black, for: .normal)
        answerFourBox.setTitleColor(UIColor.black, for: .normal)
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
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}
