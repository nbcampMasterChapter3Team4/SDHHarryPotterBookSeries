//
//  BookChapterView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 4/1/25.
//

import UIKit
import SnapKit

final class BookChapterView: UIView {
    
    // MARK: - UI Components
    
    private let vrtcChapterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let infoChapterLabel: UILabel = {
        let label = UILabel()
        label.text = "Chapters"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
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
    
    // MARK: - Update UI
    
    func configure(chapters: [Chapter]) {
        // stackView에서 기존 arrangedSubView들 삭제
        let subviews = vrtcChapterStackView.subviews
        vrtcChapterStackView.arrangedSubviews.forEach {
            vrtcChapterStackView.removeArrangedSubview($0)
        }
        // 뷰 보임 방지 및 메모리 해제
        subviews.forEach { $0.removeFromSuperview() }
        
        chapters.forEach { chapter in
            let chapterLabel = UILabel()
            chapterLabel.font = .systemFont(ofSize: 14)
            chapterLabel.textColor = .darkGray
            chapterLabel.numberOfLines = 0
            chapterLabel.text = chapter.title
            vrtcChapterStackView.addArrangedSubview(chapterLabel)
        }
    }
}

// MARK: - UI Methods

private extension BookChapterView {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        self.addSubviews(
            infoChapterLabel,
            vrtcChapterStackView
        )
    }
    
    func setConstraints() {
        infoChapterLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        vrtcChapterStackView.snp.makeConstraints {
            $0.top.equalTo(infoChapterLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
