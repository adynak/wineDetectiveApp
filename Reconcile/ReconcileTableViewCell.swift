//
//  BinTableViewCell.swift
//  wineBinsTableView
//
//  Created by adynak on 12/20/18.
//  Copyright © 2018 adynak. All rights reserved.
//

import UIKit

protocol ReconcileBinCellDelegate{
    func didTapStepper(direction: String)
}

class ReconcileTableViewCell : UITableViewCell {
    
    let singularText = NSLocalizedString("singularBottle", comment: "")
    let pluralText = NSLocalizedString("pluralBottle", comment: "plural")
    
    var delegate: ReconcileBinCellDelegate?

    var bin:Level2! {
        didSet {
            guard let binItem = bin else {return}

            if let producer = binItem.producer {
                vintageProducerLabel.text =  " \(binItem.vintage!) \(producer) "
                producerLabel.text = producer
            }
            let bottleCount: Int = 1
            varietalLabel.text = "  \(binItem.varietal!)"

            bottleCountLabel.text = setLabelText(count:bottleCount)
            stepperView.value = Double(bottleCount)
            stepperView.tag = bottleCount
            barcodeLabel.text = binItem.barcode
            iWineLabel.text = binItem.iWine
            vintageLabel.text = binItem.vintage
        }
    }
    
    let vintageProducerLabel:UILabel = {
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
    
    let barcodeLabel:UILabel = {
        let label = UILabel()
        label.isHidden = true
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

    
    let varietalLabel:UILabel = {
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
        
        containerView.addSubview(vintageProducerLabel)
        containerView.addSubview(varietalLabel)
        containerView.addSubview(bottleCountLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(stepperView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo:self.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:0),
            containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10),
            containerView.heightAnchor.constraint(equalToConstant:46)
        ])
        
        NSLayoutConstraint.activate([
            vintageProducerLabel.topAnchor.constraint(equalTo:containerView.topAnchor),
            vintageProducerLabel.leadingAnchor.constraint(equalTo:containerView.leadingAnchor, constant: 10),
            vintageProducerLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            varietalLabel.topAnchor.constraint(equalTo:vintageProducerLabel.bottomAnchor),
            varietalLabel.leadingAnchor.constraint(equalTo:vintageProducerLabel.leadingAnchor, constant: 29),
            varietalLabel.trailingAnchor.constraint(equalTo:containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottleCountLabel.topAnchor.constraint(equalTo:varietalLabel.bottomAnchor),
            bottleCountLabel.leadingAnchor.constraint(equalTo:vintageProducerLabel.leadingAnchor, constant: 10)
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
        sender.tag = Int(sender.value)
        bottleCountLabel.text = setLabelText(count: Int(sender.value))
                
        responseMessages["direction"] = stepDirection
        delegate?.didTapStepper(direction: stepDirection)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
