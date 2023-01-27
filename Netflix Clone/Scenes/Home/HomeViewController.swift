//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by ChenZhen on 21/1/23.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController, BindableType {
    var viewModel: HomeViewModel!
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.register(MovieTableViewrHeaderView.self, forHeaderFooterViewReuseIdentifier: MovieTableViewrHeaderView.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        homeFeedTable.tableHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
    }
    
    private func configureNavbar() {
        var image = #imageLiteral(resourceName: "netflixLogo")
        image = image.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTable.frame = view.bounds
    }
    
    private func isVisibleForSection(section: Int) -> Bool {
        let indexes = self.homeFeedTable.indexPathsForVisibleRows?.filter { $0.section ==  section}
        if let indexes = indexes, !indexes.isEmpty {
            return true
        }
        return false
    }
    
    func bindViewModel() {
        self.viewModel.trendingMovies
            .observeOn(MainScheduler.instance)
            .filter({ _ in
                self.isVisibleForSection(section: Sections.TrendingMovies.rawValue)
            })
            .subscribe(onNext: { _ in
                self.homeFeedTable.reloadSections([Sections.TrendingMovies.rawValue], animationStyle: .none)
        })
        .disposed(by: self.rx.disposeBag)
        
        self.viewModel.trendingTvs
            .observeOn(MainScheduler.instance)
            .filter({ _ in
                self.isVisibleForSection(section: Sections.TrendingTv.rawValue)
            })
            .subscribe { _ in
                self.homeFeedTable.reloadSections([Sections.TrendingTv.rawValue], animationStyle: .none)
            }
            .disposed(by: self.rx.disposeBag)
        
        self.viewModel.popular
            .observeOn(MainScheduler.instance)
            .filter({ _ in
                self.isVisibleForSection(section: Sections.Popular.rawValue)
            })
            .subscribe { _ in
                self.homeFeedTable.reloadSections([Sections.Popular.rawValue], animationStyle: .none)
            }
            .disposed(by: self.rx.disposeBag)
        
        self.viewModel.upcomingMovies
            .observeOn(MainScheduler.instance)
            .filter({ _ in
                self.isVisibleForSection(section: Sections.Upcoming.rawValue)
            })
            .subscribe { _ in
                self.homeFeedTable.reloadSections([Sections.Upcoming.rawValue], animationStyle: .none)
            }
            .disposed(by: self.rx.disposeBag)
        
        self.viewModel.upcomingMovies
            .observeOn(MainScheduler.instance)
            .filter({ _ in
                self.isVisibleForSection(section: Sections.TopRated.rawValue)
            })
            .subscribe { _ in
                self.homeFeedTable.reloadSections([Sections.TopRated.rawValue], animationStyle: .none)
            }
            .disposed(by: self.rx.disposeBag)
        
    }

}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCell(_ cell: CollectionViewTableViewCell, didSelectItemAt indexPath: IndexPath) {
        let input = viewModel.input
        
        guard let titles = titles(for: indexPath.section), indexPath.row < titles.count else {
            return
        }
        input.movieDetailAction.inputs.onNext(titles[indexPath.row])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        guard let titles = titles(for: indexPath.section) else {
            return UITableViewCell()
        }
        cell.configure(with: titles, section: indexPath.section)
        return cell
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MovieTableViewrHeaderView.identifier) as! MovieTableViewrHeaderView
        if section == 0 {
            headerView.configure(headerTitle: sectionTitles[section], action: viewModel.allMovieAction)
        } else {
            headerView.configure(headerTitle: sectionTitles[section], buttonTitle: "See All ", buttonImage: UIImage(systemName: "arrow.right.circle"), action: viewModel.allMovieAction, titles: titles(for: section))
        }
        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    private func titles(for section: Int) -> [Title]? {
        switch section {
        case Sections.TrendingMovies.rawValue:
            return self.viewModel.trendingMovies.value
        case Sections.TrendingTv.rawValue:
            return self.viewModel.trendingTvs.value
        case Sections.Popular.rawValue:
            return self.viewModel.popular.value
        case Sections.Upcoming.rawValue:
            return self.viewModel.upcomingMovies.value
        case Sections.TopRated.rawValue:
            return self.viewModel.topRated.value
        default:
            return nil
        }
    }

}
