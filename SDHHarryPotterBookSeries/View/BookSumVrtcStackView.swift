//
//  BookSumVrtcStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/31/25.
//

import UIKit
import SnapKit

enum SummaryState: Int, CaseIterable {
    case none
    case expanded
    case folded
    
    var buttonTitle: String {
        switch self {
        case .none:
            return ""
        case .expanded:
            return "접기"
        case .folded:
            return "더 보기"
        }
    }
}

final class BookSumVrtcStackView: UIStackView {
    
    // MARK: - Properties
    
    private var userDefaultsKey = "summaryState"
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
    
    private var summaryState: SummaryState = .none {
        didSet {
            if summaryState == .expanded {
                showingSummary = totalSummary
                changeSeeMoreButtonTitle(to: summaryState.buttonTitle)
                seeMoreHrizStack.isHidden = false
                
            } else if summaryState == .folded {
                showingSummary = String(totalSummary.prefix(450) + "...")
                changeSeeMoreButtonTitle(to: summaryState.buttonTitle)
                seeMoreHrizStack.isHidden = false
                
            } else {
                seeMoreHrizStack.isHidden = true
            }
            saveSeeMoreButtonState()
        }
    }
    
    private let seeMoreHrizStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    private let seeMoreHrizSpacer = UIView.spacer(axis: .horizontal)
    
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
            loadSeeMoreButtonState()
            if summaryState == .none {
                summaryState = .folded
            }
        }
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
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            
            if summaryState == .folded {
                // 접기 ➡️ 더 보기
                showingSummary = totalSummary
                summaryState = .expanded
            } else if summaryState == .expanded {
                // 더 보기 ➡️ 접기
                showingSummary = String(totalSummary.prefix(450) + "...")
                summaryState = .folded
            }
            saveSeeMoreButtonState()
        }
        seeMoreButton.addAction(action, for: .touchUpInside)
    }
    
    func changeSeeMoreButtonTitle(to title: String) {
        var config = seeMoreButton.configuration
        var titleAttributes = AttributeContainer()
        titleAttributes.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        config?.attributedTitle = AttributedString(title, attributes: titleAttributes)
        seeMoreButton.configuration = config
    }
}

// MARK: - Private Methods

extension BookSumVrtcStackView {
    func loadSeeMoreButtonState() {
        let value = UserDefaults.standard.integer(forKey: userDefaultsKey)
        summaryState = SummaryState.allCases[value]
    }
    
    func saveSeeMoreButtonState() {
        UserDefaults.standard.set(summaryState.rawValue, forKey: userDefaultsKey)
    }
}
