//
//  DateFormatter+Extension.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import Foundation

// DateFormatter 호출 비용 절감 코드
extension DateFormatter {
    static let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    static func getDateFormatter() -> DateFormatter {
        return dateFormatter
    }
}

