//
//  TrendingMovieService.swift
//  Netflix Clone
//
//  Created by ChenZhen on 23/1/23.
//

import Foundation
import RxSwift
import RxCocoa

struct Constants {
    static let API_KEY = "82cbc2162c99044204fe231d2afb1e32"
    static let baseURL = "https://api.themoviedb.org"
}

protocol MovieObservable {
    func createObservable(with path: String) -> Observable<[Title]>
}

extension MovieObservable {
    func createObservable(with path: String) -> Observable<[Title]>  {
        let response = Observable.from(["\(Constants.baseURL)/3\(path)?api_key=\(Constants.API_KEY)&language=en-US&page=1"])
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map { urlString in
                return URL(string: urlString)!
            }
            .map { url -> URLRequest in
                return URLRequest(url: url)
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .share(replay: 1)
        
        let observable = response.filter { response, _ in
            return 200..<300 ~= response.statusCode
        }
        .compactMap { _, data -> [Title]? in
            let arr = try! JSONDecoder().decode(TrendingTitleResponse.self, from: data)
            return arr.results
        }
        
        return observable
    }
}

struct TrendingMovieService: MovieServiceType, MovieObservable {
    
    private let bag = DisposeBag()
    
    func movies() -> Observable<[Title]> {
        return trendingMovies()
    }
    
    func trendingMovies() -> Observable<[Title]> {
        return createObservable(with: "/trending/movie/day")
    }
    
}

struct TrendingTvService: MovieServiceType, MovieObservable {
    
    private let bag = DisposeBag()
    private let globalSchelduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    func movies() -> Observable<[Title]> {
        return trendingTvs()
    }
    
    private func trendingTvs() -> Observable<[Title]> {
        return createObservable(with: "/trending/tv/day")
    }
    
}

struct PopularMovieService: MovieServiceType, MovieObservable {
    
    private let bag = DisposeBag()
    private let globalSchelduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    func movies() -> Observable<[Title]> {
        return popular()
    }
    
    private func popular() -> Observable<[Title]> {
        return createObservable(with: "/movie/popular")
    }
    
}

struct UpcomingMovie: MovieServiceType, MovieObservable {
    
    private let bag = DisposeBag()
    private let globalSchelduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    func movies() -> Observable<[Title]> {
        return upcomingMovies()
    }
    
    private func upcomingMovies() -> Observable<[Title]> {
        return createObservable(with: "/movie/upcoming")
    }
    
}

struct TopRatedMovie: MovieServiceType, MovieObservable {
    
    private let bag = DisposeBag()
    private let globalSchelduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    func movies() -> Observable<[Title]> {
        return topRated()
    }
    
    private func topRated() -> Observable<[Title]> {
        return createObservable(with: "/movie/top_rated")
    }
    
}
