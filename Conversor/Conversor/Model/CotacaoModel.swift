//
//  CotacaoModel.swift
//  Conversor
//
//  Created by Chardson Miranda on 06/10/21.
//

import Foundation

struct CotacaoRet: Codable {
    let success: Bool?
    let source: String?
    let quotes: [String: Double]?
}

struct CotacaoStruct {
    let sigla: String?
    let valor: Double?
}
