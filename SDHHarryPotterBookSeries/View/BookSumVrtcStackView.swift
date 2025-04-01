//
//  BookSumVrtcStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/31/25.
//

import UIKit
import SnapKit

enum SummaryState: String {
    case expanded = "접기"
    case folded = "더 보기"
    case none = ""
}

final class BookSumVrtcStackView: UIStackView {
    
    // MARK: - Properties
    
    private var totalSummary = ""
    private var showingSummary = "" {
        didSet {
            sumLabel.text = showingSummary
        }
    }
    
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
    
    private var seeMoreButtonTitle: SummaryState = .none {
        didSet {
            if seeMoreButtonTitle != .none {
                var config = seeMoreButton.configuration
                var titleAttributes = AttributeContainer()
                titleAttributes.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                config?.attributedTitle = AttributedString(seeMoreButtonTitle.rawValue, attributes: titleAttributes)
                seeMoreButton.configuration = config
                
                seeMoreHrizStack.isHidden = false
            } else {
                seeMoreHrizStack.isHidden = true
            }
        }
    }
    
    private let seeMoreButton: UIButton = {
        var config = UIButton.Configuration.plain()
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
        totalSummary = summary
        
        if summary.count >= 450 {
            showingSummary = String(summary.prefix(450) + "...")
            seeMoreButtonTitle = .folded
        } else {
            showingSummary = summary
            seeMoreButtonTitle = .none
        }
        sumLabel.text = showingSummary
    }
}

// MARK: - UI Methods

private extension BookSumVrtcStackView {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
        setButtonAction()
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
    
    func setButtonAction() {
        let action = UIAction { [self] _ in
            
            if seeMoreButtonTitle == .folded {
                showingSummary = totalSummary
                seeMoreButtonTitle = .expanded
            } else if seeMoreButtonTitle == .expanded {
                showingSummary = String(totalSummary.prefix(450) + "...")
                seeMoreButtonTitle = .folded
            }
        }
        seeMoreButton.addAction(action, for: .touchUpInside)
    }
}
