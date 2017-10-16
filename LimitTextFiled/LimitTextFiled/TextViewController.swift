//
//  TextViewController.swift
//  LimitTextFiled
//
//  Created by 郑强飞 on 2017/10/16.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textFiled: FFLimitTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.configViewWithLimit(limit: 5, true, true, false)
        textFiled.textFieldChangedBlock = { (textString) in
            print("textString==\(textString)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
