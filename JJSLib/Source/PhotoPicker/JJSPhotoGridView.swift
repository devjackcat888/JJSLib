//
//  JJSPhotoGridView.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/14.
//

import UIKit
import Photos

class JJSPhotoGridViewCell: UICollectionViewCell {
    var representedAssetIdentifier: String = ""
    var imageImage: UIImageView!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        jjs_setBackgroundColor(.clear)
        contentView.jjs_clearBackgroundColor().jjs_setClipsToBounds()
        
        imageImage = UIImageView()
            .jjs_setContentMode(.scaleAspectFill)
            .jjs_layout(superView: contentView, { make in
                make.left.top.right.bottom.equalTo(0)
            })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class JJSPhotoGridView: UIView {

    private var collectionView: UICollectionView!
    private var cachingImageManager = PHCachingImageManager()
    /// 所有获取到的资源列表
    private var asstesList: PHFetchResult<PHAsset>?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        loadAssets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        jjs_setBackgroundColor(.clear)
        
        collectionView  = UICollectionView(frame: .zero, flowLayoutMaker: { layout in
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.jjs_setScrollDirection(.vertical)
        })
        .jjs_register(JJSPhotoGridViewCell.self, identifier: "cell")
        .jjs_setBackgroundColor(.clear)
        .jjs_setDelegate(self)
        .jjs_layout(superView: self, { make in
            make.left.top.right.bottom.equalTo(0)
        })
    }
    
    private func loadAssets() {
        if asstesList == nil{
            var options = PHFetchOptions()
            options.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: false)
            ]
//            switch (_assetType) {
            //
            //                case MCPhotoPickerAssetTypePhoto:
            //                    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
            //                    break;
            //                case MCPhotoPickerAssetTypeVideo:
            //                    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
            //                    break;
            //                case MCPhotoPickerAssetTypeAll:
            //                    break;
            //                case MCPhotoPickerAssetTypeGif: {
            //                    if (@available(iOS 11, *)) {
            //                        PHFetchResult<PHAssetCollection *> *gifCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumAnimated options:nil];
            //                        if (gifCollections.count > 0) {
            //                            _fetchResult = [PHAsset fetchAssetsInAssetCollection:gifCollections.firstObject options:nil];
            //                        }
            //                    } else {
            //
            //                    }
            //                }
            //                    return;
            //            }
            
            asstesList = PHAsset.fetchAssets(with: options)
            collectionView.reloadData()
        }
    }
}

extension JJSPhotoGridView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asstesList?.count ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! JJSPhotoGridViewCell
        
        if let asset = asstesList?[indexPath.item] {
            cell.representedAssetIdentifier = asset.localIdentifier
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false
            let localIdentifier = asset.localIdentifier
            cachingImageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { [weak cell] image, info in
                if let cell = cell, let image, cell.representedAssetIdentifier == localIdentifier {
                    cell.imageImage.image = image
                }
            }
        }
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
