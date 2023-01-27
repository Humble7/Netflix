//
//  HomeViewModel.swift
//  Netflix Clone
//
//  Created by ChenZhen on 23/1/23.
//

import Foundation
import RxSwift
import RxDataSources
import Action
import RxCocoa

typealias TrendingMovieSection = SectionModel<String, Title>

protocol HomeViewModelInput {
    // TODO: loadMore
    // TODO: refresh
    
    var movieDetailAction: Action<Title, Void> { get }
    var allMovieAction: Action<[Title], Void> { get }
}
 
protocol HomeViewModelType {
    var input: HomeViewModelInput { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInput {
    var input: HomeViewModelInput { return self }
    lazy var movieDetailAction: Action<Title, Void> = {
        return Action<Title, Void> { [unowned self] title in
            let viewModel = MovieDetailViewModel(title: title)
            return self.sceneCoordinator.transition(to: Scene.movieDetail(viewModel), type: .push)
                .asObservable()
                .map { _ in }
        }
    }()
    
    lazy var allMovieAction: Action<[Title], Void> =  {
        return Action<[Title], Void> { [unowned self] titles in
            let viewModel = MoviesOverviewViewModel(titles: titles)
            return self.sceneCoordinator.transition(to: Scene.moviesOverview(viewModel), type: .push).asObservable()
                .map { _ in }
        }
    }()
    
    // MARK: - Output
    let trendingMovies = BehaviorRelay<[Title]?>(value: [])
    let trendingTvs = BehaviorRelay<[Title]?>(value: [])
    let popular = BehaviorRelay<[Title]?>(value: [])
    let upcomingMovies = BehaviorRelay<[Title]?>(value: [])
    let topRated = BehaviorRelay<[Title]?>(value: [])
    
    private let trendingMovieService: TrendingMovieServiceType
    private let sceneCoordinator: SceneCoordinatorType
    private let bag = DisposeBag()
    
    init(trendingMovieService: TrendingMovieServiceType, coordinator: SceneCoordinatorType) {
        self.trendingMovieService = trendingMovieService
        self.sceneCoordinator = coordinator
        bindOutput()
    }
    
    private func bindOutput() {
        self.trendingMovieService.trendingMovies()
            .bind(to: trendingMovies)
            .disposed(by: bag)
        
        self.trendingMovieService.trendingTvs()
            .bind(to: trendingTvs)
            .disposed(by: bag)
        
        self.trendingMovieService.popular()
            .bind(to: popular)
            .disposed(by: bag)
        
        self.trendingMovieService.upcomingMovies()
            .bind(to: upcomingMovies)
            .disposed(by: bag)
        
        self.trendingMovieService.topRated()
            .bind(to: topRated)
            .disposed(by: bag)
    }
        
}

