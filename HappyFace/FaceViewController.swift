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
        }
    }
    
    // the model
    // delegate will collaborate from model to view
    var happiness = 75 { // 0 = very sad, 100 = very happy
        didSet {
            happiness = min(max(happiness, 0), 100)
            println("Happiness: \(happiness)")
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
