//
//  MyViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/8/6.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class MyViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView(frame: footerFrame1)
        tableView.backgroundColor = UIColor.CommonViewBackgroundColor();
        tableView.separatorStyle = .none
        navigationItem.title = "我的"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    private enum Section: Int {
        case General
        case Another
        
    }
    
    private enum GeneralRow: Int {
        case Collect
        case Guide
        
    }
    
    private enum AnotherRow: Int{
        case Review
        case Share
        case About
       
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            tableView.deselectRow(at: indexPath, animated: false)
        }
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section{
        case .General:
            
            guard let row = GeneralRow(rawValue: indexPath.row) else {
                return
            }
            
            switch row {
            case .Collect:
                //弹出收藏界面
                let vc = CollectColorContainerViewController()
                navigationController?.pushViewController(vc, animated: true)
            case .Guide:
                //跳转操作指导界面
                break
           
            }
        case .Another:
            guard let row = AnotherRow(rawValue: indexPath.row) else {
               return
            }
            
            switch row {
                
            case .Review:
                //弹出评论
                break
                
            case .Share:
                //分享app
                break
            case .About:
                //弹出关于界面
                break
            }
        }
    }

  

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
