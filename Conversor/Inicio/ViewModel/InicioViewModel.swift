//
//  InicioViewModel.swift
//  Conversor
//
//  Created by Chardson Miranda on 06/10/21.
//
import Foundation

class InicioViewModel {
   
    public func criarPlistouDadosOffLine() {
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/dadosOffLine.plist")

        if (!fileManager.fileExists(atPath: path)) {
            let dicContent:[String: String] = ["moedas": "", "cotacao": ""]
            let plistContent = NSDictionary(dictionary: dicContent)
            let success:Bool = plistContent.write(toFile: path, atomically: true)
            
            if success {
                print("Arquivo Criado!")
            }else{
                print("Erro ao criar o arquivo")
            }
        }
    }
}
