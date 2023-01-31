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

typealias HomeSectionModel = SectionModel<String, HomeViewSectionCellModelType>

protocol HomeViewModelInput {
    // TODO: loadMore
    // TODO: refresh
    
    var movieDetailAction: Action<Title, Void> { get }
    var allMovieAction: Action<[Title], Void> { get }
}

protocol HomeViewModelOutput {
    // TODO: loadMore
    // TODO: refresh
    var sectionedItems: Observable<[HomeSectionModel]> { get }
}
 
protocol HomeViewModelType {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
}

class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {
    var inputs: HomeViewModelInput { return self }
    var outputs: HomeViewModelOutput { return self }
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
    var sectionedItems: Observable<[HomeSectionModel]>
    
    private let sceneCoordinator: SceneCoordinatorType
    private let bag = DisposeBag()
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        // trending movies
        let trendingMovieViewModel = HomeViewSectionCellModel(movieService: TrendingMovieService())
        let trendingMovieSection = HomeSectionModel(model: "Trending Movies", items: [trendingMovieViewModel])
        
        // trending tvs
        let trendingTvViewModel = HomeViewSectionCellModel(movieService: TrendingTvService())
        let trendingTvSection = HomeSectionModel(model: "Trending Tv", items: [trendingTvViewModel])
        
        // popular movies
        let popularMovieViewModel = HomeViewSectionCellModel(movieService: PopularMovieService())
        let popularMovieSection = HomeSectionModel(model: "Popular", items: [popularMovieViewModel])
        
        // upcoming movies
        let upcomingMovieViewModel = HomeViewSectionCellModel(movieService: UpcomingMovie())
        let upcomingMovieSection = HomeSectionModel(model: "Upcoming Movies", items: [upcomingMovieViewModel])
        
        // upcoming movies
        let topRatedMovieViewModel = HomeViewSectionCellModel(movieService: TopRatedMovie())
        let topRatedMovieSection = HomeSectionModel(model: "Top Rated", items: [topRatedMovieViewModel])
        
        self.sectionedItems = Observable.of([trendingMovieSection, trendingTvSection, popularMovieSection, upcomingMovieSection, topRatedMovieSection])
    }
        
}

