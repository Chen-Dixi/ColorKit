//
//  FeaturedCollectionViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/27.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import IGListKit

class FeaturedCollectionViewController: BaseViewController {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.CommonViewBackgroundColor()
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    let colorLoader = FeaturedLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorLoader.delegate = self
        colorLoader.load()
        navigationItem.title = NSLocalizedString("Featured", comment: "")
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        collectionView.snp.remakeConstraints({ (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.snp.updateConstraints({ (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FeaturedCollectionViewController:ListAdapterDataSource{
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return colorLoader.entries
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return FeaturedSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension FeaturedCollectionViewController:FeaturedLoaderDelegate{
    func featuredLoaderDidUpdate(featuredLoader: FeaturedLoader){
        adapter.performUpdates(animated: true)
    }
}
