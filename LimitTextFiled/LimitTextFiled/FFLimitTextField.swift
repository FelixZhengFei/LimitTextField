//
//  FFLimitTextField.swift
//  BreezeLoanApp
//
//  Created by 郑强飞 on 2017/10/9.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import UIKit

class FFLimitTextField: UITextField,UITextFieldDelegate {
    
    private var maxLimitCount:Int = 1000//最大输入
    private var includeChinese:Bool = false //是否含有汉字
    private var isEmojiFiltered:Bool = true //是否过滤表情
    private var limitDecimalTwo:Bool = false //限制输入小数点2位
    
    public var textFieldChangedBlock:((_ textString:String) -> Void)? // 输入玩回掉'block'
    
    //MARK: - initial Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
     limit :限制输入多少
     includeCh:能否输入中文
     emojiFiltered:过滤表情
     isLimitDecimalTwo：限制输入小数点2位
     */
    public func configViewWithLimit(limit:Int, _ includeCh:Bool = true,_ emojiFiltered:Bool = true,_ isLimitDecimalTwo:Bool = false) {
        self.delegate = self
        maxLimitCount = limit
        includeChinese = includeCh
        isEmojiFiltered = emojiFiltered
        limitDecimalTwo = isLimitDecimalTwo
        self.addTarget(self, action:#selector(textFieldChanged(textField:)), for: .editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if limitDecimalTwo {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let expression = "^([0-9]{0,20})((\\.)[0-9]{0,2})?$"
            let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            let numberOfMatches = regex.numberOfMatches(in: newString, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
            return numberOfMatches != 0
        }
        return true
    }
    
    @objc
    private func textFieldChanged(textField:UITextField) {
        if includeChinese {
            let selectedRang = textField.markedTextRange
            if selectedRang==nil || (selectedRang?.isEmpty)! {
                let srt = FFLimitTool.limitBytesNumber(str: textField.text!, count: maxLimitCount, isEmojiFiltered: isEmojiFiltered)
                textField.text = srt
            }
        } else {
            let toBeString = textField.text!
            var limitCount = toBeString.characters.count
            if limitCount > maxLimitCount {
                limitCount = maxLimitCount
            }
            let tempString:NSString = NSString(string:toBeString)
            let returnString = tempString.substring(to: limitCount) as String
            textField.text = returnString
        }
        
        if textFieldChangedBlock != nil {
            textFieldChangedBlock!(textField.text!)
        }
    }
}
