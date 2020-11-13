//
//  StoreViewController.swift
//  GeekProject_AR
//
//  Created by yanagimachi_riku on 2020/06/21.
//  Copyright © 2020 Riku Yanagimachi. All rights reserved.
//

import UIKit


class StoreViewController: UIViewController {
    
    let storeController = StoreController()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource
        <StoreController.AssetsPackCollection, StoreController.AssetsPack>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot
        <StoreController.AssetsPackCollection, StoreController.AssetsPack>! = nil
    static let titleElementKind = "title-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        configureHierarchy()
        configureDataSource()
        
        
        //横スクロール--------------------------------------------------------------------------------------
        // scrollViewの画面表示サイズを指定
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 88, width: self.view.frame.size.width, height: 200))
        // scrollViewのサイズを指定（幅は1メニューに表示するViewの幅×ページ数）
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: 200)
        // scrollViewのデリゲートになる
        self.scrollView.delegate = self
        // メニュー単位のスクロールを可能にする
        self.scrollView.isPagingEnabled = true
        // 水平方向のスクロールインジケータを非表示にする
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        // scrollView上にUIImageViewを配置
        self.setUpImageView()
        
        // pageControlの表示位置とサイズの設定
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: 258, width: self.view.frame.size.width, height: 30))
        // pageControlのページ数を設定
        self.pageControl.numberOfPages = 3
        // pageControlのドットの色
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        // pageControlの現在のページのドットの色
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(self.pageControl)
        

        //--------------------------------------------------------------------------------------
        
        self.view.addSubview(notYetInstalled())
        
        
    }
    
    func notYetInstalled()->UIView{
        let comingSoonView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        comingSoonView.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.9)
        let label = UILabel(frame: CGRect(x: 25, y: comingSoonView.bounds.height/2, width: comingSoonView.frame.size.width-50, height: 100))
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.0)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "近日実装予定"
        
        comingSoonView.addSubview(label)
        return comingSoonView
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        // タイマーを作成
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.scrollPage), userInfo: nil, repeats: true)
        
    }
    
    //横スクロール----------------------------------
    var photoList = [
        Photo(imageName: "pic08"),
        Photo(imageName: "pic09"),
        Photo(imageName: "pic10")
    ]
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    private var offsetX: CGFloat = 0
    private var timer: Timer!
    //-------------------------------------------
}

extension StoreViewController {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // if we have the space, adapt and go 2-up + peeking 3rd item
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                0.425 : 0.85)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                   heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: StoreViewController.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}


extension StoreViewController{
    struct Photo {
        var imageName: String
    }
    
    // タイマーを破棄
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let workingTimer = self.timer {
            workingTimer.invalidate()
        }
        
    }
    
    // UIImageViewを生成
    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, image: Photo) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        let image = UIImage(named:  image.imageName)
        imageView.image = image
        return imageView
    }
    
    // photoListの要素分UIImageViewをscrollViewに並べる
    func setUpImageView() {
        for i in 0 ..< self.photoList.count {
            let photoItem = self.photoList[i]
            let imageView = createImageView(x: 0, y: 0, width: self.view.frame.size.width, height: self.scrollView.frame.size.height, image: photoItem)
            imageView.frame = CGRect(origin: CGPoint(x: self.view.frame.size.width * CGFloat(i), y: 0), size: CGSize(width: self.view.frame.size.width, height: self.scrollView.frame.size.height))
            self.scrollView.addSubview(imageView)
        }
    }
    
    // offsetXの値を更新することページを移動
    @objc func scrollPage() {
        // 画面の幅分offsetXを移動
        self.offsetX += self.view.frame.size.width
        // 3ページ目まで移動したら1ページ目まで戻る
        if self.offsetX < self.view.frame.size.width * 3 {
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset.x = self.offsetX
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.offsetX = 0
                self.scrollView.contentOffset.x = self.offsetX
            }
        }
    }
}

extension StoreViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollViewのページ移動に合わせてpageControlの表示も移動
        self.pageControl.currentPage = Int(self.scrollView.contentOffset.x / self.scrollView.frame.size.width)
        // offsetXの値を更新
        self.offsetX = self.scrollView.contentOffset.x
    }
}



extension StoreViewController {
    func configureHierarchy() {
        let collectionViewFrame = CGRect (x: 0, y: 200, width: 0, height: 0)
        
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 288),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.register(
            StoreCollectionViewCell.self,
            forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self,
                                forSupplementaryViewOfKind: StoreViewController.titleElementKind,
                                withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
            <StoreController.AssetsPackCollection,
            StoreController.AssetsPack> (collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath,
                assetsPack: StoreController.AssetsPack) -> UICollectionViewCell? in
                
                // Get a cell of the desired kind.
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? StoreCollectionViewCell
                    else {
                        fatalError("Cannot create new cell")
                }
                // Populate the cell with our item description.
                cell.titleLabel.text = assetsPack.title
                cell.categoryLabel.text = assetsPack.category
                cell.imageView.image = UIImage(named: assetsPack.pic)
                
                // Return the cell.
                return cell
        }
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            
            // Get a supplementary view of the desired kind.
            if let titleSupplementary = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,for: indexPath) as? TitleSupplementaryView {
                
                // Populate the view with our section's description.
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                titleSupplementary.label.text = videoCategory.title
                
                // Return the view.
                return titleSupplementary
            } else {
                fatalError("Cannot create new supplementary")
            }
        }
        currentSnapshot = NSDiffableDataSourceSnapshot
        <StoreController.AssetsPackCollection, StoreController.AssetsPack>()
        storeController.collections2.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.packs)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}
