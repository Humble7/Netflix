//
//  Scene.swift
//  Netflix Clone
//
//  Created by ChenZhen on 24/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import UIKit

enum Scene {
    case tabBar
    case movieDetail(MovieDetailViewModel)
    case moviesOverview(MoviesOverviewViewModel)
    case emptyPage(String)  // just for test
}

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .tabBar:
            let vc = MainTabBarViewController()
            return vc
        case .movieDetail(let viewModel):
            let vc = MovieDetailViewController()
            vc.bindViewModel(to: viewModel)
            return vc
        case .moviesOverview(let viewModel):
            let vc = MoviesOverviewViewController()
            vc.bindViewModel(to: viewModel)
            return vc
        case .emptyPage(let title):
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBrown
            vc.title = title
            return vc
        }
    }
}
