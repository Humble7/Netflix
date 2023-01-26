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
    case movies(HomeViewModel)
    case emptyPage(String)
}

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .tabBar:
            let vc = MainTabBarViewController()
            return vc
        case .movies(_):
            return UIViewController()
        case .emptyPage(let title):
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBrown
            vc.title = title
            return vc
        }
    }
}
