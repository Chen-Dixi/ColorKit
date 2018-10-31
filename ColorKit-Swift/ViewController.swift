//
//  ViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/3.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData
class ViewController: BaseCollectionViewController,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,BaseSwipeLeftCollectionViewDelegate {
    
    var projects:[Project]=[]
    var managedContext:NSManagedObjectContext?
    
    private var editingIndexPath:IndexPath?
    
    
    
    @IBAction func addProject(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: NSLocalizedString("add project", comment: ""), message: NSLocalizedString("input project name", comment: ""), preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("project name", comment: "")
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: {
            action in
            
            let first = alertController.textFields!.first!
            if let name = first.text{
                if name != ""{
                    self.add(projectName: name)
                }
            }
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    @IBOutlet weak var newColorButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView?.bounces = true
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.registerNibOf(ColorTitleCollectionCell.self)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Favorites", comment: ""), style: .plain, target: self, action: #selector(jumpToFavorites))
        fetchProject()
        collectionView?.reloadData()
        if projects.count > 0 {
            let vc = ColorContainerViewController(project: projects[0])
            navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func fetchProject(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        guard let managedContext = managedContext else{
            return
        }
        let sortPredictor = NSSortDescriptor(key: "createdAt", ascending: true)
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.sortDescriptors = [sortPredictor]
        do {
            projects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
    }
    
    
    
    
    private func add(projectName name:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Project",
                                       in: managedContext)!
        let project = Project(entity: entity, insertInto: managedContext)
        project.name = name
        project.createdAt = Date()
        do{
            try managedContext.save()
            projects.append(project)
            collectionView?.reloadData()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    private func delete(indexPath:IndexPath, context managedContext:NSManagedObjectContext){
        let project = projects[indexPath.row]
        let predicate = NSPredicate(format: "project = %@", project)
        let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
        
        fetchRequest.predicate = predicate
        
        do {
            let colors = try managedContext.fetch(fetchRequest)
            for color in colors{
                managedContext.delete(color)
            }
            managedContext.delete(project)
            
            try managedContext.save()
            projects.remove(at: indexPath.row)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
   
    
    private func swapOrder(source:IndexPath,with target:IndexPath, context managedContext:NSManagedObjectContext){
        let u = projects[source.row],v = projects[target.row]
         (u.createdAt , v.createdAt) = (v.createdAt,u.createdAt)
        do{
           try managedContext.save()
        }  catch let error as NSError {
            print("Could not swap. \(error), \(error.userInfo)")
        }
    }
    
    @objc
    func refreshData(){
        fetchProject()
        collectionView?.reloadData()
    }
    
    @objc
    private func jumpToFavorites(){
        let vc = CollectColorContainerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    //MARK: - TableView delegate and datasource
   
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let vc = DeleteProjectAlertController {
                [weak self] in
                if let strongSelf = self{
                    if let managedContext = strongSelf.managedContext{
                        strongSelf.delete(indexPath: indexPath, context: managedContext)
                        strongSelf.collectionView?.deleteItems(at: [indexPath])
                    }
                }
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return projects.count
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell:ColorCardCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
//
//        // Configure the cell
//        cell.setColorInfo(color: colors[indexPath.item])
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth-36, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionViewMinimumLineSpacing, left: 0, bottom: 48, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView!, itemAt fromIndexPath: IndexPath!, willMoveTo toIndexPath: IndexPath!) {
        invokeSelectionFeedback()
        projects.swapAt(fromIndexPath.item, toIndexPath.row)
        let u = projects[fromIndexPath.item],v = projects[toIndexPath.row]
        (u.createdAt , v.createdAt) = (v.createdAt,u.createdAt)
        saveContext()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ColorContainerViewController(project: projects[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ColorTitleCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.titleLabel.text = projects[indexPath.item].name
        cell.badgeImageView.image = UIImage(named: projects[indexPath.item].badgeName ?? "badge_game")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, didBeginDraggingItemAt indexPath: IndexPath!) {
        invokeImpactFeedbackMedium()
    }
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, didEndDraggingItemAt indexPath: IndexPath!) {
        invokeImpactFeedbackMedium()
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        //delete code
        let vc = DeleteProjectAlertController {
            [weak self] in
            if let strongSelf = self{
                if let managedContext = strongSelf.managedContext{
                    strongSelf.delete(indexPath: indexPath, context: managedContext)
                    strongSelf.collectionView?.deleteItems(at: [indexPath])
                    
                }
            }
        }
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
}

