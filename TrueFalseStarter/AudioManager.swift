//
//  AudioManager.swift
//  TrueFalseStarter
//
//  Created by Mohammed Al-Dahleh on 2017-10-24.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import AudioToolbox

class AudioManager {
    var gameSound: SystemSoundID = 0
    var rightAnswerSound: SystemSoundID = 1
    var wrongAnswerSound: SystemSoundID = 2
    
    let toLoad = ["GameSound", "RightSound", "WrongSound"]
    
    init () {
        loadSounds()
    }
    
    func loadSounds() {
        var pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        var soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
        
        pathToSoundFile = Bundle.main.path(forResource: "RightSound", ofType: "wav")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &rightAnswerSound)
        
        pathToSoundFile = Bundle.main.path(forResource: "WrongSound", ofType: "wav")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &wrongAnswerSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func playRightAnswerSound() {
        AudioServicesPlaySystemSound(rightAnswerSound)
    }
    
    func playWrongAnswerSound() {
        AudioServicesPlaySystemSound(wrongAnswerSound)
    }
}
