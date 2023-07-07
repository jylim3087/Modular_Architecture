//
//  PhtoView.swift
//  App
//
//  Created by 임주영 on 2023/07/03.
//  Copyright © 2023 co.station3.kr. All rights reserved.
//

import Foundation
import UIKit
import Then
import RxDataSources

final class PhtoView: UIView {
    
    let mainWidth = UIScreen.main.bounds.width
    
    lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        $0.delegate = self
        $0.dataSource = self
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.pin.all()
    }
}
extension PhtoView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainWidth, height: mainWidth * 0.833)
    }
}
extension PhtoView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return PhotoCell()}
        return cell
    }
}

final class PhotoCell: UICollectionViewCell {
    private let imageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.pin.all()
    }
}
