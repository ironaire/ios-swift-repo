//
//  ViewController.swift
//  Calculator
//
//  Created by Shunchao Wang on 8/21/2015.
//  Copyright (c) 2015 swang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // why we don't have to initialize this?
    // Actually Xcode has a default nil initialization here, it equals to 
    // weak var display: UILabel! = nil
    // Here the display is not optional, because we put the IBOutlet annotation on the instance variable,
    // this makes the display initialize before the Controller init when the scene is initiated.
    // we call this implicitly unwrapped optional
    @IBOutlet weak var display: UILabel!
    
    // Both class and instance variable must be initialized when declared
    // or in the class initializer
    var userIsInTheMiddleOfTypingNumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        
        // Swift is strongly typed language, and swift is good at type inference
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        
        // we are using swich block
        switch operation {
        case "×":
        
        // Since Swift is able to take a function type as the argument, 
        // tranditionally the function type can be used as the arguments
            // style 1: performOperation(multiply)
            
        // we can use closure by calling
        // style 2: performOperation({(op1: Double, op2: Double) -> Double in
        //    return op1 * op2})
        
        // We also know swift is strongly typed, 
        // we could remove arguments' types and return type,
        // since we already declare the types for both when we define the func
            // style 3: performOperation({(op1, op2) in return op1 * op2})
        
        // we already specify the return in our func, we can for sure remove the return
        // in closure
            // style 4: performOperation({(op1, op2) in op1 * op2})
            
        // we can further use swift built-in argument representation instead of
        // using naming auguments to simplify our code
            // style 5: performOperation({$0 * $1})
            
        // if the auguments are the last arguments we can put the arguments
        // outside of parentheses,
        // all arguments before the last arguments need to go inside of parentheses
            //style 6: performOperation() {$0 * $1}
            
        // if there is no argument except the last arguments passed in,
        // the parentheses can be omited
            performOperation {$0 * $1}
        case "÷":
            performOperation {$1 / $0}
        case "+":
            performOperation {$0 + $1}
        case "−":
            performOperation {$1 - $0}
        case "√":
            performSingleOperation {sqrt($0)}
        default: break
        }
    }
    
    // Swift is able to take a function type as the argument
    // here the operation is a function type taking 2 double arguments and 
    // returning a double value
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    // function for one operand
    func performSingleOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // the 4 functions below are safe to be removed since we use swift closure
    
    // define a func multiply to multiply two doubles and return a double
    func multiply(op1: Double, op2: Double) -> Double {
        return op1 * op2
    }
    // define a func divide to divide two doubles and return a double
    func divide(op1: Double, op2: Double) -> Double {
        return op2 / op1
    }
    
    // define a func plus to plus two doubles and return a double
    func plus(op1: Double, op2: Double) -> Double {
        return op1 + op2
    }
    
    // define a func minus to minus two doubles and return a double
    func minus(op1: Double, op2: Double) -> Double {
        return op2 - op1
    }
    
    
    // Swift is strongly typed, and is good at type inference, so we can omit the type with declaration
    // instead of 
    // var operandStack: Array<Double> = Array<Double>()
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        // we will use a computed properties to convert the optional display.text
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    // we need a computed properties here to convert the string in label
    // to Double, and then we are able to store the double into the operand stack.
    // we are defining a dynamic instance variable here
    var displayValue: Double {
        get {
            return NSNumberFormatter()
                .numberFromString(display.text!/*Unwrap the optional*/)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
}
