//
//  OwlCVDelegate.swift
//  OwlCollectionView
//
//  Created by t4nhpt on 9/20/16.
//  Copyright © 2016 T4nhpt. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class OwlRealmCVDelegate: NSObject {
    var dataSource: OwlRealmCVDataSource!
    var collectionView: UICollectionView!
    let realm = try! Realm()
    var token: NotificationToken!
    
    private var _fetchedResults: Results<Object>? =  nil
    var fetchedResults:Results<Object> {
        get {
            if let results = self._fetchedResults {
                return results
            } else {
                let result = realm.objects(self.dataSource.dataModelClass).filter(self.dataSource.predicate).sorted(byProperty: self.dataSource.sortBy, ascending: self.dataSource.sortAscending)
                
                token = result.addNotificationBlock({ (changes) in
                    switch changes {
                    case .initial:
                        // Results are now populated and can be accessed without blocking the UI
                        self.collectionView.reloadData()
                        break
                    case .update(_, let deletions, let insertions, let modifications):
                        
                        self.performChange(deletions: deletions, insertions: insertions, modifications: modifications)
                        break
                    case .error(let error):
                        // An error occurred while opening the Realm file on the background worker thread
                        fatalError("\(error)")
                        break
                    }
                })
                
                self._fetchedResults = result
                return result
            }
        }
    }
    
    func dataObject(at indexPath:IndexPath) -> Any {
        return self.fetchedResults[indexPath.row]
    }
    
    func performChange(deletions:[Int], insertions:[Int], modifications:[Int]) {
        collectionView.performBatchUpdates({ [unowned self] in
            
            self.collectionView.deleteItems(at: deletions.map({IndexPath(row:$0, section: 0)}))
            self.collectionView.insertItems(at: insertions.map({IndexPath(row:$0, section: 0)}))
            self.collectionView.reloadItems(at: modifications.map({IndexPath(row:$0, section: 0)}))
            
        }) { _ in
        }
    }
}

extension OwlRealmCVDelegate: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueCell(withIdentifier: "", cellClass: "", collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1, height: 1)
    }
    
    func dequeueCell(withIdentifier cellIdentifier:String,
                     cellClass cellClassName:String,
                     collectionView:UICollectionView,
                     indexPath:IndexPath) -> UICollectionViewCell {
        var cellId = cellIdentifier
        if cellId == "" {
            cellId = "cellIdentifier"
        }
        
        if (cellClassName == "") {//IF not in storyboard
            collectionView.register(UICollectionView.self, forCellWithReuseIdentifier: cellId)
        }
        
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for:indexPath)
        
        return item
    }
    
    
    private func numberOfItems(inSection section:Int) -> Int {
        return self.fetchedResults.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
}














