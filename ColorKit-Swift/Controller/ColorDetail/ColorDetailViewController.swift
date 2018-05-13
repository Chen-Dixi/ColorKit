//
//  ColorDetailViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/5/13.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class ColorDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.separatorStyle = .none
            tableView.rowHeight = 120
            tableView.tableFooterView = UIView()
            tableView.backgroundColor = UIColor.TableViewBackgroundColor();
        }
    }
    
    fileprivate var colors:[UIColor] = [UIColor(red: 99.0/255.0, green: 164.0/255.0, blue: 192.0/255.0, alpha: 1), UIColor(red: 223.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)]
    fileprivate var titles = ["天空","太阳"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNibOf(ColorDetailCell.self);
        tableView.backgroundColor = UIColor.TableViewBackgroundColor()
        
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
        cell.setBackgroundColor(color: colors[indexPath.row])
        cell.titleLabel.text = titles[indexPath.row]
        return cell
    }
}
