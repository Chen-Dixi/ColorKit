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
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.rowHeight = 130
            tableView.tableFooterView = UIView()
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
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        
        do {
            projects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ColorTitleCell = tableView.dequeueReusableCell();
        cell.titleLabel.text = "Alto's adventure"
        
        return cell
    }
}

