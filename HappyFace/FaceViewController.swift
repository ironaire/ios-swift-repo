//
//  FaceViewController.swift
//  HappyFace
//
//  Created by Shunchao Wang on 9/9/2015.
//  Copyright (c) 2015 swang. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var happiness = 75 { // 0 = very sad, 100 = very happy
        didSet {
            happiness = min(max(happiness, 0), 100)
            println("Happiness: \(happiness)")
            updateUI()
        }
    }
    
    private func updateUI() {
        
    }
  
}
