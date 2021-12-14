//
//  Utils.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.
//

import Foundation
import UIKit
import PhoneNumberKit
class Utils{
    
    //-------------------------------------------------
    
    func isNumberMatched(number1: String, number2: String) -> Bool {
        return (number1 == number2)
    }
    
    //--------------------------------------------------
    
    func isNumberLocal(number: String) -> Bool {
        if(number.prefix(3) == "+92"){
            return true
        }
        else{
            return false
        }
    }
    
    //--------------------------------------------------
    
    func getHash () -> String {

        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map{ _ in letters.randomElement()! })
    }
    
    //--------------------------------------------------
    
    func fixPhoneNumber(phoneNumber: String) -> String{
        let cellNo = phoneNumber.filter {!$0.isWhitespace}
        let phoneNumberKit = PhoneNumberKit()
        var cell = String()
        do {
            let phone = try phoneNumberKit.parse(phoneNumber)
            cell = phone.numberString
            
        }
        catch {
            return "Phone Number Incorrect"
        }
        return cell
    }
    
    //--------------------------------------------------
    
    func getPhoneNumber() -> String{
        SharedPreferenceManager.getPreferenceInstance().read(valueKey: Appstatemanager.shared.CurrentPreferences.PHONE_NUMBER) ?? ""
    }
    
    //--------------------------------------------------
    
    func getDialingCode(phoneNumber: String) -> String {
        let phoneNumberKit = PhoneNumberKit()
        var code = String()
        do {
            let phone = try phoneNumberKit.parse(phoneNumber)
            code = phone.countryCode.description
            print(phone)
        }
        catch {
            print("Phone Number Incorrect")
            return "Phone Number Incorrect"
        }
        return ("+" + code)
    }
    
    //--------------------------------------------------
    
    func getOperatorCode(phoneNumber: String) -> String {
        return ""
    }
    
    //--------------------------------------------------
    
    func isNumberValidated(phoneNumber: String) -> Bool {
        let phoneNumberKit = PhoneNumberKit()
        do {
            let phone = try phoneNumberKit.parse(phoneNumber)
            print(phone)
        }
        catch {
            print("Phone Number Incorrect")
            return false
        }
        return true
    }
    
    //--------------------------------------------------
    
    func getApiServerUrl() -> String {
        return Constants().BASE_API_SERVER_WITH_PORT
    }
    
    //--------------------------------------------------
    
    func isOtpValidated(code: String) -> String {
        return (!code.isEmpty).description /// Currently need to be implemente
    }
}
extension String {
    func isValidPhoneNumber() -> Bool {
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"

        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
}
