//
//  Date+Extension.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter.getDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
