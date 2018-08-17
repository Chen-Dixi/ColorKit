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
            tableView.tableFooterView = UIView(frame: footerFrame1)
            tableView.showsVerticalScrollIndicator = false
            tableView.backgroundColor = UIColor.CommonViewBackgroundColor();
        }
    }
    
    @IBOutlet weak var bottomToolBar: UIToolbar!{
        didSet{
            bottomToolBar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.bottom)
        }
    }
    
    private var toolBarDisappearTimer:Timer?
    
    
    public var colors:[Color] = []
    var project:Project!
    
    
    var managedContext:NSManagedObjectContext?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "cardviewDelete"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name(rawValue: "cardviewChanged"), object: nil)
        // Do any additional setup after loading the view.
        tableView.registerNibOf(ColorDetailCell.self);
        tableView.backgroundColor = UIColor.TableViewBackgroundColor()
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        tableView.addGestureRecognizer(longPressGesture)
           // UIBarButtonItem(image: UIImage(named: "add"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.addColor) )
        //navigationItem.rightBarButtonItem = plusButton
        bottomToolBar.layer.shadowColor = UIColor.lightGray.cgColor;
        bottomToolBar.layer.shadowOffset = CGSize(width: 0, height: -6)
        bottomToolBar.layer.shadowOpacity = 0.1;
        toolBarDisappearTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(tooBarDisapear), userInfo: nil, repeats: false)
        fetchColors()
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "cardviewChanged"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "cardviewDelete"), object: nil)
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
    
    @objc
    func test(){
        tableView.reloadData()
    }
    
    
    @IBAction func jumpToSetting(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "ProjectSettingViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! BaseNavigationController
        if let settingVC = vc.topViewController as? ProjectSettingViewController{
            settingVC.project = project
        }
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: - toolBar disapear
    @objc
    func tooBarDisapear(){
        UIView.animate(withDuration: 0.4, animations: {
            self.bottomToolBar.alpha = 0
        }){ (finished) in
            self.bottomToolBar.isHidden = true
        }
    }
    
}

extension ColorDetailViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate{
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
//        let sb = UIStoryboard(name: "CreateColorViewController", bundle: nil)
//        let vc = sb.instantiateInitialViewController() as! CreateColorViewController
//        vc.color = colors[indexPath.row]
//        vc.pickerType = .edit
//
//        navigationController?.pushViewController(vc, animated: true)

        let sb = UIStoryboard(name: "ColorInfoViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ColorInfoViewController
        vc.tobackgroundColor = (tableView.cellForRow(at: indexPath) as! ColorDetailCell).backgroundColor
        
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ColorDetailCell = tableView.dequeueReusableCell();
        cell.setColorInfo(color: colors[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
//        if let managedContext = managedContext{
//            delete(indexPath: indexPath, context: managedContext)
//            tableView.reloadData()
//        }
        if editingStyle == .delete{
            let vc = DeleteColorAlertController {
                [weak self] in
                if let strongSelf = self{
                    if let managedContext = strongSelf.managedContext{
                        strongSelf.delete(indexPath: indexPath, context: managedContext)
                        strongSelf.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
            present(vc, animated: true, completion: nil)
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
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.bottomToolBar.isHidden{
            
            self.bottomToolBar.isHidden = false
            self.bottomToolBar.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations: {
                
                    self.bottomToolBar.alpha = 1
                
            }){
               (finished) in
                self.toolBarDisappearTimer?.invalidate()
                 self.toolBarDisappearTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.tooBarDisapear), userInfo: nil, repeats: false)
            }

        }
            //下滑 显示toolbar
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OpenColorCardTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CloseColorCardTransition()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return CloseColorCardInteractiveTransition()
    }
   
}
