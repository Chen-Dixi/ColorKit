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
    var impactFeedbackGenerator:UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.light)
    var selectionFeedbackGenerator:UISelectionFeedbackGenerator? = UISelectionFeedbackGenerator()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.rowHeight = 90
            tableView.tableFooterView = UIView(frame: footerFrame1)
            tableView.backgroundColor = UIColor.CommonViewBackgroundColor();
            
        }
    }
    
    @IBAction func addProject(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "添加项目", message: "输入项目名称", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "项目名称"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
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
        impactFeedbackGenerator?.prepare()
        selectionFeedbackGenerator?.prepare()
        tableView.registerNibOf(ColorTitleCell.self);
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
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
        let sortPredictor = NSSortDescriptor(key: "seq", ascending: true)
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
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selectedIndexPath, animated: false)
            }
            tableView.allowsSelection = false;
            sourceIndexPath = indexPath
            guard let cell = tableView.cellForRow(at: indexPath) else{
                return
            }
            impactFeedbackGenerator?.impactOccurred()
            
            cell.isHighlighted = false
            snapshot = customSnapshotFromView(cell)
            let center = cell.center
            fingerOffSet = CGSize(width: center.x-position.x, height: center.y-position.y)
            if let snapshot = snapshot{
                snapshot.center = center
                tableView.addSubview(snapshot)

                UIView.animate(withDuration: 0.25) {
                    snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 5.0)
                    snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    cell.isHidden = true
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
            
            if let indexPath = indexPath , let sourceIndexPath = sourceIndexPath,let managedContext = managedContext{
                if indexPath != sourceIndexPath && !isScrollToEdge(){
                    projects.swapAt(indexPath.row, sourceIndexPath.row)
                    tableView.beginUpdates()
                    tableView.moveRow(at: sourceIndexPath, to: indexPath)
                    swapOrder(source: sourceIndexPath, with: indexPath, context: managedContext)
                    tableView.endUpdates()
                    self.selectionFeedbackGenerator?.selectionChanged()
                    self.sourceIndexPath = indexPath
                }
            }
            
            
            
        default:
            tableView.allowsSelection = true;
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
                    self.impactFeedbackGenerator?.impactOccurred()
                }
            }
        }
        
    }

    deinit {
        impactFeedbackGenerator = nil
        selectionFeedbackGenerator = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshProject"), object: nil)
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
        
        let image = inputView.snapshotImage()
        
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false;
        snapshot.layer.cornerRadius = 0.0;
        //snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;
        return snapshot
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
        project.seq = Int32(projects.count)
        do{
            try managedContext.save()
            projects.append(project)
            tableView.reloadData()
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
         (u.seq , v.seq) = (v.seq,u.seq)
        do{
           try managedContext.save()
        }  catch let error as NSError {
            print("Could not swap. \(error), \(error.userInfo)")
        }
    }
    
    @objc
    func refreshData(){
        fetchProject()
        tableView.reloadData()
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
        
        if editingStyle == .delete{
            let vc = DeleteProjectAlertController {
                [weak self] in
                if let strongSelf = self{
                    if let managedContext = strongSelf.managedContext{
                        strongSelf.delete(indexPath: indexPath, context: managedContext)
                        strongSelf.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                    }
                }
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        //let sb = UIStoryboard(name: "ColorCardViewController", bundle: nil)
        //let vc = sb.instantiateInitialViewController() as! ColorCardViewController
        let vc = ColorContainerViewController(project: projects[indexPath.row])
        
        //vc.project = projects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ColorTitleCell = tableView.dequeueReusableCell();
        cell.titleLabel.text = projects[indexPath.row].name
        cell.iconImageView.image = UIImage(named: projects[indexPath.row].badgeName ?? "badge_game")
        return cell
    }
    
    //MARK: - gesture delegate
    
}

