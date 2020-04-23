//
//  Meme.swift
//  MeMe
//
// This file is reserved for global
//
//  Created by Chantal Deguire on 2020-04-07.
//  Copyright © 2020 Udacity. All rights reserved.
//

import AVFoundation
import UIKit

//Meme object structure for memory storage
public struct Meme {
       public var topText: String!
       public var bottomText: String!
       public var originalImage: UIImage!
       public var memedImage: UIImage
   }

//Set Default NSAttributes
public let memeTextAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.strokeColor: UIColor.black,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSAttributedString.Key.strokeWidth: -3.0,
]


//Default Text Style Function : for UILabels
public func setTextStyle(_ textLabel: UILabel, _ defaultText: String) {
    textLabel.attributedText = NSAttributedString(string: defaultText, attributes: memeTextAttributes)
    
    textLabel.textAlignment = NSTextAlignment.center
    textLabel.backgroundColor = UIColor.clear
    textLabel.adjustsFontSizeToFitWidth = true
    textLabel.text = defaultText
        
    }

//Default Text Style Function : for UITextFields
public func setTextStyle(_ textField: UITextField, _ defaultText: String) {
    textField.defaultTextAttributes = memeTextAttributes
    
    textField.textAlignment = NSTextAlignment.center
    textField.backgroundColor = UIColor.clear
    textField.adjustsFontSizeToFitWidth = true
    textField.text = defaultText
}

