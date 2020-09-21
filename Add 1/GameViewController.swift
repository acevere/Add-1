//
//  ViewController.swift
//  Add 1
//
//  Created by Alice Ye on 2020-06-16.
//  Copyright © 2020 Alice Ye. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var numberLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    
    var score = 0
    var timer:Timer?
    var timerSeconds = 25
    var secondsRemaining = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScoreLabel()
        updateNumberLabel()
        updateTimeLabel()
    }

    func updateScoreLabel() {
        //optional chaining, only runs if scoreLabel is not NIL, stops if otherwise
        scoreLabel?.text = String(score)
    }
    
    func updateNumberLabel() {
        numberLabel?.text = String.randomNumber(length: 4)
    }
    
    @IBAction func inputFieldDidChange()
    {
        guard let numberText = numberLabel?.text, let inputText = inputField?.text else {
            return
        }
        
        // Option 1: With guard...
        guard inputText.count == 4 else {
            return
        }

        // Option 2: With if...
        //if inputText.count != 4 {
        //    return
        //}
        
        var isCorrect = true
        
        for n in 0..<4
        {
            var input = inputText.integer(at: n)
            if input == 0 {
                input = 10
            }
            let number = numberText.integer(at: n)
            if input != number + 1 {
                isCorrect = false
                break
            }
        }
        
        if isCorrect {
            score += 1
        } else {
            score -= 1
        }

        updateNumberLabel()
        updateScoreLabel()
        inputField?.text = ""
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.secondsRemaining == 0 {
                    self.finishGame()
                } else {
                    self.secondsRemaining -= 1
                    self.updateTimeLabel()
                }
            }
        }
        
    }
    
    func updateTimeLabel() {

        let min = (secondsRemaining / 60) % 60
        let sec = secondsRemaining % 60

        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
    func finishGame()
    {
        timer?.invalidate()
        timer = nil
        
        let alert = UIAlertController(title: "Time's Up!", message: "Your time is up! You got a score of \(score) points. Awesome!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, start new game", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
        score = 0
        secondsRemaining = timerSeconds
        
        updateTimeLabel()
        updateScoreLabel()
        updateNumberLabel()
        inputField?.text = ""
    }
}

