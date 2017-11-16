//
//  InviRCView.h
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviRCViewDelegate <NSObject>

-(void)viewReFresh;

-(void)viewLoadMore;


@end

@interface InviRCView : UIView

@property(nonatomic, assign) id <InviRCViewDelegate> delegate;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, strong) UIView *noRecordView;

@property(nonatomic, strong) UIView *recordView;

@end
