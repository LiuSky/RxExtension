//
//  UIScrollView+Refresher.swift
//  RxRefresh
//
//  Created by xiaobin liu on 2017/3/14.
//  Copyright © 2017年 Sky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

/// MARK: - 底部刷新状态
public enum BottomRefreshState: Int,CustomStringConvertible {
    
    case normal
    case noMoreData
    case hidden
    
    public var description: String {
        switch self {
        case .normal:
            return "默认状态"
        case .noMoreData:
            return "没有更多数据"
        case .hidden:
            return "隐藏"
        }
    }
}



// MARK: - Refresh
public extension UIScrollView {
    
    
    /// 添加下拉刷新
    ///
    /// - Returns: <#return value description#>
    public func pullToRefresh() -> Observable<Void> {
        
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.isHidden = true
        header.isAutomaticallyChangeAlpha = true
        self.mj_header = header
        return Observable.create({ observer -> Disposable in
            
            self.mj_header.refreshingBlock = {
                observer.onNext()
            }
            return Disposables.create()
        })
    }
    
    
    
    /// 添加加载更多
    ///
    /// - Returns: <#return value description#>
    public func loadMoreFooter() -> Observable<Void> {
        
        let refreshFooter = MJRefreshAutoNormalFooter()
        refreshFooter.setTitle(BottomRefreshState.noMoreData.description, for: .noMoreData)
        self.mj_footer = refreshFooter
        return Observable.create({ observer -> Disposable in
            
            self.mj_footer.refreshingBlock = {
                observer.onNext()
            }
            return Disposables.create()
        })
    }
}

extension Reactive where Base: UIScrollView {
    
    public var isRefreshing: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { refreshControl, refresh in
            if refresh {
                refreshControl.mj_header.beginRefreshing()
            } else {
                refreshControl.mj_header.endRefreshing()
            }
        }
    }
    
    public var bottomRefreshState: UIBindingObserver<Base, BottomRefreshState> {
        
        return UIBindingObserver(UIElement: self.base, binding: { refreshControl, state in
            
            switch state {
            case .hidden:
                refreshControl.mj_footer.isHidden = true
            case .noMoreData:
                refreshControl.mj_footer.isHidden = false
                refreshControl.mj_footer.endRefreshingWithNoMoreData()
            default:
                refreshControl.mj_footer.isHidden = false
                refreshControl.mj_footer.resetNoMoreData()
            }
        })
    }
}




