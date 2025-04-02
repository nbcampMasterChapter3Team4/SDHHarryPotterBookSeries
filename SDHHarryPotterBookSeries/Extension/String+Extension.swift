//
//  String+Extension.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import Foundation

extension String {
    /// yyyy-mm-dd 형식의 String을 Date 타입으로 변환하는 Extension
    func toDate() -> Date? {
        let dateFormatter = DateFormatter.getDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
