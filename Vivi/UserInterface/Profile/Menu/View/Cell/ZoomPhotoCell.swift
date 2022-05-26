//
//  ZoomPhotoCell.swift
//  Vivi
//
//  Created by Дмитрий Дудкин on 27.05.2022.
//

import UIKit
import EasyPeasy
import SDWebImage

class ZoomPhotoCell: ReusableCell {
    var url: URL?
  
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 5
        scroll.delegate = self
        scroll.bouncesZoom = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    lazy var photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "photo.on.rectangle")
        view.tintColor = .viviRose
        view.round(4)
        view.isUserInteractionEnabled = true

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(photoView)
    }
    
    func setupConstraints() {
        scrollView.easy.layout(Top(), Leading(), Trailing(), Bottom())
        photoView.easy.layout(
            CenterX(),
            CenterY(),
            Width(UIScreen.main.bounds.width),
            Height(UIScreen.main.bounds.height)
        )
    }
    
    func configure(with url: URL) {
        self.url = url
        photoView.sd_setImage(with: url,
                              placeholderImage: UIImage(systemName: "photo.on.rectangle")?.template())
    }

    func reset() {
        scrollView.zoomScale = 1
    }
}

extension ZoomPhotoCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
}
