//
//  BookSumVrtcStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/31/25.
//

import UIKit
import SnapKit

final class BookSumVrtcStackView: UIStackView {
    
    // MARK: - UI Components
    
    private let infoSumLabel: UILabel = {
        let label = UILabel()
        label.text = "Summary"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    let sumLabel: UILabel = {
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
        self.spacing = 8
        self.alignment = .leading
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI
    
    func configure(summary: String) {
        sumLabel.text = summary
    }
}

// MARK: - UI Methods

private extension BookSumVrtcStackView {
    func setupUI() {
        setViewHierarchy()
    }
    
    func setViewHierarchy() {
        self.addArrangedSubviews(infoSumLabel, sumLabel)
    }
}
