//
//  FFLimitTool.swift
//  BreezeLoanApp
//
//  Created by 郑强飞 on 2017/10/9.
//  Copyright © 2017年 郑强飞. All rights reserved.

import UIKit

class FFLimitTool: NSObject {
    
    //Mark: 限制字节数（count为中文字符数，isEmojiFiltered为是否过滤emoji表情）
    class func limitBytesNumber(str:String, count:Int,isEmojiFiltered:Bool) ->String {
        //        let characterCount = str.characters.count
        //        let bytesCount = str.lengthOfBytes(using: String.Encoding.utf8)
        //        BYLog("字符=\(str)    字符数=\(characterCount)   字节数=\(bytesCount)")
        
        var myStr = str
        let maxCount = count*2 //UTF8编码的时候一个中文占3个字节，一个英文占一个字节，一个emoji表情占6个字节
        if isEmojiFiltered { //不能输入表情
            let haveEmoji = self.checkStringContainsEmoji(str: str)
            if haveEmoji {
                print("有emoji表情可过滤")
                //过滤emoji表情
                var newStr = ""
                for character in str.characters {
                    let sigleStr = String.init(character)
                    let isEmoji = self.checkStringContainsEmoji(str: sigleStr)
                    if !isEmoji {
                        newStr+=sigleStr
                    }
                }
                myStr = newStr
                let bytesLength = newStr.lengthOfBytes(using: String.Encoding.utf8)
                if bytesLength > maxCount {
                    //当字节数超了预定值时做处理
                    myStr = self.cutString(str: newStr, maxCount: maxCount)
                }
            } else {
                print("没有emoji表情可过滤")
                let bytesLength = str.lengthOfBytes(using: String.Encoding.utf8)
                if bytesLength>maxCount {
                    //当字节数超了预定值时做处理
                    myStr=self.cutString(str: str, maxCount: maxCount)
                }
            }
        } else {
            print("不过滤emoji表情")
            let bytesLength = str.lengthOfBytes(using: String.Encoding.utf8)
            if bytesLength>maxCount {
                //当字节数超了预定值时做处理
                myStr=self.cutString(str: str, maxCount: maxCount)
            }
        }
        
        return myStr
    }
    
    //裁剪String（按字节数）
    private class func cutString(str:String,maxCount:Int) -> String {
        var bytesCount:Int = 0
        var newStr = ""
        for character in str.characters {
            let sigleStr = String.init(character)
            var count = sigleStr.lengthOfBytes(using: String.Encoding.utf8)
            if count == 3 {
                count = 2
            }
            bytesCount+=count
            if bytesCount>maxCount {
                break
            } else {
                newStr+=sigleStr
            }
        }
        return newStr
    }
    
    //Mark: 检测是否含有emoji表情
    class func checkStringContainsEmoji(str:String) -> Bool {
        var haveEmoji: Bool = false
        //Emoji表情的正则表达式
        let emojiRegularExpressions = "[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]"
        haveEmoji=FFLimitTool.match(pattern: emojiRegularExpressions, string: str)
        return haveEmoji
    }
    
    class func match(pattern:String,string:String) -> Bool {
        var isMatched:Bool = false
        var regex: NSRegularExpression?
        //初始化
        do {
            try regex = NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            print("抛出异常!")
        }
        
        //进行正则匹配
        if let matches = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count)) {
            if matches.count>0 {
                isMatched = true
            } else {
                isMatched = false
            }
        } else {
            isMatched = false
        }
        return isMatched
    }
}
