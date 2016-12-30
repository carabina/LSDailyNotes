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
        ///开启倒计时
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "time", timeInteval: 60, countingDown: { (time) in
            print("还剩下"+"\(time)"+"秒")
        }) { (time) in
            print("结束了")
            //结束下面的倒计时
            LSTimeCountdown.shared.ls_cancelCountDwonTask(key: "aa")
        }
        
        ///开启另一个倒计时
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "aa", timeInteval: 120, countingDown: { (time) in
            print("还剩下"+"\(time)"+"秒")
        }) { (time) in
            print("结束了")
        }
        
        ///到指定日期倒计时
        let date = Date.init(timeInterval: 90112, since: Date())
        LSTimeCountdown.shared.ls_scheduledCountDownTime(key: "date", date: date, countingDown: { (date) in
            print("还剩下"+"\(date)")
        }) { (date) in
            print("还剩下"+"\(date)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

