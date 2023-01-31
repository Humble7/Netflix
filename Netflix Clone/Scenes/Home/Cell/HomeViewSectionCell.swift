//
//  HomeViewSectionCell.swift
//  Netflix Clone
//
//  Created by ChenZhen on 22/1/23.
//

import UIKit
import RxSwift
import Action
import RxDataSources

class HomeViewSectionCell: UITableViewCell, BindableType {

    // MARK: ViewModel
    var viewModel: HomeViewSectionCellModelType! {
        didSet {
//            configureUI()
        }
    }

    // MARK: Private
    private var dataSource: RxCollectionViewSectionedReloadDataSource<MovieSection>!
    private var disposeBag = DisposeBag()
    
    // MARK: BindableType
    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs

        collectionView.rx.itemSelected
            .map { [unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! Title
            }
            .bind(to: inputs.movieDetailAction.inputs)
            .disposed(by: disposeBag)
        
        outputs.movies
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
    static let identifier = "HomeViewSectionCell"
        
    private var section: Int!
    private var titles: [Title] = [Title]()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title], section: Int) {
        self.section = section
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<MovieSection>(configureCell: { _, collectionView, indexPath, title in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let model = title.poster_path else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
