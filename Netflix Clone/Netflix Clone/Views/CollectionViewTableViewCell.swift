//
//  TableViewCell.swift
//  Netflix Clone
//
//  Created by Alikhan Tangirbergen on 09.09.2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell : CollectionViewTableViewCell, viewmodel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate : CollectionViewTableViewCellDelegate?
    
    private var titles : [Title] = []
    
    private let collecitonView : UICollectionView = {
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
        contentView.addSubview(collecitonView)
        collecitonView.delegate = self
        collecitonView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collecitonView.frame = contentView.bounds
    }
    
    public func configure(with titles :[Title]) {
        self.titles = titles
        DispatchQueue.main.async {[weak self] in
            self?.collecitonView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath : IndexPath) {
        
        DataPersistanceManager.shared.downloadTitle(with: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print("Downloaded to database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.title else {return}
        
        APICaller.shared.getMovie(with: titleName + "trailer") {[weak self] result in
            switch result {
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {return}
                
                guard let strongSelf = self else {return}
                
                let viewmodel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewmodel: viewmodel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download",
                                              subtitle: nil,
                                              image: nil,
                                              identifier: nil,
                                              discoverabilityTitle: nil,
                                              state: .off) {  _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
}
