//
//  GoodsTopAlbum.h
//  BMW
//
//  Created by gukai on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModle.h"


@protocol GoodsTopAlbumDelegate <NSObject>

@optional
-(void)goodsTopAlbumClickCollectButton:(UIButton *)sender;
-(void)goodsTopAlbumClickBeVIPButton:(UIButton *)sender;
-(void)goodsRefersh;
-(void)gotoAcitiy:(NSString *)title andID:(NSString *)bind_id;

@end
@interface GoodsTopAlbum : UIView


@property(nonatomic,copy)GoodsDetailModle *infoModele;


/**
 * 收藏按钮
 */
@property(nonatomic,strong)UIButton * collectBtn;


@property(nonatomic,strong)UIButton * beVIPBtn;

/**
 * 限时专用
 */
@property(nonatomic,assign)BOOL xianshi;



/**
 * 数据源(可以数据源赋值) 可以单个属性单独赋值
 */
//@property(nonatomic,copy)NSDictionary * dataDic;//数据源
@property(nonatomic,assign)id<GoodsTopAlbumDelegate> delegate;

-(void)xiaohui;

@end
