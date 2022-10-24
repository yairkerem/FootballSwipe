//
//  ViewController.swift
//  FunWithAnan
//
//  Created by Yair Kerem on 15/06/2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var remainingBallsLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!

    @IBAction func newGameTapped(_ sender: UIButton) {
        startNewGame()
    }
    
    let numberOfBalls = 10
    var numberOfRemainingShots = 0
    var totalScore = 0
    
    var player: AVAudioPlayer!
    let goalImage = GoalView(frame: CGRect(x: 10, y: 90, width: 370, height: 200))
// Width defined with a magic number. When possible: replace to (viewController width - 20), at the moment this is only available in the viewDidLoad (and not when defining goalImage
    
    var timeRemaining: Int = 30
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(goalImage)
       
//        balls
        createBalls(numberOfBalls: numberOfBalls)
        
//        remaining ball counter
        remainingBallsLabel.center = CGPoint(x: 110, y: 73)
        remainingBallsLabel.textAlignment = .center
        remainingBallsLabel.text = String(self.numberOfRemainingShots)
        remainingBallsLabel.font = UIFont.boldSystemFont(ofSize: 30)
        remainingBallsLabel.textColor = .blue
        remainingBallsLabel.shadowColor = .lightGray
        remainingBallsLabel.shadowOffset = CGSize(width: 2, height: 2)
       
//        timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step) , userInfo: nil, repeats: true)
        
        remainingTimeLabel.center = CGPoint(x: 350, y: 73)
        remainingTimeLabel.textAlignment = .center
        remainingTimeLabel.font = UIFont.boldSystemFont(ofSize: 30)
        remainingTimeLabel.textColor = .blue
        remainingTimeLabel.shadowColor = .lightGray
        remainingTimeLabel.shadowOffset = CGSize(width: 2, height: 2)
       
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            gameOver()
        }
        remainingTimeLabel.text = "\(timeRemaining)"
    }
    
    func createBalls(numberOfBalls: Int) {
        let xRange = Range(0...320)
        let yRange = Range(500...740)
        self.numberOfRemainingShots = numberOfBalls
        for _ in 0..<numberOfBalls {
            let ballImageView = BallView(frame: CGRect(x: Int.random(in: xRange), y: Int.random(in: yRange), width: 50, height: 50))
            ballImageView.layer.masksToBounds = false
            ballImageView.layer.cornerRadius = ballImageView.frame.height/2
            ballImageView.clipsToBounds = true
            self.view.addSubview(ballImageView)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.draggedView(_:)))
            ballImageView.addGestureRecognizer(panGestureRecognizer)
            self.view.addSubview(ballImageView)
        }
    }
    
    @objc func draggedView(_ sender: UIPanGestureRecognizer) {
        guard let draggedView = sender.view else {return}
        draggedView.center = sender.location(in: self.view)
        self.view.bringSubviewToFront(draggedView)
        
        if sender.state == .ended {
            if goalImage.frame.contains(draggedView.center) {
                UIView.animate(withDuration: 1.0) {
                    draggedView.alpha = 0
                } completion: { finished in
                    draggedView.removeFromSuperview()
                    self.numberOfRemainingShots -= 1
                    self.totalScore += 1
                    self.remainingBallsLabel.text = String(self.numberOfRemainingShots) // I would prefer to reload the data instead re-assigning the updated value after every shot
                    self.playSound()
                }
            }
        }
        sender.view?.center = sender.location(in: self.view)
    }
    
    func playSound() {
        guard let soundFileURL = Bundle.main.url(
            forResource: "MessiGoal", withExtension: "mp3")
        else {
            print("File not found")
            return
        }

        player = try! AVAudioPlayer(contentsOf: soundFileURL)
        player.play()
     }
        
    func endGame() {
        self.timeRemaining = 0
        
    }
    
    func startNewGame() {
        self.timeRemaining = 30
        let requiredNumberOfBalls = numberOfBalls - numberOfRemainingShots
        createBalls(numberOfBalls: requiredNumberOfBalls)
        numberOfRemainingShots = numberOfBalls
        remainingBallsLabel.text = String(numberOfRemainingShots)
    }
    
    func gameOver() {
        let alertController = UIAlertController(title: "GAME OVER!", message: "Final score: \(totalScore)", preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    
}



