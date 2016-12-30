//
//  ViewController.swift
//  LSDailyNotes
//
//  Created by John_LS on 2016/12/30.
//  Copyright © 2016年 John_LS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "time", timeInteval: 60, countingDown: { (time) in
            print("还剩下"+"\(60-time)"+"秒")
        }) { (time) in
            print("结束了")
        }
        
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "aa", timeInteval: 120, countingDown: { (time) in
            print("还剩下"+"\(120-time)"+"秒")
        }) { (time) in
            print("结束了")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

