//
//  UIView+Extension.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import UIKit

extension UIView {
    static func spacer(axis: NSLayoutConstraint.Axis) -> UIView {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: axis)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: axis)
        
        return spacer
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
