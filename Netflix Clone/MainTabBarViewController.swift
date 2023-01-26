//
//  MainTabBarViewController.swift
//  Netflix Clone
//  Created by ChenZhen on 21/1/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // home view controller
        let home = MovieViewController()
        let rootHomeVC = UINavigationController(rootViewController: home)
        let service = TrendingMovieService()
        
        let moviesViewModel = MovieViewModel(trendingMovieService: service, coordinator: SceneCoordinator.shared)
        home.bindViewModel(to: moviesViewModel)
        
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        rootHomeVC.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        
        rootHomeVC.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Top Search"
        vc4.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([rootHomeVC, vc2, vc3, vc4], animated: true)
    }
}

