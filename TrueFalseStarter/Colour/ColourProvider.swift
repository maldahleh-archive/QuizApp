//
//  ColourProvider.swift
//  TrueFalseStarter
//
//  Created by Mohammed Al-Dahleh on 2017-11-01.
//  Copyright © 2017 Mohammed Al-Dahleh. All rights reserved.
//

import UIKit
import GameKit

class ColourProvider {
    // Starting colours
    let startingColours = Colour(mainColour: UIColor(red:0.03, green:0.17, blue:0.24, alpha:1.0),
                                 secondaryColour: UIColor(red:0.05, green:0.47, blue:0.59, alpha:1.0),
                                 textColour: UIColor.white)
    // Colour list
    var colourSets = [
        Colour(mainColour: UIColor(red:0.16, green:0.17, blue:0.14, alpha:1.0),
               secondaryColour: UIColor(red:0.34, green:0.35, blue:0.29, alpha:1.0),
               textColour: UIColor(red:0.51, green:0.42, blue:0.38, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.41, green:0.37, blue:0.45, alpha:1.0),
               secondaryColour: UIColor(red:0.79, green:0.61, blue:0.88, alpha:1.0),
               textColour: UIColor(red:0.95, green:0.75, blue:0.99, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.07, green:0.03, blue:0.05, alpha:1.0),
               secondaryColour: UIColor(red:0.42, green:0.30, blue:0.34, alpha:1.0),
               textColour: UIColor(red:0.54, green:0.42, blue:0.40, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.96, green:0.41, blue:0.38, alpha:1.0),
               secondaryColour: UIColor(red:0.77, green:0.43, blue:0.37, alpha:1.0),
               textColour: UIColor(red:0.85, green:0.65, blue:0.53, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.39, green:0.32, blue:0.27, alpha:1.0),
               secondaryColour: UIColor(red:0.47, green:0.34, blue:0.39, alpha:1.0),
               textColour: UIColor(red:0.42, green:0.50, blue:0.60, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.90, green:0.95, blue:0.29, alpha:1.0),
               secondaryColour: UIColor(red:0.76, green:0.83, blue:0.31, alpha:1.0),
               textColour: UIColor(red:0.52, green:0.63, blue:0.49, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.98, green:0.93, blue:0.80, alpha:1.0),
               secondaryColour: UIColor(red:0.98, green:0.87, blue:0.45, alpha:1.0),
               textColour: UIColor(red:0.93, green:0.68, blue:0.29, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.18, green:0.77, blue:0.71, alpha:1.0),
               secondaryColour: UIColor(red:0.80, green:0.95, blue:0.94, alpha:1.0),
               textColour: UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.55, green:0.38, blue:0.34, alpha:1.0),
               secondaryColour: UIColor(red:0.65, green:0.62, blue:0.60, alpha:1.0),
               textColour: UIColor(red:0.36, green:0.33, blue:0.27, alpha:1.0)),
        Colour(mainColour: UIColor(red:0.44, green:0.37, blue:0.46, alpha:1.0),
               secondaryColour: UIColor(red:0.87, green:0.21, blue:0.62, alpha:1.0),
               textColour: UIColor(red:1.00, green:0.55, blue:0.78, alpha:1.0))
    ]
    
    // Return a random colour set
    func randomColour() -> Colour {
        let selectedIndex = GKRandomSource.sharedRandom().nextInt(upperBound: colourSets.count)
        let selectedColour = colourSets[selectedIndex]
        colourSets.remove(at: selectedIndex)
        
        return selectedColour
    }
}
