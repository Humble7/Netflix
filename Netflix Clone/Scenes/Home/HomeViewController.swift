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

class HomeViewController: UIViewController, BindableType {
        
    var viewModel: HomeViewModel!
    
    var dataSource: RxTableViewSectionedReloadDataSource<HomeSectionModel>!
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeViewSectionCell.self, forCellReuseIdentifier: HomeViewSectionCell.identifier)
        table.register(MovieTableViewrHeaderView.self, forHeaderFooterViewReuseIdentifier: MovieTableViewrHeaderView.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        view.backgroundColor = .systemBackground
        
        configureNavbar()
        
    }
    
    private func configureTableView() {
        view.addSubview(homeFeedTable)
        homeFeedTable.tableHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        // TODO: Use self-sizing.
        homeFeedTable.rowHeight = 200
        homeFeedTable.sectionHeaderHeight = 40
        
        dataSource = RxTableViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: { dataSource, tableView, indexPath, items in
                let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewSectionCell.identifier, for: indexPath) as! HomeViewSectionCell
                cell.bindViewModel(to: items)
                return cell
            }, titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].model
            })
        
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
    
    func bindViewModel() {
        let outputs = viewModel.outputs
        // TODO: bind data source, create sections.
        outputs.sectionedItems
            .bind(to: homeFeedTable.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)
    }

}
