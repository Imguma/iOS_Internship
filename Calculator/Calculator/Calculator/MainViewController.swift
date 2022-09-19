import UIKit

// 연산자를 정의한 enum입니다.
enum Operation {
    case Add         // 더하기 연산자
    case Subtract    // 빼기 연산자
    case Divide      // 나누기 연산자
    case Multiply    // 곱하기 연산자
    case Reverse     // 부호전환 연산자
    case Percent     // 퍼센트 연산자
    case unknown     // 연산자 미지정 상태
}
 
class MainViewController: UIViewController {

    @IBOutlet weak var numberOutputLabel: UILabel!  // 계산기 Label에 표시되는 숫자
    
    var displayNumber = ""   // numberOutputLabel 표기용 숫자
    var operationNumber = "" // 연산용 숫자
    var firstOperand = ""    // 첫번째 피연산자
    var secondOperand = ""   // 두번째 피연산자
    var result = ""          // 결과값
    var currentOperation: Operation = .unknown  // 연산자 상태 기본값: 미지정
    
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
                let swipeNumber = self.operationNumber.dropLast()   // 마지막 문자 제거
                self.operationNumber = String(swipeNumber)
                self.displayNumber = self.operationNumber
                printNumberOutputLabel()
            }
        }
        if self.displayNumber.isEmpty {
            self.numberOutputLabel.text = "0"
        }
    }
    
    /**
     버튼 값을 가져오는 액션함수입니다.
     */
    @IBAction func tapNumberButton(_ sender: UIButton) {
        guard let numberValue = sender.title(for: .normal) else { return }  // 버튼 값 가져오기
        
        displayNumberToOperationNumber()     // 보여지는 숫자에서 콤마(,) 를 제외한 순수 숫자 구하기
        
        if self.operationNumber.count < 9 {  // 긍정(9자리까지만 입력받로록)
            if self.displayNumber == "0" {   // 긍정(초기에 0입력받으면 -> 0출력해주고 초기화)
                self.numberOutputLabel.text = self.displayNumber
                self.displayNumber = ""
            } else {  // 부정(0이외의 입력이 들어오면 -> 정상출력)
                self.displayNumber += numberValue
                displayNumberToOperationNumber()   // 보여지는 숫자에서 콤마(,) 를 제외한 순수 숫자 구하기
                printNumberOutputLabel()           // Label에 숫자 출력
            }
        } else {  // 부정(9자리가 넘어가면 -> 경고창)
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
        self.operationNumber = ""
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
        // 소수점 포함 9자리까지만 입력받도록
        if self.operationNumber.count < 8, !self.operationNumber.contains(".") {
            displayNumberToOperationNumber()    // 보여지는 숫자에서 콤마(,) 를 제외한 순수 숫자 구하기
            isOverThreeDigits()                 // 만약 3 자리 이상이라면 3 자리수마다 콤마(,) 넣어주기
            self.displayNumber += self.operationNumber.isEmpty ? "0." : "."   // 소수점 추가
            self.operationNumber = self.displayNumber
            self.numberOutputLabel.text = self.displayNumber
        } else if self.operationNumber.contains(".") {   // 소수점이 있는 상태에서 소수점을 또 추가하면 경고 알림창 띄우기
            let alert = UIAlertController(title: "경고", message: "올바르지 않은 수식입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
              return
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**unaryOperation
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
    
    @IBAction func tapReverseButton(_ sender: UIButton) {
        self.currentOperation = .Reverse
        self.operation(self.currentOperation)
    }
    
    @IBAction func tapPercentButton(_ sender: UIButton) {
        self.currentOperation = .Percent
        self.operation(self.currentOperation)
    }

    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    /**
     연산을 진행하는 operation 함수입니다.
     */
    func operation(_ operation: Operation) {
        if self.currentOperation != .unknown {  // 현재 연산자가 지정된 상태인지 확인
            if self.currentOperation == .Reverse || self.currentOperation == .Percent {  // 단항 연산자인가?
                unaryOperation()   // 단항 연산 함수 호출
            } else {  // 단항 연산자가 아니라면 이항 연산자
                binaryOperation()
            }
            
            // Double형 값에서 1로 나누어지면 Int형으로 전환
            if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 { // Double형에서 나머지연산시 truncatingRemainder 사용
                self.result = "\(Int(result))"
            }
            
            // 이전 결과값 저장
            self.firstOperand = self.result
            self.operationNumber = self.result
            self.displayNumber = self.result
            
            printNumberOutputLabel()    // 결과값 출력
            
            self.currentOperation = operation    // 현재 연산자 저장
        } else {   // 피연산자와 연산자 저장
            self.firstOperand = self.operationNumber  // 첫번째 피연산자 저장
            self.currentOperation = operation         // 선택한 연산자 저장
            self.displayNumber = ""                   // 디스플레이 초기화
        }
    }
    
    /**
     이항 연산을 하는 함수입니다.
     */
    func binaryOperation() {
        displayNumberToOperationNumber()           // 연산용 숫자로 변환
        
        if !self.displayNumber.isEmpty {  // 긍정(두번째 피연산자가 있다면 -> 입력받은 값을 두번째 피연산자에 저장)
            self.secondOperand = self.operationNumber
        } else {  // 부정(두번째 피연산자가 없다면 -> 첫번째 피연산자를 두번째 피연산자에 저장)
            self.secondOperand = self.firstOperand
            
        }
        self.displayNumber = ""                    // 빈 문자열로 초기화
        self.operationNumber = ""                  // 빈 문자열로 초기화
        
        // (String -> Double) 변환
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
    func unaryOperation() {
        
        if self.operationNumber.isEmpty {   // 긍정(입력값이 없다면 -> 이전에 연산을 한적이 있거나 연산을 한적이 없는 경우)
            if !self.result.isEmpty {  // 긍정(결과값이 있다면 -> 누적 연산을 위해 이전 결과값을 피연산자로 가져오기)
                self.firstOperand = self.result
            } else {   // 부정(결과값이 없다면 -> 첫 연산이므로
                self.firstOperand = "0"
            }
        } else {  // 부정(입력값이 있다면 -> 피연산자 가져오기)
            self.firstOperand = self.operationNumber
        }
        
        // (String -> Double) 변환
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
    
    /**
     연산용 숫자로 변환해주는 함수입니다.
     */
    func displayNumberToOperationNumber() {
        if self.displayNumber.contains(",") {   // 긍정(콤마(,)를 포함하고 있다면 -> 연산을 위해 콤마(,) 제거후 할당)
            self.operationNumber = self.displayNumber.components(separatedBy: [","]).joined()
        } else {
            self.operationNumber = self.displayNumber
        }
    }
    
    /**
     콤마를 추가해주는 함수입니다.
     */
    func numberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()   // NumberFormatter 객체 생성
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }

    /**
     세자리를 넘어가는지 검사하는 함수입니다.
     */
    func isOverThreeDigits() {
        guard let checkNumber = Double(self.operationNumber) else { return }   // 세자리를 넘어가는지 확인하기 위한 프로퍼티
        
        if checkNumber >= 1000 || checkNumber <= -1000 {   // 긍정(천의 자리 이상이면 -> numberFormatter 함수 호출)
            self.displayNumber = numberFormatter(number: checkNumber)
        }
    }
    
    /**
     Label에 표시되는 숫자를  출력해주는 함수입니다.
     */
    func printNumberOutputLabel() {
        isOverThreeDigits()      // 만약 3 자리 이상이라면 3 자리수마다 콤마(,) 넣어주기
        self.numberOutputLabel.text = self.displayNumber   // Label에 숫자 출력
    }
}
