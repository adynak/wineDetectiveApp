//
//  DrillDownTableViewCell.swift
//  WineGPS
//
//  Created by adynak on 1/1/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import UIKit

protocol DrillDownStepperCellDelegate{
    func didTapStepper(direction: String, barcode: String)
}

class DrillDownTableViewCell : UITableViewCell {
    
    let singularText = NSLocalizedString("singularBottle", comment: "singular for the word bottle")
    let pluralText = NSLocalizedString("pluralBottle", comment: "plural of the word bottle")
    
    var delegate: DrillDownStepperCellDelegate?

    var bin:DrillLevel2! {
        didSet {
            guard let binItem = bin else {return}
            var description: String = ""

            if let producer = binItem.producer {
                producerLabel.text = binItem.producer
//                let designation = binItem.designation!
                let ava = binItem.ava!
                description = ava == "" ? "" : ava
                description = description + " " + binItem.description!
                description = description.replacingOccurrences(of: producer, with: "")
                description = description.condensedWhitespace

                vintageAndDescriptionLabel.text =  "\(binItem.vintage!) \(description)"
                
                let drinkBy = buildDrinkBy(beginConsume: binItem.beginConsume!, endConsume: binItem.endConsume!)
                
                if binItem.viewName == "location"{
                    var additionalInfo: String = ""
                    // don't confuse designation with description
                    if binItem.designation != "" {
                        additionalInfo = binItem.designation!
                    } else {
                        additionalInfo = binItem.description!.replacingOccurrences(of: "vineyard", with: "", options: .caseInsensitive)

                    }
                    vintageAndDescriptionLabel.text = "\(binItem.vintage!) \(producer) \(additionalInfo)"
                    
                    drinkByLabel.text = binItem.varietal
                    locationAndBinLabel.text = NSLocalizedString("labelDrinkByWindow", comment: "textfield label: Drinking Window: 2020 - 2022") + " \(drinkBy)"

                } else {
                    vintageAndDescriptionLabel.text =  "\(binItem.vintage!) \(description)"
                    drinkByLabel.text = NSLocalizedString("labelDrinkByWindow", comment: "textfield label: Drinking Window: 2020 - 2022") + " \(drinkBy)"
                    locationAndBinLabel.text = NSLocalizedString("labelLocation", comment: "textfield label: Location: similar to a storage room") + ": \(binItem.location!) \(binItem.bin!)"
                }
                vpvLabel.text = "\(binItem.vintage!) \(binItem.producer!) \(binItem.varietal!) \(binItem.designation!)"
            }
            
            barcodeLabel.text = NSLocalizedString("labelBarcode", comment: "textfield label: Barcode") + ": \(binItem.barcode!)"

            stepperView.tag = binItem.bottleCount!
            stepperView.value = Double(binItem.bottleCount!)

            iWineLabel.text = binItem.iWine
            vintageLabel.text = binItem.vintage
            bottleCountLabel.text = setLabelText(count: bin.bottleCount!)
            
        }
    }
    
    let vintageAndDescriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iWineLabel:UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    let vpvLabel:UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    let barcodeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = !UserDefaults.standard.getShowBarcode()
        return label
    }()

    let drinkByLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let vintageLabel:UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    let producerLabel:UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()

    let locationAndBinLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bottleCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1 \(NSLocalizedString("singularBottle", comment: "singular for the word bottle"))"
        return label
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    let stepperView : UIStepper = {
        let s = UIStepper()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.minimumValue = 0
        s.maximumValue = 1
        s.value = 1
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var rowHeight: CGFloat = 0
        
        containerView.addSubview(vintageAndDescriptionLabel)
        containerView.addSubview(drinkByLabel)
        containerView.addSubview(locationAndBinLabel)
        
        if UserDefaults.standard.getShowBarcode() {
            containerView.addSubview(barcodeLabel)
        }
        
        containerView.addSubview(bottleCountLabel)
        
        contentView.addSubview(containerView)
        contentView.addSubview(stepperView)
        
        if UserDefaults.standard.getShowBarcode() {
            rowHeight = CGFloat(76)
        } else {
            rowHeight = CGFloat(62)
        }
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo:self.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:0),
            containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10),
            containerView.topAnchor.constraint(equalTo:self.topAnchor, constant:4),
            containerView.heightAnchor.constraint(equalToConstant:rowHeight),
        ])
        
        NSLayoutConstraint.activate([
            vintageAndDescriptionLabel.topAnchor.constraint(equalTo:containerView.topAnchor),
            vintageAndDescriptionLabel.leadingAnchor.constraint(equalTo:containerView.leadingAnchor, constant: 10),
            vintageAndDescriptionLabel.heightAnchor.constraint(equalToConstant:12),
            vintageAndDescriptionLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            drinkByLabel.topAnchor.constraint(equalTo:vintageAndDescriptionLabel.bottomAnchor),
            drinkByLabel.leadingAnchor.constraint(equalTo:vintageAndDescriptionLabel.leadingAnchor, constant: 10),
            drinkByLabel.heightAnchor.constraint(equalToConstant:14),
            drinkByLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            locationAndBinLabel.topAnchor.constraint(equalTo:drinkByLabel.bottomAnchor),
            locationAndBinLabel.leadingAnchor.constraint(equalTo:drinkByLabel.leadingAnchor, constant: 10),
            locationAndBinLabel.heightAnchor.constraint(equalToConstant:14),
            locationAndBinLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
        ])
        
        if UserDefaults.standard.getShowBarcode() {
            NSLayoutConstraint.activate([
                barcodeLabel.topAnchor.constraint(equalTo:locationAndBinLabel.bottomAnchor),
                barcodeLabel.leadingAnchor.constraint(equalTo:drinkByLabel.leadingAnchor, constant: 10),
                barcodeLabel.heightAnchor.constraint(equalToConstant:14),
                barcodeLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
            ])
            
            NSLayoutConstraint.activate([
                bottleCountLabel.topAnchor.constraint(equalTo:barcodeLabel.bottomAnchor),
                bottleCountLabel.leadingAnchor.constraint(equalTo:vintageAndDescriptionLabel.leadingAnchor, constant: 10),
                barcodeLabel.heightAnchor.constraint(equalToConstant:14),
                barcodeLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
            ])
                        
        } else {
            NSLayoutConstraint.activate([
                bottleCountLabel.topAnchor.constraint(equalTo:locationAndBinLabel.bottomAnchor),
                bottleCountLabel.leadingAnchor.constraint(equalTo:vintageAndDescriptionLabel.leadingAnchor, constant: 10)
            ])
        }
                
        NSLayoutConstraint.activate([
            stepperView.centerYAnchor.constraint(equalTo:self.centerYAnchor),
            stepperView.leadingAnchor.constraint(equalTo:self.trailingAnchor, constant:-100),
            stepperView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10)
        ])
        
        stepperView.addTarget(self, action: #selector(stepperAction), for: .valueChanged)

    }
    
    private func setLabelText(count: Int) -> String {
        let plural = count == 1 ? singularText : pluralText
        return String(count) + plural
    }

    @objc func stepperAction(sender: UIStepper)  {
        
        var responseMessages = ["direction": "OK"]
        
        let stepDirection = sender.tag > Int(sender.value) ? "minus" : "plus"
        sender.tag = Int(sender.value)
        bottleCountLabel.text = setLabelText(count: Int(sender.value))
        bin.bottleCount = Int(sender.value)
        responseMessages["direction"] = stepDirection
        delegate?.didTapStepper(direction: stepDirection, barcode: bin.barcode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bottleCountLabel.text = setLabelText(count: bin.bottleCount!)
    }

}
