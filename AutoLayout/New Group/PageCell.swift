//
//  pageCell.swift
//  AutoLayout
//
//  Created by Hikaru Watanabe on 12/29/18.
//  Copyright © 2018 Hikaru Watanabe. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    //MARK:- Paramters
    private let topContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    private let logoImgView: UIImageView = {
        //Enable autolayout by disabling autoresize masking
        var logoImgView = UIImageView()
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        logoImgView.contentMode = .scaleAspectFit
        return logoImgView
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    var page: Page!{
        didSet{
            logoImgView.image = page.image
            let attString = NSMutableAttributedString(string: page.titleText, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)])
            let detailAttString = NSAttributedString(string: "\n\n\n\(page.detailText)", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray])
            attString.append(detailAttString)
            textView.attributedText = attString
            textView.textAlignment = .center
        }
    }
    
    //MARK:- UICollectionView
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(topContainerView)
        self.addSubview(logoImgView)
        self.addSubview(textView)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        //Set autolayout constraints
        
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            topContainerView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            topContainerView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            
            logoImgView.centerXAnchor.constraint(equalTo: topContainerView.safeAreaLayoutGuide.centerXAnchor),
            logoImgView.centerYAnchor.constraint(equalTo: topContainerView.safeAreaLayoutGuide.centerYAnchor),
            logoImgView.heightAnchor.constraint(equalTo: topContainerView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            logoImgView.widthAnchor.constraint(equalTo: topContainerView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            textView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
}
