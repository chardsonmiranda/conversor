//
//  MoedaModel.swift
//  Conversor
//
//  Created by Chardson Miranda on 05/10/21.
//

import Foundation

// MARK: - Welcome
struct MoedasRet: Codable {
    let success: Bool?
    let currencies: [String: String]?
}

struct MoedasStruct {
    let sigla: String?
    let nome: String?
}
