//
//  MovieDetailViewController.swift
//  Netflix Clone
//
//  Created by ChenZhen on 26/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController, BindableType {
    var viewModel: MovieDetailViewModel!

    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = viewModel.title.original_name ?? viewModel.title.original_title
    }

}
