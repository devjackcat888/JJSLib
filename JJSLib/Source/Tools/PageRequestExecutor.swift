//
//  PageRequestExecutor.swift
//  JJSLib
//
//  Created by SharkAnimation on 2023/7/13.
//

import UIKit
import MJRefresh

public class PageRequestExecutor<T> {
    private var list: [T] = []
    private var pageNum: Int = 1
    private var pageSize: Int = 30
    private var scrollView: UIScrollView
    public var request:((_ pageNum: Int, _ pageSize: Int, _ complete: @escaping (([T]?) -> Void)) -> Void)?
    public var listUpdated:(([T]) -> Void)?
    
    public init(scrollView: UIScrollView, pageSize: Int = 30) {
        self.scrollView = scrollView
        self.pageSize = pageSize
        
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.loadData(pageNum: 1)
        })
        scrollView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            guard let self else {
                return
            }
            self.loadData(pageNum: 1 + self.pageNum)
        })
    }
    
    private func loadData(pageNum: Int) {
        request?(pageNum, pageSize) { [weak self] list in
            guard let self else {
                return
            }
            
            self.scrollView.mj_header?.endRefreshing()
            self.scrollView.mj_footer?.endRefreshing()
            
            guard let list else {
                return
            }
            
            if list.count < self.pageSize {
                self.scrollView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self.scrollView.mj_footer?.resetNoMoreData()
            }
            
            self.pageNum = pageNum
            if pageNum <= 1 {
                self.list = []
            }
            self.list.append(contentsOf: list)
            self.listUpdated?(self.list)
        }
    }
    
    public func refreshData() {
        loadData(pageNum: 1)
    }
}
