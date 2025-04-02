//
//  SeriesHrizStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 4/2/25.
//

import UIKit
import SnapKit

final class SeriesHrizStackView: UIStackView {
    
    // MARK: - Properties
    
    private var bookCount = 0 {
        didSet {
            // stackView에서 기존 arrangedSubView들 삭제
            let oldSubviews = self.subviews
            self.arrangedSubviews.forEach {
                self.removeArrangedSubview($0)
            }
            // 뷰 보임 방지 및 메모리 해제
            oldSubviews.forEach { $0.removeFromSuperview() }
            
            // arrangedSubView로 챕터 추가
            for index in 0..<bookCount {
                let seriesButton = makeSeriesButton(title: String(index + 1))
                self.addArrangedSubview(seriesButton)
            }
            
            let newSubviews = self.arrangedSubviews
            newSubviews.forEach { subview in
                subview.snp.makeConstraints {
                    $0.width.height.equalTo(44)
                }
                subview.layer.cornerRadius = subview.frame.height / 2
            }
        }
    }
    
    // MARK: - UI Components
    
    /// Book 시리즈 버튼
    private let seriesButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var titleAttributes = AttributeContainer()
        titleAttributes.font = UIFont.systemFont(ofSize: 16)
        config.attributedTitle = AttributedString("N/A", attributes: titleAttributes)
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
        
        return button
    }()
    
    /// Book 데이터 스크롤 뷰
    private let bookVrtcScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.spacing = 8
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI
    
    func configure(bookCount: Int) {
        self.bookCount = bookCount
    }
}

// MARK: - UI Methods

private extension SeriesHrizStackView {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        self.addArrangedSubview(seriesButton)
    }
    
    func setConstraints() {
        seriesButton.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.width.height.equalTo(44)
            $0.centerX.equalToSuperview()
        }
    }
    
    func makeSeriesButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        var titleAttributes = AttributeContainer()
        titleAttributes.font = UIFont.systemFont(ofSize: 16)
        config.attributedTitle = AttributedString(title, attributes: titleAttributes)
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
        
        return button
    }
}
