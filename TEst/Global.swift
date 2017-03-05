//
//  Global.swift
//  AsyncAwaitTest
//
//  Created by 劉柏賢 on 2017/3/6.
//  Copyright © 2017年 劉柏賢. All rights reserved.
//

import UIKit

func await<T>(_ task: Task<T>, updateUI: ((_ result: T) -> Void)? = nil) -> T {
    
    let result = task.result
    
    async(.main) {
        updateUI?(result)
    }
    
    return result
}

func async(_ queue: DispatchQueue, block: @escaping () -> Void) {
    queue.async {
        block()
    }
}
