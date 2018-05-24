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
            tableView.backgroundColor = UIColor.TableViewBackgroundColor();
        }
    }
    
    fileprivate var colors:[Color] = []
    var project:Project!
    
    @IBAction func addRandomColor(_ sender: UIButton) {
        addColor()
    }
    
    
    fileprivate var titles = ["天空","太阳"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNibOf(ColorDetailCell.self);
        tableView.backgroundColor = UIColor.TableViewBackgroundColor()
        
           // UIBarButtonItem(image: UIImage(named: "add"), style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.addColor) )
        //navigationItem.rightBarButtonItem = plusButton
        
        tableView.reloadData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let predicate = NSPredicate(format: "project = %@", project)
        let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
        fetchRequest.predicate = predicate
        
        do {
            colors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
}

extension ColorDetailViewController: UITableViewDataSource, UITableViewDelegate{
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ColorDetailCell = tableView.dequeueReusableCell();
        //cell.setBackgroundColor(color: colors[indexPath.row])
       
        cell.setColorInfo(color: colors[indexPath.row])
        return cell
    }
}
