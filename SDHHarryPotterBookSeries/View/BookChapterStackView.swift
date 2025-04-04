//
//  BookChapterStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 4/1/25.
//

import UIKit

/// Chapter 영역
final class BookChapterStackView: UIStackView {
    
    // MARK: - UI Components
        
    private let chapterTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chapters"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.tag = 100
        
        return label
    }()
        
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        // 타이틀(Chapters)과 첫번째 챕터 사이 간격 8
        self.spacing = 8
        self.alignment = .leading
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI
    
    func configure(chapters: [Chapter]) {
        // stackView에서 기존 arrangedSubView들 삭제(infoChapterLabel 제외)
        let oldSubviews = self.subviews
        self.arrangedSubviews.forEach {
            if $0.tag != 100 {
                self.removeArrangedSubview($0)
            }
        }
        
        // 뷰 보임 방지 및 메모리 해제
        oldSubviews.forEach {
            if $0.tag != 100 {
                $0.removeFromSuperview()
            }
        }
        
        // arrangedSubView로 챕터 추가
        chapters.forEach { chapter in
            let chapterLabel = makeChapterLabel(text: chapter.title)
            self.addArrangedSubview(chapterLabel)
        }
    }
}

// MARK: - UI Methods

private extension BookChapterStackView {
    func setupUI() {
        setViewHierarchy()
    }
    
    func setViewHierarchy() {
        self.addArrangedSubview(chapterTitleLabel)
    }
    
    func makeChapterLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = text
        
        return label
    }
}
