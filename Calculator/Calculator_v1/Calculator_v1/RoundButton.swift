//
//  RoundButton.swift
//  Calculator_v1
//
//  Created by 임가영 on 2022/09/06.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
