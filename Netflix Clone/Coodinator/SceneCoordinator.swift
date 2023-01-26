//
//  SceneCoordinator.swift
//  Netflix Clone
//
//  Created by ChenZhen on 24/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    
    static public var shared: SceneCoordinator!
    
    private var window: UIWindow
    private var currentViewController: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return actualViewController(for: navigationController.viewControllers.first!)
        } else if let tabBarController = viewController as? UITabBarController {
            guard let selectedViewController = tabBarController.selectedViewController else {
                return tabBarController
            }
            return actualViewController(for: selectedViewController)
        } else {
            return viewController
        }
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        switch type {
        case .root:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onCompleted()
        case .modal:
            fatalError("Not supported")
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigaitn controller.")
            }
            
            // one-off subscription to be nofified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
        }
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    
}
