//
//  TrendingMovieViewModel.swift
//  Netflix Clone
//
//  Created by mozat on 23/1/23.
//

import Foundation
import RxSwift
import RxDataSources
import Action
import RxCocoa

typealias TrendingMovieSection = SectionModel<String, Title>

struct TrendingMovieViewModel {
    
    // MARK: - Output
    let trendingMovies = BehaviorRelay<[Title]?>(value: [])
    let trendingTvs = BehaviorRelay<[Title]?>(value: [])
    let popular = BehaviorRelay<[Title]?>(value: [])
    let upcomingMovies = BehaviorRelay<[Title]?>(value: [])
    let topRated = BehaviorRelay<[Title]?>(value: [])

    private let trendingMovieService: TrendingMovieServiceType
    private let bag = DisposeBag()
    
    init(trendingMovieService: TrendingMovieServiceType) {
        self.trendingMovieService = trendingMovieService
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

