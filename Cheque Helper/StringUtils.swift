import Foundation

class StringUtils {
    static func split (s: String, at c: Character) -> [String] {
        let sequence = s.characters.split {$0 == c}
        var finalResult: [String] = []
        for item in sequence {
            finalResult.append(String(item))
        }
        return finalResult
    }
    
    static func substring (s: String, start: Int, end: Int) -> String{
        let ns = NSString(string: s)
        return String(ns.substringWithRange(NSRange(start..<end)))
    }
    
    static func substring (s: String, start: Int) -> String {
        let ns = NSString(string: s)
        return String(ns.substringFromIndex(start))
    }
    
    static func setCharAt (index: Int, of str: String, to c: Character) -> String{
        var charArr = Array (str.characters)
        charArr[index] = c
        var finalString = ""
        for i in 0...charArr.endIndex - 1 {
            finalString.append(charArr[i])
        }
        return finalString
    }
    
    static func toProper (str: String) -> String {
        var strArr = split(str, at: " ")
        for var i = 0 ; i < strArr.count ; i++ {
            var s = strArr[i]
            
            if s == "" || s == "and" {
                continue
            }
            
            var firstChar = String (s.characters.first!)
            firstChar = firstChar.uppercaseString
            s.removeAtIndex(s.startIndex)
            let newString = firstChar + s
            strArr[i] = newString
        }
        
        //join all the elements in the array
        var finalString = ""
        for ele in strArr {
            finalString += String (ele) + " "
        }
        return finalString
    }
    
    static func getDigitFrom (str: String, at index: Int) -> Int {
        let strArr = Array(str.characters)
        let character = String(strArr[index])
        return Int(character)!
    }

}