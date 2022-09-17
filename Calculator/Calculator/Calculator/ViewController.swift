import UIKit

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     ViewDidAppear에서 함수를 호출하는 이유
     :  메모리에 올라갈 때 다른 작업을 마친 후에 적용되어야 하기 때문
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
        
    }
    
    /**
     앱이 실행된 적이 있는지 체크하는 함수입니다.
     확인버튼 -> 계산기로 이동
     취소버튼 -> 앱 종료
     */
    func showAlert() {
        if !isAppAlreadyLaunchedOnce() == true {
            let alert = UIAlertController(title: "알림", message: "계산기 앱을 실행하겠습니까?", preferredStyle: .alert)
            // 긍정(확인 -> 계산기 실행)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                // 이동할 뷰 컨트롤러 객체를 참조
                guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
                // 인자값으로 뷰 컨트롤러 인스턴스를 넣고 프레젠트 메소드 호출
                self.present(nextView, animated: true)
                self.defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")  // 데이터 저장(false -> true)
            })
            // 부정(취소 -> 계산기 종료)
            alert.addAction(UIAlertAction(title: "취소", style: .default) {
                action in exit(0)
                
            })
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        } else {
            guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
            self.present(nextView, animated: true)
        }
    }
    
    /**
     최초로 실행된적이 있는지 체크하는 함수로 불린값을 반환합니다.
     */
    func isAppAlreadyLaunchedOnce() -> Bool {
        return defaults.bool(forKey: "isAppAlreadyLaunchedOnce")
    }
}
