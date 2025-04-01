//
//  BookInfoHrizStackView.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/28/25.
//

import UIKit
import SnapKit

final class BookInfoHrizStackView: UIStackView {
    
    // MARK: - UI Components
    
    private let bookInfoHrizSpacer = UIView.spacer(axis: .horizontal)
    
    let bookImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let textInfoVrtcStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }()
    
    let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        
        return label
    }()
    
    private let infoAuthorHrizStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let infoAuthorLabel: UILabel = {
        let label = UILabel()
        label.text = "Author"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        
        return label
    }()
    
    private let infoReleasedHrizStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let infoReleasedLabel: UILabel = {
        let label = UILabel()
        label.text = "Released"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    let releasedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private let infoPagesHrizStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let infoPagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Pages"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    let pagesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private let textInfoVrtcSpacer = UIView.spacer(axis: .vertical)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.spacing = 16
        self.distribution = .fillProportionally
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI
    
    func configure(
        image: UIImage?,
        title: String,
        author: String,
        releaseDate: String,
        pages: String
    ) {
        bookImageView.image = image
        infoTitleLabel.text = title
        authorLabel.text = author
        releasedLabel.text = releaseDate
        pagesLabel.text = pages
    }
}

// MARK: - UI Methods

private extension BookInfoHrizStackView {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
    }
    
    func setViewHierarchy() {
        self.addArrangedSubviews(bookInfoHrizSpacer, bookImageView, textInfoVrtcStackView)
        textInfoVrtcStackView.addArrangedSubviews(
            infoTitleLabel,
            infoAuthorHrizStackView,
            infoReleasedHrizStackView,
            infoPagesHrizStackView,
            textInfoVrtcSpacer
        )
        infoAuthorHrizStackView.addArrangedSubviews(infoAuthorLabel, authorLabel)
        infoReleasedHrizStackView.addArrangedSubviews(infoReleasedLabel, releasedLabel)
        infoPagesHrizStackView.addArrangedSubviews(infoPagesLabel, pagesLabel)
    }
    
    func setConstraints() {
        bookImageView.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.5)
        }
    }
}
