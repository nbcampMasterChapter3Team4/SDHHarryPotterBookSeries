//
//  DateFormatter+Extension.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import Foundation

extension DateFormatter {
    static let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    static func getDateFormatter() -> DateFormatter {
        return dateFormatter
    }
}

