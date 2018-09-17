//
//  ColorDetailViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/13.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData

class CollectColorDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.separatorStyle = .none
            tableView.rowHeight = 120
            tableView.tableFooterView = UIView(frame: footerFrame1)
            tableView.showsVerticalScrollIndicator = false
            tableView.backgroundColor = UIColor.CommonViewBackgroundColor();
        }
    }
    
   
    
    public var colors:[Color] = []
    
    
    
    var managedContext:NSManagedObjectContext?
    
    var selectedIndex:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
        tableView.registerNibOf(ColorDetailCell.self);
        tableView.backgroundColor = UIColor.TableViewBackgroundColor()
        
        
           // UIBarButtonItem(image: UIImage(named: "add"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.addColor) )
        //navigationItem.rightBarButtonItem = plusButton
       
        fetchColors()
        tableView.reloadData()
    }
    
    deinit {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
    
    
    
    
    
    
    
    
    @objc
    func refreshData(){
        fetchColors()
        tableView.reloadData()
    }
    
    
    
    
}

extension CollectColorDetailViewController: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
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
        selectedIndex = indexPath
        
        let sb = UIStoryboard(name: "ColorInfoViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ColorInfoViewController
        vc.tobackgroundColor = (tableView.cellForRow(at: indexPath) as! ColorDetailCell).backgroundColor
        vc.color = colors[indexPath.row]
        vc.colorInfoType = .view
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ColorDetailCell = tableView.dequeueReusableCell();
        //cell.setBackgroundColor(color: colors[indexPath.row])
       
        cell.setColorInfo(color: colors[indexPath.row])
        cell.collectButton.isHidden = true
        return cell
    }
    
   
    
    
    
    
    
}
