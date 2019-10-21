import Foundation

class EnglishChequeConverter: Converter {
        
    fileprivate func getTheWord(_ i: Int) -> String {
        switch i {
        case 0: return ""
        case 1: return "thousand"
        case 2: return "million"
        case 3: return "billion"
        case 4: return "trillion"
        case 5: return "quadrillion"
        default: return ""
        }
    }
    
    fileprivate func get1DigitString (_ i: Int) -> String {
        switch i {
        case 1:
            return "one"
        case 2:
            return "two"
        case 3:
            return "three"
        case 4:
            return "four"
        case 5:
            return "five"
        case 6:
            return "six"
        case 7:
            return "seven"
        case 8:
            return "eight"
        case 9:
            return "nine"
        case 10:
            return "ten"
        case 80:
            return "eighty"
        case 60, 70, 90:
            return get1DigitString (i / 10) + "ty"
        case 20:
            return "twenty"
        case 30:
            return "thirty"
        case 40:
            return "forty"
        case 50:
            return "fifty"
        default:
            return "";
        }
    }
    
    fileprivate func get2DigitString (_ i: Int) -> String{
        if i % 10 == 0 || String(i).count == 1 {
            return get1DigitString(i)
        }
        
        let s = String(i)
        let tensDigit = s.getDigit(at: 0)
        let onesDigit = s.getDigit(at: 1)
        
        if tensDigit != 1 {
            return get1DigitString (tensDigit * 10) + "-" + get1DigitString (onesDigit)
        }
        
        switch i {
        case 11:
            return "eleven"
        case 12:
            return "twelve"
        case 13:
            return "thirteen"
        case 14:
            return "fourteen"
        case 15:
            return "fifteen"
        case 18:
            return "eighteen"
        case 16, 17, 19:
            return get1DigitString (onesDigit) + "teen";
        default:
            return "";
        }
    }
    
    fileprivate func get3DigitString (_ number: String) -> String {
        let last2Digits = String ((number as NSString).substring(from: 1))
        return get1DigitString(number.getDigit(at: 0)) + " hundred " + get2DigitString(Int(last2Digits)!)
    }
    
    fileprivate func get1To3DigitString (_ s: String) -> String{
        let i = Int(s)!
        let number = String(i)
        
        switch number.count {
        case 1:
            return get1DigitString(Int(number)!)
        case 2:
            return get2DigitString(Int(number)!)
        case 3:
            return get3DigitString(number)
        default:
            return ""
        }
    }
    
    func convertNumberString (_ x: String) -> String {
        var number = x
        let parsedNumber = NSDecimalNumber (string: number)
        if parsedNumber == NSDecimalNumber.notANumber {
            return NSLocalizedString("Please enter a valid amount", comment: "")
        }
        
        if parsedNumber.compare(NSDecimalNumber(string: "999999999999999999")) == ComparisonResult.orderedDescending ||
            parsedNumber.compare(NSDecimalNumber.one) == ComparisonResult.orderedAscending{
            return NSLocalizedString("The amount entered is either too large or too small. Please enter an amount less than 999,999,999,999,999,999 and larger than or equal to 1", comment: "")
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        number = formatter.string(from: parsedNumber)!
        
        let twoParts = number.components(separatedBy: ".")
        var integerPart = twoParts[0]
        var decimalPart = twoParts.count == 1 ? "" : twoParts[1]
        
        var integerString: String
        var decimalString: String
        
        if (0..<4).contains(integerPart.count) {
            integerString = get1To3DigitString(integerPart) + " "
        } else if integerPart == "" {
            integerString = ""
        } else {
            var commaTimes = integerPart.count / 3
            if integerPart.count % 3 == 0 {
                commaTimes -= 1
            }
            
            var groups = [String](repeating: "", count: commaTimes + 1)
            integerPart = String(integerPart.reversed())
            
            for i in 0  ..< groups.count  {
                if integerPart.count >= i * 3 + 3 {
                    groups[i] = integerPart.substring(start: i * 3, end: i * 3 + 3)
                } else {
                    groups[i] = integerPart.substring(start: i * 3)
                }
                groups[i] = String (groups[i].reversed())
                groups[i] = Int(groups[i]) == 0 ? "" : get1To3DigitString (groups[i]) + " " + getTheWord (i) + " "
            }
            groups = groups.reversed()
            
            integerString = ""
            for group in groups {
                integerString += group
            }
        }
        
        if decimalPart == "" || Int(decimalPart) == 0 || Int(decimalPart) == nil {
            decimalString = "and no cents only"
        } else {
            if decimalPart.count >= 2 {
                decimalPart = integerPart.substring(start: 0, end: 2)
            } else {
                decimalPart += "0"
            }
            
            decimalString = "and " + get2DigitString (Int(decimalPart)!) + (Int(decimalPart) == 1 ? " cent only" : " cents only")
        }
        
        return (integerString + (integerString == "one " ? "dollar " : "dollars ") + decimalString).toProper()
    }
}
