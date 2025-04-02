//
//  BookSummaryStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/31/25.
//

import UIKit
import SnapKit


/// Summary의 상태를 나타내는 enum
enum SummaryState: Int, CaseIterable {
    case none
    case folded
    case expanded
    
    /// Summary의 상태에 따라 title을 반환함
    var buttonTitle: String {
        switch self {
        case .none:
            return ""
        case .folded:
            return "더 보기"
        case .expanded:
            return "접기"
        }
    }
}

final class BookSummaryStackView: UIStackView {
    
    // MARK: - Properties
    
    /// UserDefaults에서 Summary의 상태가 저장되어있는 Key값의 베이스
    private let summaryStateBaseKey = "summaryState"
    /// 현재 Book Index
    var selectedBookIndex = 0
    /// "summaryStateBaseKey" + selectedBookIndex = 현재 Book Index의 summaryState Key값
    private var currSummaryStateKey = ""
    
    /// 전체 Summary
    private var totalSummary = ""
    /// 현재 보이는 Summary
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
                // 요약 텍스트 전체 표시
                showingSummary = totalSummary
                changeSeeMoreButtonTitle(to: summaryState.buttonTitle)
                seeMoreHrizStack.isHidden = false
                
            } else if summaryState == .folded {
                // 요약 텍스트 일부(450자 + "...") 표시
                showingSummary = String(totalSummary.prefix(450) + "...")
                changeSeeMoreButtonTitle(to: summaryState.buttonTitle)
                seeMoreHrizStack.isHidden = false
                
            } else {
                // 450자 미만 => 요약 텍스트 전체 표시 및 더 보기 버튼 숨김
                showingSummary = totalSummary
                seeMoreHrizStack.isHidden = true
            }
            saveSummaryState()
        }
    }
    
    private let seeMoreHrizStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    /// seeMoreButton이 맨 오른쪽에 위치하도록 하는 Spacer
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
        
        if totalSummary.count >= 450 {
            loadSummaryState()
            if summaryState == .none {  // 초기 상태
                summaryState = .folded
            }
        } else {
            summaryState = .none
        }
    }
}

// MARK: - UI Methods

private extension BookSummaryStackView {
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
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTarget), for: .touchUpInside)
    }
    
    /// summaryState에 따라 보여지는 Summary 변경
    @objc func seeMoreButtonTarget() {
        if summaryState == .folded {
            // 접기 ➡️ 더 보기
            showingSummary = totalSummary
            summaryState = .expanded
        } else if summaryState == .expanded {
            // 더 보기 ➡️ 접기
            showingSummary = String(totalSummary.prefix(450) + "...")
            summaryState = .folded
        }
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

extension BookSummaryStackView {
    /// UserDefaults ➡️ summaryState 값 로드(rawValue)
    func loadSummaryState() {
        currSummaryStateKey = summaryStateBaseKey + String(selectedBookIndex)
        let value = UserDefaults.standard.integer(forKey: currSummaryStateKey)
        summaryState = SummaryState.allCases[value]
    }
    
    /// UserDefaults ⬅️ summaryState 값 저장(rawValue)
    func saveSummaryState() {
        UserDefaults.standard.set(summaryState.rawValue, forKey: currSummaryStateKey)
    }
}
