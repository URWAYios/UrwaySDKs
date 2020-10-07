//
//  UMUtilities.swift
//  Urway
//
//  Copyright © 2020 URWAY. All rights reserved.
//

import Foundation
import UIKit

public struct ZDLUtility {
    public static func getBundle() -> Bundle? {
        var bundle: Bundle?
        if let urlString = Bundle.main.path(forResource:"Urway", ofType: "framework", inDirectory: "Frameworks"){
            bundle = (Bundle(url: URL(fileURLWithPath: urlString)))
        }
        return bundle
    }
}

func getController(_ storyBoardName: String, _ identifier: String) -> UIViewController {
    return UIStoryboard(name: storyBoardName, bundle: ZDLUtility.getBundle()).instantiateViewController(withIdentifier: identifier)
}

internal class Common: NSObject {


    internal struct Globle {
        
            
            static var terminalId = "iOSAndTerm" // termilan provided by URWAY
            static var password = "password" // password provided by URWAY
            static var merchantKey = "07dc98635e206f259d9d19a12a02750c8c3a996354bc959508e45449c1bcd02f" // provided by URWAY

            static var url = "https://payments-dev.urway-tech.com/URWAYPGService/transaction/jsonProcess/JSONrequest" // urway transaction url
        
      

    }
}


internal struct Validator {
    func checkMandatoryFields(for model: UWInitializer) -> paymentResult{
        
        if !isValidAmount(enteredAmount: model.amount)  {
            return .mandatory(.amount)
        }
        
        if !isValidEmail(enteredEmail: model.email) {
            return .mandatory(.email)
        }
        
        if !isValidcountry(enteredcountry: model.country) {
           return .mandatory(.country)
        }
        
        if !isValidcurrency(enteredcurrency: model.currency) {
           return .mandatory(.currency)

        }
        
        if (!(model.createTokenIsEnabled ?? true) && model.actionCode == "12") {
            return .mandatory(.action_code)
        }
        
        if ((model.createTokenIsEnabled ?? true) && model.actionCode != "12") {
            return .mandatory(.action_code)
        }
        
        if model.trackIdCode.isEmpty || Int(model.trackIdCode) == nil {
            return .mandatory(.trackId)
        }
        
        return .sucess
    }
    
    
    
    func checkActionCode(code: String , tokenEnabled: Bool) -> Bool{
        
       
        if (!tokenEnabled && code == "12" && (Int(code) ?? .zero) > 0 && (Int(code) ?? .zero) < 99){
            return false
        }
        return true
    }
    
    func isValidAmount(enteredAmount:String) -> Bool {
        let amountFormat = Float(enteredAmount)
        return amountFormat != nil
    }
    
    
    
    func isValidEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    
    
    func isValidcountry(enteredcountry:String) -> Bool {
        let countryFormat = "[A-Za-z]{2}"
        let countryPredicate = NSPredicate(format:"SELF MATCHES %@", countryFormat)
        return countryPredicate.evaluate(with: enteredcountry)
    }
    
    
    
    func isValidcurrency(enteredcurrency:String) -> Bool {
        let currencyFormat = "[A-Za-z]{3}"
        let currncyPredicate = NSPredicate(format:"SELF MATCHES %@", currencyFormat)
        return currncyPredicate.evaluate(with: enteredcurrency)
    }
    
    
    
    func isValidActioncode(enteredaction:String) -> Bool {
        let actionFormat = "[1-99]"
        let actionPredicate = NSPredicate(format:"SELF MATCHES %@", actionFormat)
        return actionPredicate.evaluate(with: enteredaction)
    }
    
    
    
    
    
    func isValidZipcode(enteredzipcode:String) -> Bool {
        let zipcodeFormat = "[0-9]{6}"
        let zipcodePredicate = NSPredicate(format:"SELF MATCHES %@", zipcodeFormat)
        return zipcodePredicate.evaluate(with: enteredzipcode)
    }
}
