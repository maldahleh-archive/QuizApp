//
//  ColourModel.swift
//  TrueFalseStarter
//
//  Created by Mohammed Al-Dahleh on 2017-11-01.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import UIKit

struct Colour {
    let mainColour: UIColor
    let secondaryColour: UIColor
    let textColour: UIColor
    
    init (mainColour: UIColor, secondaryColour: UIColor, textColour: UIColor) {
        self.mainColour = mainColour
        self.secondaryColour = secondaryColour
        self.textColour = textColour
    }
}
