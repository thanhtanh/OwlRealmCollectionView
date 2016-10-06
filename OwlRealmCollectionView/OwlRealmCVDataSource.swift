//
//  OwlCVDataSource.swift
//  OwlCollectionView
//
//  Created by t4nhpt on 9/20/16.
//  Copyright © 2016 T4nhpt. All rights reserved.
//

import UIKit
import RealmSwift

class OwlRealmCVDataSource: NSObject {
    var dataModelClass: Object.Type!
    var predicate: NSPredicate!
    var sortBy:String = ""
    var sortAscending = false
    
    class func datasourceConfig(withClass dataModelClass: Object.Type,
                                          predicate:NSPredicate,
                                          sortBy:String,
                                          sortAscending:Bool) -> OwlRealmCVDataSource {
        let datasource = OwlRealmCVDataSource()
        datasource.dataModelClass = dataModelClass
        datasource.predicate = predicate
        datasource.sortBy = sortBy
        datasource.sortAscending = sortAscending
        
        return datasource
    }
}
