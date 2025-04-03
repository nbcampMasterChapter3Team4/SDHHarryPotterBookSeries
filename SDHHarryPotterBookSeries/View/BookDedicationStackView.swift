//
//  BookDedicationStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import UIKit

/// Dedication 영역
final class BookDedicationStackView: UIStackView {
    
    // MARK: - UI Components
    
    private let dedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dedication"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    let dedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        // 타이틀(Dedication)과 헌정사(내용) 사이 간격 8
        self.spacing = 8
        self.alignment = .leading
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI
    
    func configure(dedication: String) {
        dedLabel.text = dedication
    }
}

// MARK: - UI Methods

private extension BookDedicationStackView {
    func setupUI() {
        setViewHierarchy()
    }
    
    func setViewHierarchy() {
        self.addArrangedSubviews(
            dedTitleLabel,
            dedLabel
        )
    }
}
