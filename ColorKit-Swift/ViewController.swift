//
//  ViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/3.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData
class ViewController: BaseViewController {
    
    var projects:[Project]=[]
    var managedContext:NSManagedObjectContext?
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.rowHeight = 130
            tableView.tableFooterView = UIView(frame: footerFrame1)
            tableView.backgroundColor = UIColor.TableViewBackgroundColor();
            
        }
    }
    
    @IBAction func addProject(_ sender: UIBarButtonItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Project",
                                       in: managedContext)!
        let project = Project(entity: entity, insertInto: managedContext)
        
        
        do{
            try managedContext.save()
            projects.append(project)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    @IBOutlet weak var newColorButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerNibOf(ColorTitleCell.self);
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        
        tableView.addGestureRecognizer(longPressGesture)
        fetchProject()
        tableView.reloadData()
    }
    
    func fetchProject(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        guard let managedContext = managedContext else{
            return
        }
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        
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
    
    //MARK: - draggable tableView
    private var sourceIndexPath:IndexPath?
    private var snapshot:UIImageView?
    private var fingerOffSet:CGSize?
    @objc
    func longPress(_ longPress:UILongPressGestureRecognizer){
        let state = longPress.state
        let position = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: position)
        
        
        switch state {
        case .began:
            guard let indexPath = indexPath else{
                return
            }
            sourceIndexPath = indexPath
            let cell = tableView.cellForRow(at: indexPath)
            snapshot = customSnapshotFromView(cell!)
            let center = cell!.center
            fingerOffSet = CGSize(width: center.x-position.x, height: center.y-position.y)
            if let snapshot = snapshot{
                tableView.addSubview(snapshot)
                snapshot.center = center
                cell?.isHidden = true
                UIView.animate(withDuration: 0.25) {
                    snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 5.0)
                    snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
            }
            
        case .changed:
            guard let snapshot = snapshot else{
                return
            }
            guard let fingerOffset = fingerOffSet else{
                return
            }
            let newCenter = CGPoint(x: position.x+fingerOffset.width , y: position.y+fingerOffset.height )
            snapshot.center = newCenter
            
            if let indexPath = indexPath , let sourceIndexPath = sourceIndexPath{
                if indexPath != sourceIndexPath{
                    projects.swapAt(indexPath.row, sourceIndexPath.row)
                
                    tableView.moveRow(at: sourceIndexPath, to: indexPath)
                    self.sourceIndexPath = indexPath
                }
            }
            
            
            
        case .ended:
            if let sourceIndexPath = sourceIndexPath{
                guard let cell = tableView.cellForRow(at: sourceIndexPath)else{
                    return
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.snapshot?.center = cell.center
                    
                    self.snapshot?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) { (finished) in
                    cell.isHidden = false
                    self.sourceIndexPath = nil
                    self.snapshot?.removeFromSuperview()
                    self.snapshot = nil
                }
            }
            
        default:
            break
        }
        
    }
    
    /*
     * 现在不做cell移动到顶部后 tableView 自动滑动
     */
    private func isScrollToEdge()->Bool{
        guard let snapshot = snapshot else {
            return false
        }
        
        if (snapshot.frame.minY < tableView.contentOffset.y && tableView.contentOffset.y > 0.0) || (snapshot.frame.maxY > tableView.contentOffset.y+tableView.frame.height && tableView.contentOffset.y+tableView.frame.height < tableView.contentSize.height){
            return true
        }
        
        return false
    }
    
    
    private func customSnapshotFromView(_ inputView:UIView)-> UIImageView{
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size,false,0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false;
        snapshot.layer.cornerRadius = 0.0;
        //snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;
        return snapshot
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
}

extension ViewController:UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate{
    
    //MARK: - TableView delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if let managedContext = managedContext{
            delete(indexPath: indexPath, context: managedContext)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        let sb = UIStoryboard(name: "ColorDetailViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ColorDetailViewController
        vc.project = projects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        projects.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ColorTitleCell = tableView.dequeueReusableCell();
        cell.titleLabel.text = "Alto's adventure"
        
        return cell
    }
    
    //MARK: - gesture delegate
    
}

