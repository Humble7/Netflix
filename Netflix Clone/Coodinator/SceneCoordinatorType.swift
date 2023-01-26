//
//  SceneCoordinatorType.swift
//  Netflix Clone
//
//  Created by ChenZhen on 24/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    /// transition to another scene
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop(animated: Bool) -> Completable {
        return pop(animated: true)
    }
}
