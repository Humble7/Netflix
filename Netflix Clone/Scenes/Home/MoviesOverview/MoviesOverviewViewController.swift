//
//  MoviesOverviewViewController.swift
//  Netflix Clone
//
//  Created by ChenZhen on 26/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import UIKit

class MoviesOverviewViewController: UIViewController , BindableType {
    var viewModel: MoviesOverviewViewModel!

    func bindViewModel() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        title = "Total (\(viewModel.titles.count))"
    }

}
