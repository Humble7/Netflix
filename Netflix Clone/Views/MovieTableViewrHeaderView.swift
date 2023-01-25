//
//  MovieTableViewrHeaderView.swift
//  Netflix Clone
//
//  Created by ChenZhen on 25/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import UIKit

class MovieTableViewrHeaderView: UITableViewHeaderFooterView {
    static let identifier = "MovieTableViewrHeaderView"

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        headerLabel.backgroundColor = .clear
        return headerLabel
    }()
    
    var showAllMoviesButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitleColor(.systemGray, for: .normal)
        button.backgroundColor = .clear
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    public func configure(headerTitle: String, buttonTitle: String? = nil, buttonImage: UIImage? = nil) {
        headerLabel.text = headerTitle
        showAllMoviesButton.isHidden = true
        
        if let buttonTitle = buttonTitle {
            showAllMoviesButton.setTitle(buttonTitle, for: .normal)
            showAllMoviesButton.isHidden = false
        }
        
        if let buttonImage = buttonImage {
            showAllMoviesButton.setImage(buttonImage.withRenderingMode(.alwaysOriginal), for: .normal)
            showAllMoviesButton.isHidden = false
        }
        
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = bounds
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        headerLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        showAllMoviesButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.frame = bounds
        addSubview(stackView)
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(showAllMoviesButton)
    }
}
