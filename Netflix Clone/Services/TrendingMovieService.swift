//
//  TrendingMovieService.swift
//  Netflix Clone
//
//  Created by ChenZhen on 23/1/23.
//

import Foundation
import RxSwift
import RxCocoa

struct TrendingMovieService: TrendingMovieServiceType {

    struct Constants {
        static let API_KEY = "82cbc2162c99044204fe231d2afb1e32"
        static let baseURL = "https://api.themoviedb.org"
    }
    
    private let bag = DisposeBag()
    private let globalSchelduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    func trendingMovies() -> Observable<[Title]> {
        return createObservable(with: "/trending/movie/day")
    }
    
    func trendingTvs() -> Observable<[Title]> {
        return createObservable(with: "/trending/tv/day")
    }
    
    func popular() -> Observable<[Title]> {
        return createObservable(with: "/movie/popular")
    }
    
    func upcomingMovies() -> Observable<[Title]> {
        return createObservable(with: "/movie/upcoming")
    }
    
    func topRated() -> Observable<[Title]> {
        return createObservable(with: "/movie/top_rated")
    }
    
    private func createObservable(with path: String) -> Observable<[Title]> {
        let response = Observable.from(["\(Constants.baseURL)/3\(path)?api_key=\(Constants.API_KEY)&language=en-US&page=1"])
            .subscribeOn(globalSchelduler)
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
