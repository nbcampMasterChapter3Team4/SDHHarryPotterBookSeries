//
//  SeriesStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 4/2/25.
//

import UIKit
import SnapKit

final class SeriesStackView: UIStackView {
    
    // MARK: - Properties
    
    weak var sendIndexDelegate: SendIndexDelegate?
    
    private var bookCount = 0 {
        didSet {
            if bookCount > 0 {
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
            }
        }
    }
    
    // MARK: - UI Components
    
    /*
     예외 처리 2
     - 데이터 로드 실패 시 미동작 버튼 보임
     */
    /// Book 시리즈 버튼(Book 데이터 로드 실패시 보임)
    private let seriesButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        var titleAttributes = AttributeContainer()
        titleAttributes.font = UIFont.systemFont(ofSize: 16)
        config.attributedTitle = AttributedString("0", attributes: titleAttributes)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subviews = self.arrangedSubviews
        subviews.forEach { subview in
            subview.snp.makeConstraints { $0.width.height.equalTo(44) }
            subview.layer.cornerRadius = subview.frame.height / 2
        }
    }
    
    // MARK: - Update UI
    
    func configure(bookCount: Int) {
        self.bookCount = bookCount
    }
}

// MARK: - UI Methods

private extension SeriesStackView {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        self.addArrangedSubview(seriesButton)
    }
    
    func setConstraints() {
        seriesButton.snp.makeConstraints {
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
        
        button.tag = Int(title) ?? 0
        button.addTarget(self, action: #selector(seriesButtonTarget), for: .touchUpInside)
        
        return button
    }
    
    /// UIButton의 tag(=title) - 1을 보냄
    @objc func seriesButtonTarget(sender: UIButton) {
        sendIndexDelegate?.sendIndex(index: sender.tag - 1)
    }
}
