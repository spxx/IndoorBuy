//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFooterHeight = 44.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshHeaderUpdatedTimeKey = @"MJRefreshHeaderUpdatedTimeKey";
NSString *const MJRefreshContentOffset = @"contentOffset";
NSString *const MJRefreshContentSize = @"contentSize";
NSString *const MJRefreshPanState = @"pan.state";

NSString *const MJRefreshHeaderStateIdleText = @"下拉可以刷新";
NSString *const MJRefreshHeaderStatePullingText = @"松开立即刷新";
NSString *const MJRefreshHeaderStateRefreshingText = @"正在刷新数据中...";

NSString *const MJRefreshFooterStateIdleText = @"点击加载更多";
NSString *const MJRefreshFooterStateRefreshingText = @"正在加载更多的数据...";
NSString *const MJRefreshFooterStateNoMoreDataText = @"已经全部加载完毕";



/**
 * Add
 */
const CGFloat MJRefreshViewHeight = 64;//64.0 //BG - 后改 修改时间 : 2016/1/7 14:11
const CGFloat MJRefreshAnimationDuration = 0.25;

NSString *const MJRefreshBundleName = @"MJRefresh.bundle";

NSString *const MJRefreshFooterPullToRefresh = @"上拉可以加载更多数据";
NSString *const MJRefreshFooterReleaseToRefresh = @"松开立即加载更多数据";
NSString *const MJRefreshFooterRefreshing = @"标哥正在帮你加载数据...";

NSString *const MJRefreshHeaderPullToRefresh = @"下拉,返回宝贝详情";
NSString *const MJRefreshHeaderReleaseToRefresh = @"释放,返回宝贝详情";
NSString *const MJRefreshHeaderRefreshing = @"返回";
NSString *const MJRefreshHeaderTimeKey = @"MJRefreshHeaderView";

