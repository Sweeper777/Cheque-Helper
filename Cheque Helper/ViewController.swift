import UIKit
import GoogleMobileAds
import DoneToolbarSwift
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
    
    override func viewDidLoad() {
        interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
        
        if #available(iOS 9.0, *) {
            result.font = result.font?.withSize(UIFont.preferredFont(forTextStyle: .title2).pointSize)
        }
        
        englishFont = result.font
        
        let toolbar = ToolbarWithDone(viewsWithToolbar: [tfAmount])
        toolbar.barTintColor = UIColor(hex: "5abb5a")
        toolbar.tintColor = UIColor.white
        
        tfAmount.inputAccessoryView = toolbar
        
        tfAmount.becomeFirstResponder()
        tfAmount.rx.text.throttle(0.7, scheduler: MainScheduler.instance)
            .distinctUntilChanged { $0 == $1 }
            .map(convertNumberString)
            .bind(to: result.rx.text).disposed(by: disposeBag)
        
        languageChoice.rx.value.distinctUntilChanged().subscribe(onNext: {
            value in
            self.result.text = self.convertNumberString(self.tfAmount.text)
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
    
    func convertNumberString(_ x: String?) -> String {
        let converter: Converter
        if languageChoice.selectedSegmentIndex == 0 {
            converter = EnglishChequeConverter()
        } else {
            converter = ChineseChequeConverter()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let x = formatter.number(from: x!) {
            return converter.convertNumberString(x.description)
        } else {
            return converter.convertNumberString("")
        }
    }
    
    func showRateMsg() {
        
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton(NSLocalizedString("Rate!", comment: "")) {
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/pocket-cheque-helper/id1072718086?mt=8")!)
        }
        alert.addButton(NSLocalizedString("Send Feedback", comment: "")) {
            UIApplication.shared.openURL(URL(string: "mailto:sumulang@gmail.com?subject=Cheque Helper Feedback".addingPercentEscapes(using: String.Encoding.utf8)!)!)
        }
        alert.addButton(NSLocalizedString("Maybe Later", comment: ""), action: {})
        _ = alert.showCustom(NSLocalizedString("Enjoying Cheque Helper?", comment: ""), subTitle: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), color: UIColor(hex: "5abb5a"), icon: UIImage())
        self.showRateMsgAlreadyCalled = false
    }

    @IBAction func textChanged(_ sender: UITextField) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let amount = Int(tfAmount.text?.replacingOccurrences(of: formatter.groupingSeparator, with: "") ?? "a") {
            if let formatted = formatter.string(from: NSNumber(value: amount)) {
                tfAmount.text = formatted
            }
        }
        
        let randomNumber = arc4random_uniform(100)
        if randomNumber < 3 {
            if !showRateMsgAlreadyCalled {
                perform(#selector(showRateMsg), with: self, afterDelay: Double(arc4random_uniform(10)))
                showRateMsgAlreadyCalled = true
            }
        } else if randomNumber < 6 {
            if interstitialAd.isReady {
                interstitialAd.present(fromRootViewController: self)
            }
        }
    }
    
    @IBAction func swipedDown(_ sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial!) {
        interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
    }
    
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
    }
}

