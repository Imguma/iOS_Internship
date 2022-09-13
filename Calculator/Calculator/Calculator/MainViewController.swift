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
 
class MainViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!
    
    var displayNumber = ""  // numberOutputLabel 숫자 표기
    var firstOperand = ""   // 첫번째 피연산자
    var secondOperand = ""  // 두번째 피연산자
    var result = ""         // 결과값
    var currentOperation: Operation = .unknown  // 연산자
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스와이프 제스쳐 등록
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipeGestureRecognizer.direction = .left
        view.addGestureRecognizer(leftSwipeGestureRecognizer)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        // 왼쪽으로 스와이프 하면 뒤에서 부터 한자리씩 사라집니다.
        if (sender.direction == .left) {
            if !self.displayNumber.isEmpty {
                let swipeNumber = self.displayNumber.dropLast()
                self.displayNumber = String(swipeNumber)
                self.numberOutputLabel.text = self.displayNumber
            }
        }
    }
    
    /**
     버튼 값을 가져오는 액션함수입니다.
     */
    @IBAction func tapNumberButton(_ sender: UIButton) {
        
        guard let numberValue = sender.title(for: .normal) else { return }  // 버튼 값 가져오기
           
        if self.displayNumber.count < 9 {  // 9자리까지만 입력받로록
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        } else {  // 9자리가 넘어가면 경고창 띄움
            let alert = UIAlertController(title: "경고", message: "9자리 까지만 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
              return
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     AC 버튼을 누르면 초기화되는 액션함수입니다.
     */
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    /**
     소수점을 만들어주는 액션함수입니다.
     */
    @IBAction func tapDotButton(_ sender: UIButton) {
        // 소수점 포함 9자리까지
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    /**
     각각의 연산자 버튼을 눌렀을 때 호출되는 액션함수입니다.
     */
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
     연산을 진행하는 operation 함수입니다.
     > 현재 연산자(currentOperation)가 지정되었는지 확인
     - 없다면 첫번째 피연산자와 해당 연산자를 저장
     - 있다면 단항연산자인지 이항연산자인지 체크
        - 단항연산자 -> unaryOperation 함수 호출
        - 이항연산자 -> binaryOperation 함수 호출
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
     */
    func unaryOperation(_ operation: Operation) {
        
        if self.displayNumber.isEmpty {
            self.firstOperand = self.result    // 누적 연산을 위해 이전 결과값을 가져옴
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

