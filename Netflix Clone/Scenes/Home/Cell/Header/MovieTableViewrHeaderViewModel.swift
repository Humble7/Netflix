//
//  MovieTableViewrHeaderViewModel.swift
//  Netflix Clone
//
//  Created by ChenZhen on 31/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import Foundation
import Action

protocol MovieTableViewrHeaderViewModelInput {
    var allMoviesAction: Action<[Title], Void> { get }
}

protocol MovieTableViewrHeaderViewModelOutput {
    
}

protocol MovieTableViewrHeaderViewModelType {
    var inputs: MovieTableViewrHeaderViewModelInput { get }
    var outputs: MovieTableViewrHeaderViewModelOutput { get }
}

final class MovieTableViewrHeaderViewModel: MovieTableViewrHeaderViewModelType, MovieTableViewrHeaderViewModelInput, MovieTableViewrHeaderViewModelOutput {
    // MARK: Inputs & Outputs
    var inputs: MovieTableViewrHeaderViewModelInput { return self }
    var outputs: MovieTableViewrHeaderViewModelOutput { return self }
    
    // MARK: Inputs
    lazy var allMoviesAction: Action<[Title], Void> =  {
        return Action<[Title], Void> { [unowned self] titles in
            let viewModel = MoviesOverviewViewModel(titles: titles)
            return self.sceneCoordinator.transition(to: Scene.moviesOverview(viewModel), type: .push).asObservable()
                .map { _ in }
        }
    }()
    
    private let sceneCoordinator: SceneCoordinatorType
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        
        
    }
}
