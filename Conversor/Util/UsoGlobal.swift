//
//  UsoGlobal.swift
//  Conversor
//
//  Created by Chardson Miranda on 06/10/21.
//

import Foundation
import UIKit

func getPlistDadosOffLine () -> NSDictionary?{
    let fileManager = FileManager.default
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let path = documentDirectory.appending("/dadosOffLine.plist")

    if (fileManager.fileExists(atPath: path)) {

        var nsDictionary: NSMutableDictionary?
        nsDictionary = NSMutableDictionary(contentsOfFile: path)
        
        if nsDictionary != nil {
            return nsDictionary
        }
    }
    
    return nil
}

func setPlistDadosOffLine (moeda: [String:String]?, cotacao: [String:Double]?, tipo: String!) {
    let fileManager = FileManager.default
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let path = documentDirectory.appending("/dadosOffLine.plist")

    if (fileManager.fileExists(atPath: path)) {
        var nsDictionary: NSMutableDictionary?
        nsDictionary = NSMutableDictionary(contentsOfFile: path)
        
        if nsDictionary != nil {

            if tipo == "MOEDA" {
                nsDictionary?.setObject(moeda!, forKey: "moedas" as NSCopying)
            } else if tipo == "COTACAO" {
                nsDictionary?.setObject(cotacao!, forKey: "cotacao" as NSCopying)
            }
                
            if nsDictionary!.write(toFile: path, atomically: true){
                print("Gravou atualiza plist")
            }else{
                print("Erro atualiza plist")
            }
        }
        
    }
}

func valorStringToDouble(valorString: String) -> Double{
    
    var amountWithPrefix = valorString 
    // remove from String: "$", ".", ","
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    let regex2 = "\(amountWithPrefix)"
    
    amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, regex2.count), withTemplate: "")

    var double = (amountWithPrefix as NSString).doubleValue
    double = (double / 100)

    return double
}

//----
func currencyOutputFormatting(valor: String) -> String {
    var number: NSNumber!
    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyAccounting
    formatter.currencySymbol = ""
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2

    var amountWithPrefix = valor

    // remove from String: "$", ".", ","
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    
    let regex2 = "\(amountWithPrefix)"
    
    amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, regex2.count), withTemplate: "")

    let double = (amountWithPrefix as NSString).doubleValue
    number = NSNumber(value: (double / 100))

    // if first number is 0 or all numbers were deleted
    guard number != 0 as NSNumber else {
        return ""
    }

    return formatter.string(from: number)!
}


extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        
        let regex2 = "\(amountWithPrefix)"
        
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, regex2.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }



}
