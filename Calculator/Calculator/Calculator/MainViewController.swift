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
    
    var displayNumber = ""  // numberOutputLabel 숫자 표기
    var firstOperand = ""   // 첫번째 피연산자
    var secondOperand = ""  // 두번째 피연산자
    var result = ""         // 결과값
    var commaNumber = ""    // 콤마 표기를 위한
    var operationNumber = "" // 연산용 숫자
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
                let swipeNumber = self.operationNumber.dropLast()
                self.displayNumber = String(swipeNumber)
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
        
        if self.operationNumber.count < 9 {  // 9자리까지만 입력받로록
            self.displayNumber += numberValue
            stringToOperationNumber()
            printNumberOutputLabel()
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
        self.operationNumber = ""
    }
    
    /**
     소수점을 만들어주는 액션함수입니다.
     */
    @IBAction func tapDotButton(_ sender: UIButton) {
        // 소수점 포함 9자리까지
        if self.operationNumber.count < 8, !self.operationNumber.contains(".") {
            printDotNumberOuputLabel()
        } else if self.operationNumber.contains(".") {
            let alert = UIAlertController(title: "경고", message: "올바르지 않은 수식입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
              return
            })
            self.present(alert, animated: true, completion: nil)
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
     > 현재 연산자(currentOperation)가 지정되었는지 확인
     - 없다면 첫번째 피연산자와 해당 연산자를 저장
     - 있다면 단항연산자인지 이항연산자인지 체크
        - 단항연산자 -> unaryOperation 함수 호출
        - 이항연산자 -> binaryOperation 함수 호출
     */
    func operation(_ operation: Operation) {
        if self.currentOperation != .unknown {  // 현재 연산자가 지정된 상태인지 확인
            if self.currentOperation == .Reverse || self.currentOperation == .Percent {  // 단항 연산자인가?
                unaryOperation()   // 단항 연산 함수 호출
            } else {  // 단항 연산자가 아니라면 이항 연산자
                if !self.displayNumber.isEmpty {  // 두번째 피연산자 입력받은 상태인가?
                    binaryOperation()   // 이항 연산 함수 호출
                }
            }
            
            // Double형 값에서 1로 나누어지면 Int형으로 전환
            if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 { // Double형에서 나머지연산시 truncatingRemainder 사용
                self.result = "\(Int(result))"
            }
            
            // 이전 결과값 저장
            self.firstOperand = self.result
            self.operationNumber = self.result
            self.displayNumber = self.result
            
            printNumberOutputLabel()

            self.currentOperation = operation  // 현재 연산자 저장
        } else {
            self.firstOperand = self.operationNumber  // 첫번째 피연산자 저장
            self.currentOperation = operation       // 선택한 연산자 저장
            //self.operationNumber = ""                 // 빈 문자열로 초기화
            self.displayNumber = ""
        }
    }
    
    /**
     이항 연산을 하는 함수입니다.
     */
    func binaryOperation() {
        
        self.secondOperand = self.operationNumber  // 두번째 피연산자 가져오기
        self.displayNumber = ""  // 디스플레이 초기화
        self.operationNumber = ""
        
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
        
        if self.operationNumber.isEmpty {
            self.firstOperand = self.result    // 누적 연산을 위해 이전 결과값을 가져옴
        } else {
            self.firstOperand = self.operationNumber
        }
        
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
     콤마를 추가해주는 함수입니다.
     */
    func numberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()   // NumberFormatter 객체 생성
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    /**
     계산기에 표시되는 숫자를  출력해주는 함수입니다.
     */
    func printNumberOutputLabel() {
        guard let commaNumber = Double(self.operationNumber) else { return }
        
        if commaNumber >= 1000 || commaNumber <= -1000 {   // 긍정(천의 자리가 넘어가면 -> numberFormatter 함수 호출)
            self.numberOutputLabel.text = numberFormatter(number: commaNumber)
        } else {  // 부정(그대로 출력)
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    func printDotNumberOuputLabel() {
        self.operationNumber = self.displayNumber.components(separatedBy: [","]).joined()
        guard let commaNumber = Double(self.displayNumber) else { return }
        
        if commaNumber >= 1000 || commaNumber <= -1000 {   // 긍정(천의 자리가 넘어가면 -> numberFormatter 함수 호출)
            self.displayNumber = numberFormatter(number: commaNumber)
        }
        self.displayNumber += self.operationNumber.isEmpty ? "0." : "."
        self.operationNumber = self.displayNumber
        self.numberOutputLabel.text = self.displayNumber
    }
    
    func stringToOperationNumber() {
        if self.displayNumber.contains(",") {
            self.operationNumber = self.displayNumber.components(separatedBy: [","]).joined()
        } else {
            self.operationNumber = self.displayNumber
        }
    }
}

