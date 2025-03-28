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
    
    private let bookInfoView = BookInfoView()
    
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
        view.addSubviews(bookTitlelabel, seriesButton, bookInfoView)
    }
    
    func setConstraints() {
        bookTitlelabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        seriesButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
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
        let bookIndex = currBookIndex + 1
        
        viewModel.selectedBookIndex
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.bookTitlelabel.text = self?.viewModel.title
                self?.seriesButton.titleLabel?.text = String(bookIndex)
                
                let bookImageName = "harrypotter" + String(bookIndex)
                self?.bookInfoView.bookImageView.image = UIImage(named: bookImageName)
                self?.bookInfoView.infoTitleLabel.text = self?.viewModel.title
                self?.bookInfoView.authorLabel.text = self?.viewModel.author
                let releaseDate = self?.viewModel.releaseDate.toDate()?.toString()
                self?.bookInfoView.releasedLabel.text = releaseDate
                self?.bookInfoView.pagesLabel.text = String(self?.viewModel.pages ?? 0)
            }.store(in: &subscriptions)
    }
}
