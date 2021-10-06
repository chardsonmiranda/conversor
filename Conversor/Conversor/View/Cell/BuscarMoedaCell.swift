//
//  BuscarMoedaCell.swift
//  Conversor
//
//  Created by Chardson Miranda on 06/10/21.
//
import UIKit

class BuscarMoedaCell: UITableViewCell {

    //MARK: IBOutlets
    var siglaLabel: UILabel = .textboldLabel(text: "", fontSize: 14, numberOfLines: 0)
    var nomeLabel: UILabel = .textLabel(text: "", fontSize: 12)
    var verButton: UIButton = .padraoButton(title: "Selecionar", backgroundColor: .grayButton)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setupCell()
    }

    func setupCell(sigla: String, nome: String) {
        let textStackView = UIStackView(arrangedSubviews: [siglaLabel, nomeLabel, verButton])
        textStackView.spacing = 5
        textStackView.axis = .horizontal
        addSubview(textStackView)
        textStackView.preencher(top: topAnchor,
                            leading: leadingAnchor,
                            bottom: nil,
                            trailing: trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 10)
        )
        
        
        siglaLabel.textColor = .grayLabel
        siglaLabel.adjustsFontSizeToFitWidth = true
        nomeLabel.textColor = .white
        nomeLabel.adjustsFontSizeToFitWidth = true

        backgroundColor = .clear
        
        verButton.size(size: .init(width: 100, height: 22))
        verButton.layer.cornerRadius = 10
        verButton.clipsToBounds = true
        verButton.setTitleColor(UIColor.yellow, for: .normal)
        verButton.sendSubviewToBack(self)
        verButton.isUserInteractionEnabled = false
        
        siglaLabel.text = sigla
        nomeLabel.text = nome

    }
}
