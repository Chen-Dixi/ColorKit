//
//  ColorCardViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/7/28.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit
import CoreData

class CollectColorCardViewController: BaseViewController, VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {
    
    

    fileprivate var colors:[Color] = []
    
    
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    var selectedIndex:IndexPath!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        // Do any additional setup after loading the view.
        
        cardSwiper.register(nib: UINib(nibName: "ColorCardCell", bundle: nil), forCellWithReuseIdentifier: "ColorCardCell")
        fetchColors()
        cardSwiper.fixReloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
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

    //MARK: - Vertical Swiper Delegate and DataSource
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ColorCardCell", for: index) as! ColorCardCell
        
        cardCell.setColorInfo(color:  colors[index])
        cardCell.collectButton.isHidden = true
        
        return cardCell
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        
        return colors.count
    }
    
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: CellSwipeDirection){
        
    }
    
    func didSelectItem(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        selectedIndex = IndexPath(item: index, section: 0)
        
        let sb = UIStoryboard(name: "ColorInfoViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! ColorInfoViewController
        vc.tobackgroundColor = (cardSwiper.verticalCardSwiperView.cellForItem(at: IndexPath(item: index, section: 0)))?.backgroundColor
        vc.color = colors[index]
        vc.colorInfoType = .view
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func refreshData(){
        fetchColors()
        cardSwiper.reloadData()
    }
    
    
}
