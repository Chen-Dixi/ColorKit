//
//  ColorCardCollectionViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/21.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData
import SnapKit
private let reuseIdentifier = "Cell"

class ColorCardCollectionViewController: BaseCollectionViewController,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,BaseSwipeLeftCollectionViewDelegate {

    var project:Project!
    fileprivate var colors:[Color] = []
    var selectedIndex:IndexPath! = IndexPath(item: 0, section: 0)
    private var editingIndexPath:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        
        
        
        collectionView?.bounces = true
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.showsVerticalScrollIndicator = false
        
        
        collectionView?.registerNibOf(ColorCardCollectionCell.self)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "cardviewDelete"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name(rawValue: "cardviewChanged"), object: nil)
        
        // Do any additional setup after loading the view.
        fetchColors()
        collectionView?.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "cardviewChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "cardviewDelete"), object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    private func fetchColors(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "project = %@", project)
        let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
        
        fetchRequest.predicate = predicate
        let sortPredictor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortPredictor]
        
        do {
            colors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ColorCardCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
    
        // Configure the cell
        cell.setColorInfo(color: colors[indexPath.item])
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth-36, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewMinimumLineSpacing, left: 0, bottom: 48, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt fromIndexPath: IndexPath!, willMoveTo toIndexPath: IndexPath!) {
        invokeSelectionFeedback()
        colors.swapAt(fromIndexPath.item, toIndexPath.row)
        let u = colors[fromIndexPath.item],v = colors[toIndexPath.row]
        (u.createdAt , v.createdAt) = (v.createdAt,u.createdAt)
        saveContext()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, didBeginDraggingItemAt indexPath: IndexPath!) {
        invokeImpactFeedbackMedium()
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, didEndDraggingItemAt indexPath: IndexPath!) {
        invokeImpactFeedbackMedium()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reorderData"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        //delete code
        let vc = DeleteColorAlertController {
            [weak self] in
            if let strongSelf = self{
                strongSelf.deleteColorData(color: strongSelf.colors[indexPath.item])
                strongSelf.colors.remove(at: indexPath.item)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reorderData"), object: nil)
                strongSelf.collectionView?.deleteItems(at: [indexPath])
            }
        }
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let sb = UIStoryboard(name: "ColorInfoViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ColorInfoViewController
        vc.tobackgroundColor = CommonUtil.getBackgroundColorFromColorData(color:  colors[indexPath.item])
        vc.color = colors[indexPath.item]
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willEditItemAt indexPath: IndexPath) {
        if let editingIndexPath = self.editingIndexPath{
            if let cell = collectionView.cellForItem(at: editingIndexPath) as? BaseSwipeLeftCollectionViewCell{
                cell.handleTap()
            }
        }
        self.editingIndexPath = indexPath
    }
    
    @objc
    func test(){
        collectionView?.reloadData()
    }
    
    @objc
    func refreshData(){
        fetchColors()
        collectionView?.reloadData()
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    
}
