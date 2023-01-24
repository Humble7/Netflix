//
//  SceneTransitionType.swift
//  Netflix Clone
//
//  Created by ChenZhen on 24/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import Foundation

enum SceneTransitionType {
    case root     // make view controller the root view controller
    case push     // push view controller to navigation stack
    case modal    // present view controller modally
}
