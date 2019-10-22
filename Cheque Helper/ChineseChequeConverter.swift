import Foundation

class ChineseChequeConverter: Converter {
    fileprivate func convertNumber (_ i: Int) -> String {
        switch i {
        case 0:
            return "零"
        case 1:
            return "壹"
        case 2:
            return "貳"
        case 3:
            return "叁"
        case 4:
            return "肆"
        case 5:
            return "伍"
        case 6:
            return "陸"
        case 7:
            return "柒"
        case 8:
            return "捌"
        case 9:
            return "玖"
        default:
            return ""
        }
    }
    
    fileprivate func getThatWord (_ index: Int) -> String {
        switch index {
        case 0:
            return ""
        case 1:
            return "拾"
        case 2:
            return "佰"
        case 3:
            return "仟"
        case 4:
            return "萬"
        case 5:
            return "億"
        case 6:
            return "兆"
        default:
            return ""
        }
    }
    
    fileprivate func convertInteger (_ x: String) -> String! {
        var number = x
        if number.count < 5 {
            if number.count == 1 {
                return convertNumber(number.getDigit(at: 0))
            }
            
            let finalString = convertNumber(number.getDigit(at: 0)) + getThatWord(number.count - 1)
            number = number.substring(start: 1)
            
            if Int(number) == 0 {
                return finalString
            }
            
            var addZero = false
            for i in 0  ..< number.count  {
                if number[number.index(number.startIndex, offsetBy: i)] == "0" {
                    addZero = true
                    continue
                }
                return finalString + (addZero ? "零" : "") + convertInteger (number.substring(start: i))
            }
            return nil
        } else {
            var charsToRead = number.count % 4
            if charsToRead == 0 {
                charsToRead = 4
            }
            
            let firstPart = number.substring(start: 0, end: charsToRead)
            var secondPart = number.substring(start: charsToRead)
            
            var addZero = false
            for i in 0  ..< secondPart.count  {
                if i == secondPart.count - 1 && secondPart[secondPart.index(secondPart.startIndex, offsetBy: i)] == "0" {
                    addZero = false
                    continue
                }
                
                if secondPart[secondPart.index(secondPart.startIndex, offsetBy: i)] == "0" {
                    addZero = true
                    continue
                }
                secondPart = secondPart.substring(start: i)
                break
            }
            
            var thatWordIndex = 3 + number.count / 4
            if charsToRead == 4 {
                thatWordIndex -= 1
            }
            let thatWord = getThatWord(thatWordIndex)
            return convertInteger (firstPart) + thatWord + (addZero ? "零" : "") + (Int64(secondPart) == 0 ? "" : convertInteger (secondPart));
        }
    }
    
    func convertNumberString (_ x: String) -> String {
        var number = x
        let parsedNumber = NSDecimalNumber (string: number)
        if parsedNumber == NSDecimalNumber.notANumber {
            return NSLocalizedString("請輸入正確格式的幣值！", comment: "")
        }
        
        if parsedNumber.compare(NSDecimalNumber(string: "9999999999999999")) == ComparisonResult.orderedDescending ||
            parsedNumber.compare(NSDecimalNumber.one) == ComparisonResult.orderedAscending{
            return NSLocalizedString("你所輸入的幣值過大或過小。請輸入一個小於 9,999,999,999,999,999 並大於或等於 1 的幣值！", comment: "")
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        number = formatter.string(from: parsedNumber)!
        
        let twoParts = number.components(separatedBy: ".")
        let integerPart = twoParts[0]
        var decimalPart = twoParts.count == 1 ? "" : twoParts[1]
        //print("decimalPart: \(decimalPart)")
        
        let integerString: String = convertInteger(integerPart)
        var decimalString: String = ""
        
        if !(decimalPart == "" || Int(decimalPart) == 0) {
            if decimalPart.count < 2 {
                decimalPart += "0"
            }
            
            let jiao = String(decimalPart[decimalPart.startIndex])
            let fen = decimalPart.count == 1 ? "0" : String(decimalPart[decimalPart.index(decimalPart.startIndex, offsetBy: 1)])
            //print("jiao: \(jiao), fen: \(fen)")
            
            if jiao != "0" {
                decimalString += convertNumber(jiao.getDigit(at: 0)) + "角"
            }
            
            if fen != "0" {
                decimalString += convertNumber(fen.getDigit(at: 0)) + "分"
            }
        }
        
        return integerString + "圓" + decimalString + "正"
    }
}
