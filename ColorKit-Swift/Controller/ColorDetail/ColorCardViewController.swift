//
//  ColorCardViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/28.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData

class ColorCardViewController: BaseViewController, VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {
    
    

    fileprivate var colors:[Color] = []
    var project:Project!
    
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    var selectedIndex:IndexPath!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reorderData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tableviewChanged), name: NSNotification.Name(rawValue: "tableviewChanged"), object: nil)
        
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        // Do any additional setup after loading the view.
        
        cardSwiper.register(nib: UINib(nibName: "ColorCardCell", bundle: nil), forCellWithReuseIdentifier: "ColorCardCell")
        
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateData"), object: nil)
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reorderData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "tableviewChanged"), object: nil)
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
        let predicate = NSPredicate(format: "project = %@", project)
        let fetchRequest = NSFetchRequest<Color>(entityName: "Color")
        
        fetchRequest.predicate = predicate
        let sortPredictor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortPredictor]
        
        do {
            colors = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    //MARK: - Vertical Swiper Delegate and DataSource
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ColorCardCell", for: index) as! ColorCardCell
        
        cardCell.setColorInfo(color:  colors[index])
        
        
        return cardCell
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        
        return colors.count
    }
    
    func didSelectItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        selectedIndex = IndexPath(item: index, section: 0)
        
        let sb = UIStoryboard(name: "ColorInfoViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ColorInfoViewController
        vc.tobackgroundColor = (cardSwiper.verticalCardSwiperView.cellForItem(at: IndexPath(item: index, section: 0)))?.backgroundColor
        vc.color = colors[index]
        present(vc, animated: true, completion: nil)
    }
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection){
        let vc = DeleteColorAlertController(block: {
                [weak self] in
                if let strongSelf = self{
                    strongSelf.delete(color: strongSelf.colors[index])
                    strongSelf.colors.remove(at: index)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cardviewDelete"), object: nil)
                }
            }, cancelBlock: {
                [weak self] in
                if let strongSelf = self{
                    strongSelf.refreshData()
                }
        })
        present(vc, animated: true, completion: nil)
        
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection) {
        
    }
    
    @objc
    func refreshData(){
        fetchColors()
        cardSwiper.fixReloadData()
    }
    
    @objc
    func tableviewChanged(){
        cardSwiper.fixReloadData()
    }
}
