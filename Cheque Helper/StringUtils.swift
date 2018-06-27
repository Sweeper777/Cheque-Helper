import Foundation

extension String {
    func substring (start: Int, end: Int) -> String{
        let ns = NSString(string: self)
        return String(ns.substring(with: NSRange(start..<end)))
    }
    
    func substring (start: Int) -> String {
        let ns = NSString(string: self)
        return String(ns.substring(from: start))
    }
    
    mutating func setCharAt (index: Int, to c: Character) {
        let i = self.index(startIndex, offsetBy: index)
        insert(c, at: i)
        remove(at: self.index(i, offsetBy: 1))
    }
    
    func toProper () -> String {
        var strArr = self.components(separatedBy: " ")
        for i in 0  ..< strArr.count  {
            var s = strArr[i]
            
            if s == "" || s == "and" {
                continue
            }
            
            var firstChar = String (s.first!)
            firstChar = firstChar.uppercased()
            s.remove(at: s.startIndex)
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
    
    func getDigit(at index: Int) -> Int {
        let strArr = Array(self)
        let character = String(strArr[index])
        return Int(character)!
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
