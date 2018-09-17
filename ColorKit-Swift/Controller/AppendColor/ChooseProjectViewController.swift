//
//  ChooseProjectViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/17.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData
class ChooseProjectViewController: BaseTableViewController {

    var projects:[Project]=[]
    var projectCallback:(Project)->Void = {_ in }
    
    init(_ callback:@escaping (Project)->Void) {
        projectCallback = callback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        tableView.registerNibOf(ColorTitleCell.self);
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissvc))
       
        fetchProject()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ColorTitleCell = tableView.dequeueReusableCell()

        cell.titleLabel.text = projects[indexPath.row].name
        cell.iconImageView.image = UIImage(named: projects[indexPath.row].badgeName ?? "badge_game")

        return cell
    }
    @objc
    private func dismissvc(){
        dismiss(animated: true, completion: nil)
    }
    private func fetchProject(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
      
        let sortPredictor = NSSortDescriptor(key: "createdAt", ascending: true)
        let fetchRequest = NSFetchRequest<Project>(entityName: "Project")
        fetchRequest.sortDescriptors = [sortPredictor]
        do {
            projects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        projectCallback(projects[indexPath.row])
        dismiss(animated: true, completion: nil)
        
    }

   

 
  
   

}
