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
    
    private let seeMoreHrizStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    private let seeMoreHrizSpacer = UIView.spacer(axis: .horizontal)
    
    private let seeMoreButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleAttributes = AttributeContainer()
        titleAttributes.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        config.attributedTitle = AttributedString("더 보기", attributes: titleAttributes)
        let button = UIButton(configuration: config)
        
        return button
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
        setConstraints()
    }
    
    func setViewHierarchy() {
        self.addArrangedSubviews(
            infoSumLabel,
            sumLabel,
            seeMoreHrizStack
        )
        
        seeMoreHrizStack.addArrangedSubviews(seeMoreHrizSpacer, seeMoreButton)
    }
    
    func setConstraints() {
        seeMoreHrizStack.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        seeMoreButton.snp.makeConstraints {
            $0.height.equalTo(24)
        }
    }
}
