//
//  BookSummaryView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/31/25.
//

import UIKit
import SnapKit

final class BookSummaryView: UIView {
    
    // MARK: - UI Components
    
    private let sumVrtcStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        return stackView
    }()
    
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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Methods

extension BookSummaryView {
    private func setupUI() {
        setViewHierarchy()
        setConstraints()
    }
    
    private func setViewHierarchy() {
        self.addSubview(sumVrtcStackView)
        sumVrtcStackView.addArrangedSubviews(infoSumLabel, sumLabel)
    }
    
    private func setConstraints() {
        sumVrtcStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(summary: String) {
        sumLabel.text = summary
    }
}

