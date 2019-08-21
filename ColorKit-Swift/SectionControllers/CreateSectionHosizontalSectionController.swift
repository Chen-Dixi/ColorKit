//
//  CreateSectionHosizontalSectionController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/11/1.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import IGListKit
protocol RemoveSectionControllerDelegate: class {
    func removeSectionControllerWantsRemoved(_ sectionController: CreateSectionHosizontalSectionController)
}

final class CreateSectionHosizontalSectionController: ListSectionController,RemoveCellDelegate {
    private var helper:AppendColorHelper?
    private var color:MyColor?
    weak var delegate: RemoveSectionControllerDelegate?
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 0)
        minimumLineSpacing = 18
        
    }
    
//    override func numberOfItems() -> Int {
//        return helper?.colors.count ?? 0
//    }

    
    override func didUpdate(to object: Any) {
        //helper = object as? AppendColorHelper
        color = object as? MyColor
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = (collectionContext?.containerSize.height ?? 180) - collectionViewMinimumLineSpacing
        let width = height / screenRatio
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(withNibName: "BatchCreateColorCollectionCell", bundle: nil, for: self, at: index) as! BatchCreateColorCollectionCell
        cell.delegate = self
        if let color = color{
            cell.setColor(color)
        }
        return cell
    }
    
    func removeCellDidTapButton(_ cell: BatchCreateColorCollectionCell) {
        delegate?.removeSectionControllerWantsRemoved(self)
    }
    
}
