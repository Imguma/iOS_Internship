//
//  ViewController.swift
//  Calculator_v1
//
//  Created by 임가영 on 2022/09/05.
//
import UIKit


/// 연산자를 정의한 enum입니다.
enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case Reverse
    case Percent
    case unknown
}
 
class ViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    var displayNumber = ""  // numberOutputLabel 숫자 표기
    var firstOperand = ""   // 첫번째 피연산자
    var secondOperand = ""  // 두번째 피연산자
    var result = ""         // 결과값
    var currentOperation: Operation = .unknown  // 연산자 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// 버튼 값을 가져오는 액션함수입니다. 9자리까지만 입력받도록 합니다.
    @IBAction func tapNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.title(for: .normal) else { return }  // 버튼 값 가져오기
        if self.displayNumber.count < 9 {  // 9자리까지만 입력받로록
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    /// AC 버튼을 누르면 초기화되는 액션함수입니다.
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        // 소수점 포함 9자리까지
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.currentOperation = .unknown
        self.operation(.Divide)
    }
    
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.currentOperation = .unknown
        self.operation(.Multiply)
    }
    
    @IBAction func tapSubtractButton(_ sender: UIButton) {
        self.currentOperation = .unknown
        self.operation(.Subtract)
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.currentOperation = .unknown
        self.operation(.Add)
    }
    
    @IBAction func tapEqualButton(_ sender: UIButton) {
        print(self.currentOperation)
        self.operation(self.currentOperation)
    }
    
    @IBAction func tapReverseButton(_ sender: UIButton) {
        self.currentOperation = .Reverse
        self.operation(self.currentOperation)
    }
    
    @IBAction func tapPercentButton(_ sender: UIButton) {
        self.currentOperation = .Percent
        self.operation(self.currentOperation)
    }

    /**
     연산을 하는 함수입니다.
     > ㅇㅎㅇㅎㅇ
     - Parameters :
        - operation : 전달받은 연산자
     */
    func operation(_ operation: Operation) {
        if self.currentOperation != .unknown {  // 연산자가 지정된 상태인지 확인
            if self.currentOperation == .Reverse || self.currentOperation == .Percent {  // 단항 연산자인가?
                unaryOperation(self.currentOperation)
            } else {  // 이항 연산자인가?
                if !self.displayNumber.isEmpty {    // 두번째 피연산자 입력받은 상태
                    binaryOperation(self.currentOperation)
                }
            }
            // Double형에서 나머지연산시 truncatingRemainder 사용
            if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                self.result = "\(Int(result))"
            }
            
            self.firstOperand = self.result
            self.displayNumber = self.result
            self.numberOutputLabel.text = self.displayNumber
            self.currentOperation = operation
            
        } else {
            self.firstOperand = self.displayNumber  // 첫번째 피연산자 저장
            self.currentOperation = operation       // 선택한 연산자 저장
            self.displayNumber = ""                 // 빈 문자열로 초기화
        }
    }
    
    /**
     이항 연산을 하는 함수입니다.
     이항 연산이므로 피연산자는 2개입니다.
     - Parameters:
        - operation : 해당 이항 연산자 ( +, -, /, x)
     */
    func binaryOperation(_ operation: Operation) {
        
        self.secondOperand = self.displayNumber  // 두번째 피연산자 가져오기
        self.displayNumber = ""  // 디스플레이 초기화
        
        guard let firstOperand = Double(self.firstOperand) else { return }
        guard let secondOperand = Double(self.secondOperand) else { return }
        
        switch self.currentOperation {
            case .Add:
                self.result = "\(firstOperand + secondOperand)"
                
            case .Subtract:
                self.result = "\(firstOperand - secondOperand)"
                    
            case .Divide:
                self.result = "\(firstOperand / secondOperand)"
                        
            case .Multiply:
                self.result = "\(firstOperand * secondOperand)"
                        
            default:
                break
        }
    }
    
    /**
     단항 연산을 하는 함수입니다.
     단항 연산이므로 피연산자는 1개입니다.
     - Parameters:
        - operation: 해당 단항 연산자 ( +/-, %)
     */
    func unaryOperation(_ operation: Operation) {  // 단항 연산
        
        if self.displayNumber.isEmpty {
            self.firstOperand = self.result
        } else {
            self.firstOperand = self.displayNumber
        }
        self.currentOperation = operation
        
        guard let firstOperand = Double(self.firstOperand) else { return }
        
        switch self.currentOperation {
        case .Reverse:
            self.result = "\(firstOperand * -1)"
            
        case .Percent:
            self.result = "\(firstOperand / 100)"
                    
        default:
            break
        }
    }
}


