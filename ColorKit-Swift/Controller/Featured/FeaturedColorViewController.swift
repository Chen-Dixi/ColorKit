//
//  FeaturedColorViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/16.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import UIKit

class FeaturedColorViewController: BaseTableViewController {

    private var features:[NSDictionary] = []
    private var colors = [[FeatureColor]]()
    var selectedIndex:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 120
        navigationItem.title = NSLocalizedString("Featured", comment: "")
        tableView.registerNibOf(FeaturedColorCell.self)
        fetchColor()
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    private func fetchColor(){
        let path = Bundle.main.path(forResource: "example_project", ofType: "plist")
        let exampleDict = NSDictionary(contentsOfFile: path!)
        
        features = exampleDict!["example"] as! [NSDictionary]
        for feature in features{
            var colorArrs = [FeatureColor]()
            let colorDicts = feature["colors"] as! [NSDictionary]
            for dict in colorDicts{
                let color = FeatureColor(name: dict["name"] as! String, r: dict["R"] as! CGFloat, g: dict["G"] as! CGFloat, b: dict["B"] as! CGFloat)
                color.projectName = feature["name"] as! String
                
                colorArrs.append(color)
            }
            colors.append(colorArrs)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return features.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colors[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FeaturedColorCell = tableView.dequeueReusableCell()
        cell.setColor(featureColor: colors[indexPath.section][indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            tableView.deselectRow(at: indexPath, animated: false)
        }
        //        let sb = UIStoryboard(name: "CreateColorViewController", bundle: nil)
        //        let vc = sb.instantiateInitialViewController() as! CreateColorViewController
        //        vc.color = colors[indexPath.row]
        //        vc.pickerType = .edit
        //
        //        navigationController?.pushViewController(vc, animated: true)
        
        selectedIndex = indexPath
        
        let vc = FeatureColorInfoViewController()
        vc.tobackgroundColor = (tableView.cellForRow(at: indexPath) as! FeaturedColorCell).backgroundColor
        vc.color = colors[indexPath.section][indexPath.row]
        present(vc, animated: true, completion: nil)
    }

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
