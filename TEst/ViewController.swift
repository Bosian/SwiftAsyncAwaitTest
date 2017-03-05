//
//  ViewController.swift
//  TEst
//
//  Created by 劉柏賢 on 2017/3/2.
//  Copyright © 2017年 劉柏賢. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func buttonHandler(_ sender: UIButton) {
        runAsync2()
    }
}

extension ViewController {
    
    /// Task 版 (runAsync)
    fileprivate func runAsync1() {
        
        activityIndicator.startAnimating()
        
        async(.global()) { [weak self] in
            
            let task = Task { () -> String in
                print("running")
                Thread.sleep(forTimeInterval: 2)
                return "data"
            }
            
            task.runAsync()
            
            print("finish!")
            
            async(.main, block: {
                self?.activityIndicator.stopAnimating()
            })
        }

    }
    
    /// Task 版 (await)
    fileprivate func runAsync2() {
        
        activityIndicator.startAnimating()
        
        async(.global()) { [weak self] in
            
            let task = Task { () -> String in
                print("running")
                Thread.sleep(forTimeInterval: 2)
                return "data"
            }
            
            let result1 = await(task) { (result) in
                print("update UI! 1")
            }
            
            print("result1 \(result1)")
            
            let task2 = Task { () -> String in
                print("running")
                Thread.sleep(forTimeInterval: 2)
                return "data"
            }
            
            let result2 = await(task2, updateUI: { (result) in
                print("update UI! 2")
            })
            
            print("result2 \(result2)")
            
            let task3 = Task { () -> String in
                print("running")
                Thread.sleep(forTimeInterval: 2)
                return "data"
            }
            
            let result3 = await(task3)
            print("result3 \(result3)")
            
            async(.main, block: {
                self?.activityIndicator.stopAnimating()
            })
            
            print("background async finish!")
        }
    }
    
    /// Task 版 (巢狀 await)
    fileprivate func runAsync4() {
        
        activityIndicator.startAnimating()
        
        async(.global()) { [weak self] in
            
            let task = Task { () -> String in
                
                print("running 1")
                
                let task = Task { () -> String in
                    
                    print("running 2")
                    Thread.sleep(forTimeInterval: 2)
                    
                    return "data"
                }
                
                return await(task)
            }
            
            print(await(task))
            
            print("finish!")
            
            async(.main, block: {
                self?.activityIndicator.stopAnimating()
            })
        }
    }
    
    /// Task 版 (await Task<Task<T>>)
    fileprivate func runAsync5() {
        
        activityIndicator.startAnimating()
        
        async(.global()) { [weak self] in
            
            let task = Task { () -> Task<String> in
                
                print("running 1")
                
                return Task { () -> String in
                    
                    print("running 2")
                    Thread.sleep(forTimeInterval: 2)
                    
                    return "data"
                }
            }
            
            let innserTask = await(task)
            print(await(innserTask))
            
            print("finish!")
            
            async(.main, block: {
                self?.activityIndicator.stopAnimating()
            })
        }
    }
    
    /// Task 版 (runAsync Task<Task<T>>)
    fileprivate func runAsync6() {
        
        activityIndicator.startAnimating()
        
        async(.global()) { [weak self] in
            
            let task = Task { () -> Task<String> in
                
                print("running 1")
                
                return Task { () -> String in
                    
                    print("running 2")
                    Thread.sleep(forTimeInterval: 2)
                    
                    return "data"
                }
            }
            
            task.runAsync()
            
            print("finish!")
            
            async(.main, block: {
                self?.activityIndicator.stopAnimating()
            })
        }
    }
    
    /// runAsync2 展開版 (不使用 async 及 await)
    fileprivate func runAsync0() {
        
        activityIndicator.startAnimating()
        
        DispatchQueue.global().async { [weak self] in
            
            var result: String = ""
            
            let group = DispatchGroup()
            
            group.enter()
            
            DispatchQueue.global().async(group: group, execute: DispatchWorkItem(block: {
                print("running")
                Thread.sleep(forTimeInterval: 2)
                
                result = "data"
                
                group.leave()
            }))
            
            group.wait()
            
            print(result)
            print("finish!")
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
