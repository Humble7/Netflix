//
//  TrendingMovieServiceType.swift
//  Netflix Clone
//
//  Created by ChenZhen on 23/1/23.
//

import Foundation
import RxSwift

protocol MovieServiceType {
    func movies() -> Observable<[Title]>
}
