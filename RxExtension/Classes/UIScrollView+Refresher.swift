//
//  UIScrollView+Refresher.swift
//  RxExtension
//
//  Created by LiuSky on 03/19/2020.
//  Copyright (c) 2020 LiuSky. All rights reserved.
//

import RxSwift
import RxCocoa
import MJRefresh
import Foundation

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
    func pullToRefresh() -> Observable<Void> {
        
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel?.isHidden = true
        header.isAutomaticallyChangeAlpha = true
        self.mj_header = header
        return Observable.create({ observer -> Disposable in
            
            self.mj_header?.refreshingBlock = {
                observer.onNext(Void())
            }
            return Disposables.create()
        })
    }
    
    /// 添加加载更多
    ///
    /// - Returns: <#return value description#>
    func loadMoreFooter() -> Observable<Void> {
        
        let refreshFooter = MJRefreshAutoNormalFooter()
        refreshFooter.setTitle(BottomRefreshState.noMoreData.description, for: .noMoreData)
        self.mj_footer = refreshFooter
        return Observable.create({ observer -> Disposable in
            
            self.mj_footer?.refreshingBlock = {
                observer.onNext(Void())
            }
            return Disposables.create()
        })
    }
}

public extension Reactive where Base: UIScrollView {
    
    var isRefreshing: Binder<Bool> {
        
        return Binder(self.base) { refreshControl, refresh in
            if refresh {
                refreshControl.mj_header?.beginRefreshing()
            } else {
                refreshControl.mj_header?.endRefreshing()
            }
        }
    }
    
    var bottomRefreshState: Binder<BottomRefreshState> {
        
        return Binder(self.base) { refreshControl, state in
            
            switch state {
            case .hidden:
                refreshControl.mj_footer?.isHidden = true
            case .noMoreData:
                refreshControl.mj_footer?.isHidden = false
                refreshControl.mj_footer?.endRefreshingWithNoMoreData()
            default:
                refreshControl.mj_footer?.isHidden = false
                refreshControl.mj_footer?.resetNoMoreData()
            }
        }
    }
    
}

public extension Reactive where Base: MJRefreshComponent {
    
    /// 正在刷新(正在上拉/下拉)
    func refreshing() -> ControlEvent<Void> {
        
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create {  }
        }
        return ControlEvent(events: source)
    }
    
}




