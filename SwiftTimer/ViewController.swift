//
//  ViewController.swift
//  SwiftTimer
//
//  Created by Shunchao Wang on 7/28/2015.
//  Copyright (c) 2015 swang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = NSTimer()
    var timeArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.startButton.layer.cornerRadius = 5.0
        stopButton.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(sender: AnyObject) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimeLabel", userInfo: NSDate(), repeats: true)
        
        startButton.hidden = true
        stopButton.hidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparentNavbar"), forBarMetrics: UIBarMetrics.Default)
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        timer.invalidate()
    }
    
    func updateTimeLabel() {
        var elapsed: NSTimeInterval = -(self.timer.userInfo as! NSDate).timeIntervalSinceNow
        if elapsed < 60 {
        timeLabel.text = String(format: "%.0f", arguments: [elapsed])
        } else {
            timeLabel.text = String(format: "%.0f:%02f", arguments: [elapsed / 60, elapsed % 60])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var savedTime = timeLabel.text
        timeArray.append(savedTime!)
        stopButton.hidden = true
        startButton.hidden = false
        timeLabel.text = "0"
        let nextViewController = segue.destinationViewController as! SaveTimesTableViewController
        nextViewController.savedTimesArray = timeArray
    }

}

