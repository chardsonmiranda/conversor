//
//  MoedaViewModel.swift
//  Conversor
//
//  Created by Chardson Miranda on 05/10/21.
//

import UIKit

class MoedaViewModel {

    func buscarMoedas(completion: @escaping (MoedasRet?, Error?) -> ()) {
        var request = URLRequest(url: URL(string: "https://btg-mobile-challenge.herokuapp.com/list")!,timeoutInterval: 10)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                guard let data = data else {return}
                //print(String(data: data, encoding: .utf8)!)
                
                let apps = try JSONDecoder().decode(MoedasRet.self, from: data)
                completion(apps, nil)
            } catch {
                completion(nil, err)
                return
            }
            
        }.resume()
    }

    func buscarCotacao(completion: @escaping (CotacaoRet?, Error?) -> ()) {
        var request = URLRequest(url: URL(string: "https://btg-mobile-challenge.herokuapp.com/live")!,timeoutInterval: 10)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                guard let data = data else {return}
                //print(String(data: data, encoding: .utf8)!)
                
                let apps = try JSONDecoder().decode(CotacaoRet.self, from: data)
                completion(apps, nil)
            } catch {
                completion(nil, err)
                return
            }
            
        }.resume()
    }

}
