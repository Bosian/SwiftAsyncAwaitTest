//
//  ViewController.swift
//  TEst
//
//  Created by 劉柏賢 on 2017/3/2.
//  Copyright © 2017年 劉柏賢. All rights reserved.
//

import UIKit

struct Task<T> {
    var result: T?
}

func async(queue: DispatchQueue, block: @escaping () -> Void) {
    queue.async {
        block()
    }
}

func await<T>(block: (_ group: DispatchGroup) -> T) -> T {
    
    let group = DispatchGroup()
    group.enter()
    
    let result = block(group)
    
    group.wait()
    
    return result
}

func downloadAsync(group: DispatchGroup) -> String {
    
    var result: String = ""
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        
        print("6, \(Thread.isMainThread)")
        
        result = "data"
        group.leave()
    }
    
    print("5, \(Thread.isMainThread)")
    
    group.wait()
    
    return result
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        asyncFunction()
    }
    
    func asyncFunction() {
        
        print("1, \(Thread.isMainThread)")
        
        async(queue: .main) {
            
            print("3, \(Thread.isMainThread)")

            let result = await { (group) -> String in
                print("4, \(Thread.isMainThread)")
                return downloadAsync(group: group)
            }
            
            print(result)
            
            print("7, \(Thread.isMainThread)")
        }
        
        print("2, \(Thread.isMainThread)")
    }
}

