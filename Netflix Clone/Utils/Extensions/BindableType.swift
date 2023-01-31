//
//  BindableType.swift
//  Netflix Clone
//
//  Created by ChenZhen on 23/1/23.
//

import UIKit
import RxSwift

protocol BindableType: AnyObject {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension BindableType where Self: UIView {
    func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}
