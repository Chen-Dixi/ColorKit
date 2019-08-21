//
//  HorizontalScrollSectionController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/10/30.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import IGListKit



class FeatureHorizontalScrollSectionController: ListSectionController {
    
    private var project:FeatureProject?
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        minimumLineSpacing = 18
        
    }
    
    override func numberOfItems() -> Int {
        return project?.colors.count ?? 0
    }
    
    override func didUpdate(to object: Any) {
        project = object as? FeatureProject
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = (collectionContext?.containerSize.height ?? 180) - collectionViewMinimumLineSpacing*2
        let width = height / screenRatio
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: "FeatureColorCardCollectionViewCell", bundle: nil, for: self, at: index) as! FeatureColorCardCollectionViewCell
        if let color = project?.colors[index]{
            cell.setColor(color)
        }
        return cell
    }
    
    
}
