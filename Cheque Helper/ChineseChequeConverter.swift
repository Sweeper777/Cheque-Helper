import Foundation

class ChineseChequeConverter {
    private func convertNumber (i: Int) -> String {
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
    
    private func getThatWord (index: Int) -> String {
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
    
    private func convertInteger (var number: String) -> String! {
        if number.characters.count < 5 {
            if number.characters.count == 1 {
                return convertNumber(StringUtils.getDigitFrom(number, at: 0))
            }
            
            let finalString = convertNumber(StringUtils.getDigitFrom(number, at: 0)) + getThatWord(number.characters.count - 1)
            number = StringUtils.substring(number, start: 1)
            
            if Int(number) == 0 {
                return finalString
            }
            
            var addZero = false
            for var i = 0 ; i < number.characters.count ; i++ {
                if number.characters[number.characters.startIndex.advancedBy(i)] == "0" {
                    addZero = true
                    continue
                }
                return finalString + (addZero ? "零" : "") + convertInteger (StringUtils.substring(number, start: i))
            }
            return nil
        } else {
            var charsToRead = number.characters.count % 4
            if charsToRead == 0 {
                charsToRead = 4
            }
            
            let firstPart = StringUtils.substring(number, start: 0, end: charsToRead)
            var secondPart = StringUtils.substring(number, start: charsToRead)
            
            var addZero = false
            for var i = 0 ; i < secondPart.characters.count ; i++ {
                if i == secondPart.characters.count - 1 && secondPart.characters[secondPart.characters.startIndex.advancedBy(i)] == "0" {
                    addZero = false
                    continue
                }
                
                if secondPart.characters[secondPart.characters.startIndex.advancedBy(i)] == "0" {
                    addZero = true
                    continue
                }
                secondPart = StringUtils.substring(secondPart, start: i)
                break
            }
            
            var thatWordIndex = 3 + number.characters.count / 4
            if charsToRead == 4 {
                thatWordIndex--
            }
            let thatWord = getThatWord(thatWordIndex)
            return convertInteger (firstPart) + thatWord + (addZero ? "零" : "") + (Int64(secondPart) == 0 ? "" : convertInteger (secondPart));
        }
    }
    
    func convertNumberString (var number: String) -> String {
        let parsedNumber = NSDecimalNumber (string: number)
        if parsedNumber == NSDecimalNumber.notANumber() {
            return "請輸入正確格式的幣值！"
        }
        
        if parsedNumber.compare(NSDecimalNumber(string: "9999999999999999")) == NSComparisonResult.OrderedDescending ||
            parsedNumber.compare(NSDecimalNumber.one()) == NSComparisonResult.OrderedAscending{
                return "你所輸入的幣值過大或過小。請輸入一個小於 9,999,999,999,999,999 並大於或等於 1 的幣值！"
        }
        
        number = parsedNumber.description
        
        let twoParts = StringUtils.split(number, at: ".")
        let integerPart = twoParts[0]
        var decimalPart = twoParts.count == 1 ? "" : twoParts[1]
        //print("decimalPart: \(decimalPart)")
        
        let integerString: String = convertInteger(integerPart)
        var decimalString: String = ""
        
        if !(decimalPart == "" || Int(decimalPart) == 0) {
            if decimalPart.characters.count < 2 {
                decimalPart += "0"
            }
            
            let jiao = String(decimalPart[decimalPart.startIndex])
            let fen = String(decimalPart[decimalPart.startIndex.advancedBy(1)])
            //print("jiao: \(jiao), fen: \(fen)")
            
            if jiao != "0" {
                decimalString += convertNumber(StringUtils.getDigitFrom(jiao, at: 0)) + "角"
            }
            
            if fen != "0" {
                decimalString += convertNumber(StringUtils.getDigitFrom(fen, at: 0)) + "分"
            }
        }
        
        return integerString + "圓" + decimalString + "正"
    }
}