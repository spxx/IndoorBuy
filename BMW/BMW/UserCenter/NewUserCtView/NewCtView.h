//
//  NewCTView.h
//  BMW
//
//  Created by rr on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewCTDelegate <NSObject>

-(void)ViewRf;
-(void)clickImageGoto;
-(void)gotoProcess;
-(void)loginBtn;
-(void)regisBtn;
-(void)myorder;
-(void)stateB:(NSString *)orderB;
-(void)clickedMonthVewWithTag:(NSInteger)tag;
-(void)didseletedTag:(NSInteger)tag;
-(void)gotoXiaoxi;
-(void)processSetButton;
-(void)adverProcess;
-(void)gotoMyStore;
-(void)BtnProess;

@end

@interface NewCTView : UIView

@property (nonatomic, strong)UILabel * moneyCount;          /**< 当月余额 */
@property (nonatomic, strong)UILabel * coupCount;            /**< 优惠券 */
@property (nonatomic, strong)UILabel * bankCount;           /**< 银行卡 */

@property (nonatomic, strong)UIScrollView *scrollView;


@property(nonatomic, assign)id <NewCTDelegate> delegate;
@property(nonatomic,strong)UIImageView *touxiangImage;
@property(nonatomic,strong)UIImageView *backGroundImageV;
@property(nonatomic,strong)UILabel *userName;

-(void)isloginView;
-(void)notLoginView;
-(void)newsArray:(BOOL)array;
-(void)updateNumOrder:(NSDictionary *)orderDic;
-(void)updateAdverHeight:(NSString *)adverUrl;
-(void)updateBackGround:(NSString *)url;
-(void)updateMystore:(NSDictionary *)dic;


@end
