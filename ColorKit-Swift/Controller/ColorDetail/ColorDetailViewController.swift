//
//  ColorDetailViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/13.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData

class ColorDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.separatorStyle = .none
            tableView.rowHeight = 120
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.backgroundColor = UIColor.CommonViewBackgroundColor();
        }
    }
    
    public var colors:[Color] = []
    var project:Project!
    
    
    var managedContext:NSManagedObjectContext?
    
    fileprivate var titles = ["天空","太阳"]
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        // Do any additional setup after loading the view.
        tableView.registerNibOf(ColorDetailCell.self);
        tableView.backgroundColor = UIColor.TableViewBackgroundColor()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        tableView.addGestureRecognizer(longPressGesture)
           // UIBarButtonItem(image: UIImage(named: "add"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.addColor) )
        //navigationItem.rightBarButtonItem = plusButton
        fetchColors()
        tableView.reloadData()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateData"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    
    @objc
    func addColor(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Color",
                                       in: managedContext)!
        let color = Color(entity: entity, insertInto: managedContext)
        
        let name = "test"
        
        let r :Int32 = Int32(arc4random() % 255)
        let g:Int32 = Int32(arc4random() % 255)
        let b:Int32 = Int32(arc4random() % 255)
        color.setValue(name, forKey: "name")
        color.setValue(r, forKey: "r")
        color.setValue(g, forKey: "g")
        color.setValue(b, forKey: "b")
        color.setValue(project, forKey: "project")
        color.seq = Int32(colors.count)
        do{
            try managedContext.save()
            colors.append(color)
            tableView.reloadData()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - CoreData fetch
    private func fetchColors(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        guard let managedContext = managedContext else{
            return
        }
        let predicate = NSPredicate(format: "project = %@", project)
        let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
        
        fetchRequest.predicate = predicate
        let sortPredictor = NSSortDescriptor(key: "seq", ascending: true)
        fetchRequest.sortDescriptors = [sortPredictor]
        
        do {
            colors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
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
                    colors.swapAt(indexPath.row, sourceIndexPath.row)
                    tableView.beginUpdates()
                    tableView.moveRow(at: sourceIndexPath, to: indexPath)
                    swapOrder(source: sourceIndexPath, with: indexPath, context: managedContext)
                    tableView.endUpdates()
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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reorderData"), object: nil)
                }
            }
        }
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
    
    private func swapOrder(source:IndexPath,with target:IndexPath, context managedContext:NSManagedObjectContext){
        let u = colors[source.row],v = colors[target.row]
        (u.seq , v.seq) = (v.seq,u.seq)
        do{
            try managedContext.save()
        }  catch let error as NSError {
            print("Could not swap. \(error), \(error.userInfo)")
        }
    }
    
    private func isScrollToEdge()->Bool{
        guard let snapshot = snapshot else {
            return false
        }
        
        if (snapshot.frame.minY < tableView.contentOffset.y && tableView.contentOffset.y > 0.0) || (snapshot.frame.maxY > tableView.contentOffset.y+tableView.frame.height && tableView.contentOffset.y+tableView.frame.height < tableView.contentSize.height){
            return true
        }
        
        return false
    }
    
    @objc
    func refreshData(){
        fetchColors()
        tableView.reloadData()
    }
}

extension ColorDetailViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            tableView.deselectRow(at: indexPath, animated: false)
        }
        let sb = UIStoryboard(name: "CreateColorViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! CreateColorViewController
        vc.color = colors[indexPath.row]
        vc.pickerType = .edit
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ColorDetailCell = tableView.dequeueReusableCell();
        //cell.setBackgroundColor(color: colors[indexPath.row])
       
        cell.setColorInfo(color: colors[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if let managedContext = managedContext{
            delete(indexPath: indexPath, context: managedContext)
            tableView.reloadData()
        }
    }
    
    private func delete(indexPath:IndexPath, context managedContext:NSManagedObjectContext){
        let color = colors[indexPath.row]
        
        do {
            managedContext.delete(color)
            
            try managedContext.save()
            colors.remove(at: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reorderData"), object: nil)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}
