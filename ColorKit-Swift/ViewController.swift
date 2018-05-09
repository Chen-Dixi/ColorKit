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
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.rowHeight = 130
            tableView.tableFooterView = UIView()
            tableView.backgroundColor = UIColor.TableViewBackgroundColor();
            
        }
    }
    
    
    @IBOutlet weak var newColorButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerNibOf(ColorTitleCell.self);
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ColorTitleCell = tableView.dequeueReusableCell();
        cell.titleLabel.text = "Alto's adventure"
        
        return cell
    }
}

