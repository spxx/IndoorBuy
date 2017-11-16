//
//  LPTableVIewManager.h
//  Custom
//
//  Created by LiuP on 16/9/8.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CellCallBack)(id cell, id model);

typedef enum {
    CellTypeDefault,
    CellTypeSection,
}CellType;

@interface LPTableViewManager : NSObject

@property (nonatomic, copy) NSString * identifier;      /**< 重用标志 同cell的类名 */
@property (nonatomic, retain) NSArray * models;         /**< 数据源(CellTypeDefault一维数组，CellTypeSection二维数组) */
@property (nonatomic, strong) NSArray * indexs;         /**< 右侧索引字母 */
@property (nonatomic, assign) CellType type;            /**< 对应tableview的类型，优先设置 */


/**
 初始化manager

 @param identifier cell类名字符串
 @param cellBack cell和Model的回调处理块
 @return
 */
- (instancetype)initWithIdentifier:(NSString *)identifier
                          cellBack:(CellCallBack)cellBack;

@end


@interface LPTableViewManager ()<UITableViewDataSource>

@end
