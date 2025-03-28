//
//  BookImage.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import UIKit

enum BookImage: String, CaseIterable {
    case harrypotter1
    case harrypotter2
    case harrypotter3
    case harrypotter4
    case harrypotter5
    case harrypotter6
    case harrypotter7
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
    
    static subscript(index: Int) -> BookImage? {
        return allCases.indices.contains(index) ? allCases[index] : nil
    }
}
