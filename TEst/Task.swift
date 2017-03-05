//
//  Task.swift
//  AsyncAwaitTest
//
//  Created by 劉柏賢 on 2017/3/6.
//  Copyright © 2017年 劉柏賢. All rights reserved.
//

import UIKit

struct Task<T> {
    
    private let group: DispatchGroup
    private let block: () -> T
    
    /// 以同步方式取值
    var result: T {
        
        var value: T?
        
        group.enter()
        async(.global()) {
            
            value = self.block()
            
            self.group.leave()
        }
        
        group.wait()
        
        return value!
    }
    
    init(group: DispatchGroup = DispatchGroup(), block: @escaping () -> T) {
        self.group = group
        self.block = block
    }
    
    func runAsync() {
        async(.global()) {
            _ = self.block()
        }
    }
}
