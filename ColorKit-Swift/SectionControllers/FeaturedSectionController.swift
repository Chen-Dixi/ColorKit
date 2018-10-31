//
//  FeaturedSectionController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/30.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import IGListKit

let feature_title_row_height:CGFloat = 48
let feature_horizontal_row_height:CGFloat = 200

class FeaturedSectionController: ListSectionController {
    
    private var project:FeatureProject?
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
    }
    
    private enum FeaturedRow: Int {
        case Title
        case Horizontal
    }
    
    override func didUpdate(to object: Any) {
        project = object as? FeatureProject
    }
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        let width = context.containerSize.width
        
        guard let featuredRow = FeaturedRow(rawValue: index) else{
            return .zero
        }
        
        switch featuredRow {
        case .Title:
            return CGSize(width: width, height: feature_title_row_height)
        case .Horizontal:
            return CGSize(width: width, height: feature_horizontal_row_height)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
//        let cellClass: AnyClass = index == 0 ? BaseSwipeLeftCollectionViewCell.self : EmbeddedCollectionViewCell.self
//        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
//        if let cell = cell as? EmbeddedCollectionViewCell{
//            adapter.collectionView = cell.collectionView
//        }
        
        if index==0{
            let cell = collectionContext?.dequeueReusableCell(withNibName: "FeatureTitleCollectionViewCell", bundle: nil, for: self, at: index) as! FeatureTitleCollectionViewCell
            cell.titleLabel.text = project?.name
            return cell
        }else{
            let cell = collectionContext!.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as! EmbeddedCollectionViewCell
            adapter.collectionView = cell.collectionView
            return cell
        }
        
        
    }
}

extension FeaturedSectionController:ListAdapterDataSource{
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if let project = project{
            return [project]
        }
        
        return []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return HorizontalScrollSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
