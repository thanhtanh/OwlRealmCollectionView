//
//  ViewController.swift
//  OwlRealmCollectionView
//
//  Created by HDWebsoft on 10/5/16.
//  Copyright © 2016 t4nhpt. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var grid:UICollectionView!
    
    var del: OwlDel!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupGrid()
        self.setupData()
    }
    
    func setupGrid() {
        let dataSource = OwlRealmCVDataSource.datasourceConfig(withClass: Owl.self, predicate: NSPredicate.init(value: true), sortBy: "height", sortAscending: true)
        
        
        self.del = OwlDel.delegateForCV(grid: self.grid, withVC:self, datasource:dataSource)
        
        self.grid.reloadData()
    }
    
    func setupData() {
        try! realm.write {
            realm.delete(realm.objects(Owl.self))
        }
        
        Timer.scheduledTimer(timeInterval: 2.0,
                             target:self,
                             selector:#selector(createOwl),
                             userInfo:nil,
                             repeats:true)
    }
    
    func createOwl() {
        try! realm.write {
            let randNum = Int(arc4random_uniform(6) + 1)
            let predicate = NSPredicate(format:"height == %d", randNum)
            
            var isNewEntity = false
            
            var owl = Owl()
            let result = realm.objects(Owl.self).filter(predicate)
            if (result.count > 0) { // If object existed
                owl = result[0]
            } else { // else, create a new one
                isNewEntity = true
                realm.add(owl)
            }
            
            if randNum == 2 && !isNewEntity { // Test delete action
                realm.delete(owl)
            } else if randNum == 4 && !isNewEntity { // Test re-arrange item after change value
                owl.height = 1
            } else {
                let color = UIColor.generateRandomColorHexString()
                owl.height = randNum
                owl.name = color
                owl.color = color
            }
            
        }
    }
}

