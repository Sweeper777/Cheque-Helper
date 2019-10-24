import UIKit
import GoogleMobileAds
import SCLAlertView
import SwiftyUtils
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField

class ViewController: UIViewController, GADInterstitialDelegate {
    @IBOutlet var tfAmount: SkyFloatingLabelTextField!
    @IBOutlet var languageChoice: UISegmentedControl!
    @IBOutlet var result: UITextView!
    var showRateMsgAlreadyCalled = false
    var interstitialAd: GADInterstitial!
    
    var englishFont: UIFont!
    
    let disposeBag = DisposeBag()
    
    var productRequest: SKProductsRequest!
    
    override func viewDidLoad() {
        
        if !UserDefaults.standard.bool(forKey: "adsRemoved") {
            interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID!]
            interstitialAd.load(request)
            interstitialAd.delegate = self
        } else {
            navigationItem.rightBarButtonItems?.removeAll()
        }
        
        if #available(iOS 9.0, *) {
            result.font = result.font?.withSize(UIFont.preferredFont(forTextStyle: .title2).pointSize)
        }
        
        englishFont = result.font
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.isTranslucent = false
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .done, target: tfAmount, action: #selector(UITextField.resignFirstResponder))
        ]
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barTintColor = UIColor(hex: "5abb5a")
        keyboardToolbar.tintColor = UIColor.white
        tfAmount.inputAccessoryView = keyboardToolbar
        
        tfAmount.becomeFirstResponder()
        
        tfAmount.title = NSLocalizedString("Amount", comment: "")
        
        tfAmount.rx.text.debounce(.milliseconds(700), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map(removeFormatting)
            .map(convertNumberString)
            .bind(to: result.rx.text).disposed(by: disposeBag)
        tfAmount.rx.text.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map(formatTextFieldText)
            .subscribe(onNext: {
                [weak self] formatted in
                self?.tfAmount.text = formatted
            }).disposed(by: disposeBag)
        
        languageChoice.rx.value.distinctUntilChanged().subscribe(onNext: {
            [weak self]
            value in
            guard let `self` = self else { return }
            self.result.text = self.convertNumberString(
                self.removeFormatting(self.tfAmount.text)
            )
            if value == 0 {
                self.result.font = self.englishFont
            } else {
                if #available(iOS 9.0, *) {
                    self.result.font = UIFont(name: "Helvetica", size: UIFont.preferredFont(forTextStyle: .title2).pointSize)
                }
            }
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
    }
    
    func formatTextFieldText(_ text: String?) -> String {
        guard let nonNilText = text else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if !nonNilText.hasSuffix(formatter.decimalSeparator) {
            let amount = NSDecimalNumber(string:
                nonNilText.replacingOccurrences(of: formatter.groupingSeparator, with: "")
                    .replacingOccurrences(of: formatter.decimalSeparator ?? ".", with: ".")
            )
            if !NSDecimalNumber.notANumber.isEqual(to: amount) {
                if let formatted = formatter.string(from: amount) {
                    return formatted
                }
            }
        }
        return nonNilText
    }
    
    func removeFormatting(_ text: String?) -> String {
        guard let nonNilText = text else { return "" }
        
        return nonNilText
            .replacingOccurrences(of: Locale.current.groupingSeparator ?? "", with: "")
            .replacingOccurrences(of: Locale.current.decimalSeparator ?? ".", with: ".")
    }
    
    func convertNumberString(_ x: String?) -> String {
        let converter: Converter
        if languageChoice.selectedSegmentIndex == 0 {
            converter = EnglishChequeConverter()
        } else {
            converter = ChineseChequeConverter()
        }
        if NSDecimalNumber(string: x) != NSDecimalNumber.notANumber {
            return converter.convertNumberString(x ?? "")
        } else {
            return converter.convertNumberString("")
        }
    }
    
    @objc func showRateMsg() {
        view.endEditing(true)
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton(NSLocalizedString("Rate!", comment: "")) {
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/pocket-cheque-helper/id1072718086?mt=8")!)
        }
        alert.addButton(NSLocalizedString("Send Feedback", comment: "")) {
            UIApplication.shared.openURL(URL(string: "mailto:sumulang.apps@gmail.com?subject=Cheque Helper Feedback".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)!)
        }
        alert.addButton(NSLocalizedString("Maybe Later", comment: ""), action: {})
        _ = alert.showCustom(NSLocalizedString("Enjoying Cheque Helper?", comment: ""), subTitle: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), color: UIColor(hex: "5abb5a"), circleIconImage: UIImage())
        self.showRateMsgAlreadyCalled = false
    }

    @IBAction func textChanged(_ sender: UITextField) {
        
        let randomNumber = arc4random_uniform(100)
        if randomNumber < 3 {
            if !showRateMsgAlreadyCalled {
                perform(#selector(showRateMsg), with: self, afterDelay: Double(arc4random_uniform(10)))
                showRateMsgAlreadyCalled = true
            }
        } else if randomNumber < 6 && !UserDefaults.standard.bool(forKey: "adsRemoved") {
            if interstitialAd.isReady {
                interstitialAd.present(fromRootViewController: self)
            }
        }
    }
    
    @IBAction func swipedDown(_ sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial!) {
        if !UserDefaults.standard.bool(forKey: "adsRemoved") {
            interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID!]
            interstitialAd.load(request)
            interstitialAd.delegate = self
        }
    }
    
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        if !UserDefaults.standard.bool(forKey: "adsRemoved") {
            interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID!]
            interstitialAd.load(request)
            interstitialAd.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
    }
}

