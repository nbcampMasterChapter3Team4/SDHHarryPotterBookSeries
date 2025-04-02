//
//  UIView+Extension.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import UIKit

extension UIView {
    /// UIStackView에서 Spacer 역할을 하는 Extension
    static func spacer(axis: NSLayoutConstraint.Axis) -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: axis)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: axis)
        
        return spacer
    }
    
    /// 한번에 여러 개의 subView를 추가할 수 있게 하는 Extension
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
