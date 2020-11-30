//
//  MainViewController.swift
//  iOSTest
//
//  Created by luckysmg on 2020/11/28.
//

import UIKit
import AVKit
import Photos




class PhotoCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        imageView.frame = self.contentView.frame
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PhotoCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var images = [UIImage]()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
        cell.imageView.image = self.images[indexPath.item]
        return cell
        
    }
    
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = self.view.frame.width / 3 - 1
        layout.itemSize = CGSize(width: width, height: width)
        let collectionView  = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        collectionView.frame = self.view.frame
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            self.fetchPhoto()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }

    
    func fetchPhoto()  {
        let manager = PHImageManager.default()
        let requestOption = PHImageRequestOptions()
        requestOption.deliveryMode = .highQualityFormat
        requestOption.isSynchronous = true
        
        let collection  = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype:.smartAlbumUserLibrary, options: nil)
        collection.enumerateObjects { (collection, index, stop) in
            let assetResult = PHAsset.fetchAssets(in: collection,options:nil)
            
            for i in 0..<assetResult.count{
                manager.requestImage(for: assetResult.object(at: i), targetSize: CGSize.init(width: 200, height: 200), contentMode: .aspectFill, options: requestOption) { (image, error) in
                    if let image = image{
                        self.images.append(image)
                    }
                }
                
            }
        }
        
        
        
    }
    
}

#if DEBUG
import SwiftUI

struct MainPreview : PreviewProvider{
    static var previews: some View{
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container : UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
        func makeUIViewController(context: Context) -> UIViewController {
            
            PhotoCollectionViewController()
            
        }
    }
}
#endif

