//
//  BookImageName.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import UIKit

/// Book 표지 사진의 이름을 나타내는 enum
enum BookImageName: String, CaseIterable {
    case harrypotter1
    case harrypotter2
    case harrypotter3
    case harrypotter4
    case harrypotter5
    case harrypotter6
    case harrypotter7
    
    /// Book 표지 사진의 이름을 가진 UIImage를 반환함
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
