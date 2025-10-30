//
//  ListDelegate.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/5/10.
//

import UIKit

public protocol JJSListItemProtocol {
    
}

class JJSTableViewDelegate: NSObject {

}

class JJSCollectionViewDelegate<T:JJSListItemProtocol>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    typealias dataForCell = ((_ data: T, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)
    typealias didSelected = ((_ indexPath: IndexPath, _ data: T) -> Void)
    typealias DataSourceClosure = (() -> [T])
    typealias ExtraDelegate = (UIScrollViewDelegate)
    
    var datasourceClosure: DataSourceClosure
    var dataForCellClosure: dataForCell
    var didSelectedClosure: didSelected?
    var scrollViewDelegate: ExtraDelegate?
    
    init(datasourceClosure: @escaping DataSourceClosure, dataForCellClosure: @escaping dataForCell, didSelectedClosure: didSelected?, scrollViewDelegate: ExtraDelegate?) {
        self.datasourceClosure = datasourceClosure
        self.dataForCellClosure = dataForCellClosure
        self.didSelectedClosure = didSelectedClosure
        self.scrollViewDelegate = scrollViewDelegate
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasourceClosure().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        self.dataForCellClosure(self.datasourceClosure()[indexPath.item], cell, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectedClosure?(indexPath, self.datasourceClosure()[indexPath.item])
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollViewDelegate?.viewForZooming?(in: scrollView)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}
