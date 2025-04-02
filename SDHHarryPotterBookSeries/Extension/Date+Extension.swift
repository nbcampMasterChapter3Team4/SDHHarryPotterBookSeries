//
//  Date+Extension.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import Foundation

extension Date {
    /// Date 타입을 MMMM d, yyyy 형식의 String으로 변환하는 Extension
    func toString() -> String {
        let dateFormatter = DateFormatter.getDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
