//
//  HomeViewSectionCellModel.swift
//  Netflix Clone
//
//  Created by ChenZhen on 27/1/23.
//  Copyright © 2023 ChenZhen. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias MovieSection = SectionModel<String, Title>

protocol HomeViewSectionCellModelInput {
    var movieDetailAction: Action<Title, Void> { get }
}

protocol HomeViewSectionCellModelOutput {
    var movies: Observable<[MovieSection]> { get }
}

protocol HomeViewSectionCellModelType {
    var inputs: HomeViewSectionCellModelInput { get }
    var outputs: HomeViewSectionCellModelOutput { get }
}

final class HomeViewSectionCellModel: HomeViewSectionCellModelType, HomeViewSectionCellModelInput, HomeViewSectionCellModelOutput {

    
    // MARK: Inputs & Outputs
    var inputs: HomeViewSectionCellModelInput { return self }
    var outputs: HomeViewSectionCellModelOutput { return self }
    
    // MARK: Input
    lazy var movieDetailAction: Action<Title, Void> = {
        return Action<Title, Void> { [unowned self] title in
            let viewModel = MovieDetailViewModel(title: title)
            return self.sceneCoordinator.transition(to: Scene.movieDetail(viewModel), type: .push)
                .asObservable()
                .map { _ in }
        }
    }()
    
    // MARK: Output
    let movies: Observable<[MovieSection]>
    
    private let movieService: MovieServiceType
    private let sceneCoordinator: SceneCoordinatorType

    // MARK: Init
    init(movieService: MovieServiceType, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.movieService = movieService
        self.sceneCoordinator = sceneCoordinator
        movies = self.movieService.movies()
            .map { titles in
                return [MovieSection(model: "", items: titles)]
            }
    }
}
