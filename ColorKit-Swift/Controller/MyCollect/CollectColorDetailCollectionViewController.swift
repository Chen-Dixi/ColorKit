//
//  CollectColorDetailCollectionViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/24.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData

class CollectColorDetailCollectionViewController: BaseCollectionViewController,UICollectionViewDelegateFlowLayout{

    public var colors:[Color] = []
    
    
    
    var managedContext:NSManagedObjectContext?
    
    var selectedIndex:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         //Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = collectionViewMinimumLineSpacing
        layout.minimumInteritemSpacing = collectionViewMinimumLineSpacing
        layout.itemSize =  CGSize(width: screenWidth-36, height: 100)
        layout.sectionInset = UIEdgeInsets(top: collectionViewMinimumLineSpacing, left: 0, bottom: 48, right: 0)
        collectionView?.collectionViewLayout = layout
        collectionView?.bounces = true
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.showsVerticalScrollIndicator = false
        
        
        collectionView?.registerNibOf(ColorCardCollectionCell.self)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
       
        //load data
        fetchColors()
        collectionView?.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func fetchColors(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "collect = true", argumentArray: nil)
        let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
        
        fetchRequest.predicate = predicate
        let sortPredictor = NSSortDescriptor(key: "collectDate", ascending: false)
        fetchRequest.sortDescriptors = [sortPredictor]
        
        do {
            colors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ColorCardCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        
        // Configure the cell
        cell.setColorInfo(color: colors[indexPath.item])
        cell.collectButton.isHidden = true
        cell.editable = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer{
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        selectedIndex = indexPath
        
        let sb = UIStoryboard(name: "ColorInfoViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ColorInfoViewController
        vc.tobackgroundColor = CommonUtil.getBackgroundColorFromColorData(color: colors[indexPath.item])
        vc.color = colors[indexPath.item]
        vc.colorInfoType = .view
        present(vc, animated: true, completion: nil)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: screenWidth-36, height: 100)
//    }
        
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewMinimumLineSpacing, left: 0, bottom: 48, right: 0)
    }
    
    
    
    @objc
    func refreshData(){
        fetchColors()
        collectionView?.reloadData()
    }
    

}
