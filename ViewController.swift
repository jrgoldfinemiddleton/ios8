		//
//  ViewController.swift
//  Calculator
//
//  Created by Jason Goldfine-Middleton on 3/2/15.
//  Copyright (c) 2015 Jason Goldfine-Middleton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var display: UILabel!
  @IBOutlet weak var history: UILabel!
  
  var userIsInTheMiddleOfTypingANumber = false
  
  @IBAction func backspace() {
    if userIsInTheMiddleOfTypingANumber {
      display.text = dropLast(display.text!)
      history.text = dropLast(history.text!)
      if countElements(display.text!) < 1 {
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false
      }
    }
  }
  
  func appendToHistory(item: String) {
    history.text = history.text! + item
  }
  
  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    if userIsInTheMiddleOfTypingANumber {
      if digit != "." || display.text!.rangeOfString(".") == nil {
        display.text = display.text! + digit
        appendToHistory(digit)
      }
    } else {
      display.text = digit
      userIsInTheMiddleOfTypingANumber = true
      appendToHistory(digit)
    }
  }
  
  @IBAction func appendOperandToStack(sender: UIButton) {
    let operand = sender.currentTitle!
    if userIsInTheMiddleOfTypingANumber {
      enter()
    }
    switch operand {
      case "π": display.text = "\(M_PI)"
      default: break
    }
    enter()
    appendToHistory(operand + " ")
  }
  
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    if userIsInTheMiddleOfTypingANumber {
      enter()
    }
    switch operation {
      case "+": performOperation { $1 + $0 }
      case "−": performOperation { $1 - $0 }
      case "×": performOperation { $1 * $0 }
      case "÷": performOperation { $1 / $0 }
      case "√": performOperation { sqrt($0) }
      case "sin": performOperation { sin($0) }
      case "cos": performOperation { cos($0) }
      default: break
    }
    appendToHistory(operation + " ")
  }
  
  func performOperation(operation: (Double, Double) -> Double) {
    if operandStack.count >= 2 {
      displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
      enter()
    }
  }
  
  func performOperation(operation: (Double) -> Double) {
    if operandStack.count >= 1 {
      displayValue = operation(operandStack.removeLast())
      enter()
    }
  }
  
  var operandStack = Array<Double>()
  
  @IBAction func enter() {
    userIsInTheMiddleOfTypingANumber = false
    operandStack.append(displayValue)
    appendToHistory(" ")
    println("operandStack = \(operandStack)")
  }
  
  @IBAction func clearAll() {
    display.text = "0"
    history.text = "History: "
    operandStack.removeAll()
  }
  
  var displayValue: Double {
    get {
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
    }
    set {
      display.text = "\(newValue)"
      userIsInTheMiddleOfTypingANumber = false
    }
  }
}