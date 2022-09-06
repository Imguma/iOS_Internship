//
//  ViewController.swift
//  Calculator_v1
//
//  Created by 임가영 on 2022/09/05.
//

import UIKit


enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case unknown
}


class ViewController: UIViewController {

    
    @IBOutlet weak var numberOutputLabel: UILabel!
    
    var displayNumber = ""  
    var firstOperand = ""   // 첫번째 피연산자
    var secondOperand = ""  // 두번째 피연산자
    var result = ""         // 결과값
    var currentOperation: Operation = .unknown  // 연산자 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapNumberButton(_ sender: UIButton) {
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
    }
    @IBAction func tapDotButton(_ sender: UIButton) {
    }
    @IBAction func tapDivideButton(_ sender: UIButton) {
    }
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
    }
    @IBAction func tapMinusButton(_ sender: UIButton) {
    }
    @IBAction func tapPlusButton(_ sender: UIButton) {
    }
    @IBAction func tapEqualButton(_ sender: UIButton) {
    }
     
}

