//
//  TrendingMovieServiceType.swift
//  Netflix Clone
//
//  Created by ChenZhen on 23/1/23.
//

import Foundation
import RxSwift

protocol TrendingMovieServiceType {
    func trendingMovies() -> Observable<[Title]>
    func trendingTvs() -> Observable<[Title]>
    func popular() -> Observable<[Title]>
    func upcomingMovies() -> Observable<[Title]>
    func topRated() -> Observable<[Title]>
}
