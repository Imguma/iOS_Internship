import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         계산기 앱을 실행하기 전 알림창입니다.
         확인버튼 -> 계산기로 이동
         취소버튼 -> 앱 종료
         */
        let alert = UIAlertController(title: "알림", message: "계산기 앱을 실행하겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            // 이동할 뷰 컨트롤러 객체를 참조
            guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
            // 인자값으로 뷰 컨트롤러 인스턴스를 넣고 프레젠트 메소드 호출
            self.present(nextView, animated: true)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .default) { action in exit(0) })
        
        DispatchQueue.main.async {
            self.present(alert, animated: false)
        }
    }
}
