//
//  BinTableViewCell.swift
//  wineBinsTableView
//
//  Created by adynak on 12/20/18.
//  Copyright © 2018 adynak. All rights reserved.
//

import UIKit

protocol BinCellDelegate{
    func didTapStepper(direction: String)
}

class BinTableViewCell : UITableViewCell {
    
    let singularText = " bottle remaining"
    let pluralText = " bottles remaining"
    
    var delegate: BinCellDelegate?

    var bin:StorageBins! {
        didSet {
            guard let binItem = bin else {return}

            if let binName = binItem.binName {
                binNameLabel.text = " \(binItem.binLocation!) \(binName)"
                if UserDefaults.standard.getShowBarcode() {
                    barcodeLabel.text = " \(binItem.barcode!)"
                } else {
                    barcodeLabel.text = ""
                }
            }
            
            if let bottleCount = binItem.bottleCount {
                bottleCountLabel.text = setLabelText(count:Int(bottleCount))
                stepperView.value = Double(bottleCount)
                stepperView.tag = bottleCount
            }
        }
    }
    
    let binNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottleCountLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let barcodeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        var cellHeight: CGFloat
        if UserDefaults.standard.getShowBarcode() {
            cellHeight = 64
        } else {
            cellHeight = 40
        }
        
        containerView.addSubview(binNameLabel)
        containerView.addSubview(barcodeLabel)
        containerView.addSubview(bottleCountLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(stepperView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo:self.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10),
            containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10),
            containerView.heightAnchor.constraint(equalToConstant:cellHeight)
        ])
        
        NSLayoutConstraint.activate([
            binNameLabel.topAnchor.constraint(equalTo:containerView.topAnchor),
            binNameLabel.leadingAnchor.constraint(equalTo:containerView.leadingAnchor),
            binNameLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            barcodeLabel.topAnchor.constraint(equalTo:binNameLabel.bottomAnchor),
            barcodeLabel.leadingAnchor.constraint(equalTo:binNameLabel.leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            bottleCountLabel.topAnchor.constraint(equalTo:barcodeLabel.bottomAnchor),
            bottleCountLabel.leadingAnchor.constraint(equalTo:binNameLabel.leadingAnchor, constant: 10),
        ])
        
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
        if (stepDirection == "minus"){
            sender.tag = Int(sender.value)
            bottleCountLabel.text = setLabelText(count: Int(sender.value))
        }
        
        responseMessages["direction"] = stepDirection
        delegate?.didTapStepper(direction: stepDirection)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
