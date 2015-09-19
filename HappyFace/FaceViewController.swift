//
//  FaceViewController.swift
//  HappyFace
//
//  Created by Shunchao Wang on 9/9/2015.
//  Copyright (c) 2015 swang. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController, FaceViewDataSource {

    // controller needs a pointer to the view
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            // we use property observer to set the data source for face view
            faceView.dataSource = self
            // add pinch handler to face view
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            faceView.addGestureRecognizer(UIRotationGestureRecognizer(target: faceView, action: "rotate:"))
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: faceView, action: "tapTwice:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            faceView.addGestureRecognizer(doubleTapRecognizer)

            let singleTapRecognizer = UITapGestureRecognizer(target: faceView, action: "tapOnce:")
            singleTapRecognizer.numberOfTapsRequired = 1
            singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
            faceView.addGestureRecognizer(singleTapRecognizer)
            
            // pan gesture handler can also be added here
            // we are adding pan gesture recognizer on storyboard
        }
    }
    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    @IBAction func changeHappiness(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            happiness += happinessChange
            sender.setTranslation(CGPointZero, inView: faceView)
        default: break
        }
    }
    
    
    // the model
    // delegate will collaborate from model to view
    var happiness = 75 { // 0 = very sad, 100 = very happy
        didSet {
            happiness = min(max(happiness, 0), 100)
            print("Happiness: \(happiness)")
            updateUI()
        }
    }
    
    private func updateUI() {
        faceView.setNeedsDisplay()
    }
  
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness - 50) / 50
    }
}
