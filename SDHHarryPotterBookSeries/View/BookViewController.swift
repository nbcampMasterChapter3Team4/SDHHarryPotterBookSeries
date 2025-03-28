//
//  BookViewController.swift
//  SDHHarryPotterBookSeries
//
//  Created by 서동환 on 3/24/25.
//

import UIKit
import Combine
import SnapKit

class BookViewController: UIViewController {
    
    // MARK: - Properties
    
    private var currBookIndex = 0
    private var viewModel: BookViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let bookTitlelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let seriesButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var titleAttr = AttributedString.init("1")
        titleAttr.font = .system(size: 16)
        config.attributedTitle = titleAttr
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.clipsToBounds = true
        
        return button
    }()
    
    // 책 정보 영역
    private let bookInfoView = BookInfoView()
    
    // Dedication & Summary 영역
    private let bookDedAndSumView = BookDedAndSumView()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewModel = BookViewModel(selectedBookIndex: currBookIndex)
        setupUI()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        seriesButton.layer.cornerRadius = seriesButton.frame.height / 2
    }
}

// MARK: - UI Methods

private extension BookViewController {
    func setupUI() {
        setViewHierarchy()
        setConstraints()
        bookInfoView.setupUI()
    }
    
    func setViewHierarchy() {
        self.view.addSubviews(bookTitlelabel, seriesButton, bookInfoView)
    }
    
    func setConstraints() {
        bookTitlelabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        seriesButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
            make.top.equalTo(bookTitlelabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        bookInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.top.equalTo(seriesButton.snp.bottom).offset(32)
            make.height.equalTo(150)
        }
    }
    
    func bind() {
        viewModel.selectedBookIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] newIndex in
                let bookSeries = newIndex + 1
                // Level 1
                self?.bookTitlelabel.text = self?.viewModel.title
                self?.seriesButton.titleLabel?.text = String(bookSeries)
                
                // Level 2
                self?.bookInfoView.bookImageView.image = self?.viewModel.image
                self?.bookInfoView.infoTitleLabel.text = self?.viewModel.title
                self?.bookInfoView.authorLabel.text = self?.viewModel.author
                let releaseDate = self?.viewModel.releaseDate.toDate()?.toString()
                self?.bookInfoView.releasedLabel.text = releaseDate
                self?.bookInfoView.pagesLabel.text = String(self?.viewModel.pages ?? 0)
                
                // Level 3
                
            }.store(in: &subscriptions)
    }
}
