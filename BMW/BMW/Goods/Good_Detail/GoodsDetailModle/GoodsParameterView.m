//
//  GoodsParameterView.m
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsParameterView.h"
#import "SliderButton.h"
#import "GoodsParameterCell.h"

@interface GoodsParameterView () <SlideButtonDelegate,UITableViewDataSource,UITableViewDelegate,GoodsParameterCellDelegate,UIWebViewDelegate> {
    UIView * _lineView;
    UILabel * _goodsNameValueLabel;         //商品名称
//    UILabel * _goodsNumValueLabel;         //商品编号
    UIScrollView * _view;
}
/**
 *  图文详情
 */
@property (nonatomic, strong)UIWebView * imageAndTextView;
/**
 *  商品参数
 */
@property (nonatomic, strong)UITableView * goodsParameterView;
/**
 *  服务说明
 */
@property (nonatomic, strong)UITextView * serviceIntroductionsView;
/**
 * 缓冲
 */
@property(nonatomic,strong)UIWebView * loadingView;

//@property (weak, nonatomic)MJRefreshHeaderView* header;
@property(nonatomic,copy)NSMutableArray * dataSource;
@property(nonatomic,copy)NSMutableArray * cellHeightArr;
@property(nonatomic,strong)UIScrollView * scrollerView;

// 菊花
@property (nonatomic, strong) MBProgressHUD *HUD;

@property(nonatomic,assign)BOOL loadedFinished;

@end


@implementation GoodsParameterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       self.backgroundColor = [UIColor whiteColor];
        SliderButton * sliderButton = [[SliderButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:@[@"图文详情", @"商品参数", @"服务说明"]];
        sliderButton.slideButtonDelegate = self;
        [self addSubview:sliderButton];
        
        _lineView = [UIView new];
        _lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [_lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, sliderButton.viewBottomEdge)];
        _lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self addSubview:_lineView];
        
        [self addSubview:self.imageAndTextView];
        [self addSubview:self.goodsParameterView];
        [self addSubview:self.serviceIntroductionsView];
        [self addSubview:self.loadingView];
        self.goodsParameterView.hidden = YES;
        self.serviceIntroductionsView.hidden = YES;
        
    }
    return self;
}

#pragma mark -- view
/**
 * 图文详情的缓冲视图
 */
-(UIWebView *)loadingView
{
    if (!_loadingView) {
        /**
         * 图文详情还没加载完  给一个缓冲背景图
         */
        
            _loadingView = [[UIWebView alloc]initWithFrame:CGRectMake(0, _lineView.viewBottomEdge, SCREEN_WIDTH, self.viewHeight - 40)];
            _loadingView.backgroundColor = [UIColor whiteColor];
            
            UIActivityIndicatorView * actor = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            actor.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            actor.center = CGPointMake(SCREEN_WIDTH / 2, 85);
            [actor startAnimating];
            [_loadingView addSubview:actor];
            
            
            /**
             * 加在图文缓冲的视图上
             */
            MJRefreshHeaderView * headerTemp =[MJRefreshHeaderView header];
            __weak MJRefreshHeaderView * weakHeaderTemp = headerTemp;
            headerTemp.scrollView = _loadingView.scrollView;
            headerTemp.beginRefreshingBlock = ^(MJRefreshBaseView* refreshView){
                
                NSOperationQueue* QueueTemp = [[NSOperationQueue alloc] init];
                [QueueTemp addOperationWithBlock:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([self.delegate respondsToSelector:@selector(endRefreshing)]) {
                            [weakHeaderTemp endRefreshing];
                            [self.delegate endRefreshing];
                        }
                        
                    });
                }];
                
            };
        
       
    }
    return _loadingView;
}
/**
 *  图文详情 UIWebView
 */
- (UIWebView *)imageAndTextView {
    if (!_imageAndTextView) {
        _imageAndTextView = [UIWebView new];
        _imageAndTextView.viewSize = CGSizeMake(SCREEN_WIDTH, self.viewHeight - 40);
        [_imageAndTextView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _lineView.viewBottomEdge)];
        _imageAndTextView.backgroundColor = [UIColor whiteColor];
        _imageAndTextView.scalesPageToFit = YES;
        _imageAndTextView.delegate = self;
        
    /**
      * 加在图文详情的 webView上面的
      */
        
       MJRefreshHeaderView * header =[MJRefreshHeaderView header];
        __weak MJRefreshHeaderView * weakHeader = header;
        header.scrollView = _imageAndTextView.scrollView;
        header.beginRefreshingBlock = ^(MJRefreshBaseView* refreshView){
        
            NSOperationQueue* Queue = [[NSOperationQueue alloc] init];
            [Queue addOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([self.delegate respondsToSelector:@selector(endRefreshing)]) {
                        [weakHeader endRefreshing];
                        [self.delegate endRefreshing];
                    }
                   
                });
            }];
        
        };
    }
    return _imageAndTextView;
}
/**
 *  商品参数
 */
- (UIView *)goodsParameterView {
    if (!_goodsParameterView) {
        _goodsParameterView = [UITableView new];
        _goodsParameterView.viewSize = CGSizeMake(SCREEN_WIDTH, self.viewHeight - 40);
        [_goodsParameterView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _lineView.viewBottomEdge)];
        _goodsParameterView.backgroundColor = [UIColor whiteColor];
        _goodsParameterView.dataSource = self;
        _goodsParameterView.delegate = self;
        _goodsParameterView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshHeaderView * header =[MJRefreshHeaderView header];
        __weak MJRefreshHeaderView * weakHeader = header;
        header.scrollView = _goodsParameterView;
        header.beginRefreshingBlock = ^(MJRefreshBaseView* refreshView){
            
            NSOperationQueue* Queue = [[NSOperationQueue alloc] init];
            [Queue addOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([self.delegate respondsToSelector:@selector(endRefreshing)]) {
                        [weakHeader endRefreshing];
                        [self.delegate endRefreshing];
                    }
                    
                });
            }];
            
        };
      
        
    }
    return _goodsParameterView;
}
/**
 *  服务说明 UIWebView
 */
- (UITextView *)serviceIntroductionsView {
    if (!_serviceIntroductionsView) {
        _serviceIntroductionsView = [UITextView new];
        _serviceIntroductionsView.viewSize = CGSizeMake(SCREEN_WIDTH, self.viewHeight - 40);
        [_serviceIntroductionsView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _lineView.viewBottomEdge)];
        _serviceIntroductionsView.backgroundColor = [UIColor whiteColor];
        _serviceIntroductionsView.editable = NO;
//        _serviceIntroductionsView.scalesPageToFit = YES;
//        _serviceIntroductionsView.delegate = self;
        
        _serviceIntroductionsView.text = @"服务说明：\n1、帮麦自营商品\n2、保税区直发，全程海关监管\n3、预计5-10个工作日送达（海外直邮商品除外，预计5-20个工作日送达）\n\n客服热线：400-100-3923\n服务时间：周一至周日9:00-21:30\n\n购物流程：\n1、用户在帮麦网下单支付\n2、结算时入境申报（提供真实的收货人姓名、身份证号）\n3、海关监管清关放行（约1-2个工作日）\n4、保税区直发（约3—7个工作日）\n5、商品送达用户签收\n\n购物小贴士：\n1.帮麦网为什么要提供身份证？\n帮麦销售的商品清关入境，根据中国海关总署要求需要您提供真实的收货人姓名、身份证信息以配合帮麦网进行个人物品入境申报。请您放心，我们将严格为该信息保密。\n2.帮麦网商品如何保证是原装正品？\n帮麦网商品均在海外生产或销售，商品符合海外质量标准。我们向您承诺：帮麦网商品来自正规渠道，原装正品。\n3.帮麦网商品为什么不提供发票？\n因为保税区商品或海外发货属于境外购买行为，因此我们无法为您开具发票，请您知晓并谅解。\n4.订单提交后能否取消订单或修改信息？\n由于下单支付后，订单提交至海外申报及纳税，您将不能修改订单信息（收货地址、电话）也不能取消订单，请您知晓并谅解。\n5.帮麦商品出现售后问题怎么办？\n您收到帮麦商品若出现售后问题，如果符合帮麦网的退换规则，请及时与在线客服联系或拨打客服热线4001003923，可退货到帮麦网指定的境内地址。\n\n*注\n因厂家会在没有任何前提通知的情况下更换商品包装、产地或一些附件，帮麦网不能确保客户收到的货物与网站图片、产地、附件说明一致。只能确保为原厂正品！并且保证与当时市场上同样主流新品一致。若帮麦网没有及时更新，请大家谅解。\n\n价格说明：\n1.非会员价：如您不是帮麦网会员，只能以非会员价格购买。加入会员\n2.会员价：为帮麦网会员享受的价格。具体详情请参照付费会员说明。\n3.特价：帮麦网将不定期推出特价商品，特价商品可能出现会员价与非会员价相同的情况，请您留意。\n4.异常问题：商品促销信息以商品详情页“促销”栏中信息为准，商品的具体售价以订单结算页价格为准。如您发现活动售价或促销信息有异常，请您联系在线客服。";
        
        
        MJRefreshHeaderView * header =[MJRefreshHeaderView header];
        __weak MJRefreshHeaderView * weakHeader = header;
        header.scrollView = _serviceIntroductionsView;
        header.beginRefreshingBlock = ^(MJRefreshBaseView* refreshView){
            
            NSOperationQueue* Queue = [[NSOperationQueue alloc] init];
            [Queue addOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([self.delegate respondsToSelector:@selector(endRefreshing)]) {
                        [weakHeader endRefreshing];
                        [self.delegate endRefreshing];
                    }
                    
                });
            }];
            
        };
    }
    return _serviceIntroductionsView;
}
#pragma mark -- SlideButtonDelegate
- (void)sledeMenu:(UIButton *)button didSelectAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath == %ld", (long)indexPath.row);
    NSInteger index = (long)indexPath.row;
    if (index == 0) {
        //图文详情
       
        self.goodsParameterView.hidden = YES;;
        self.serviceIntroductionsView.hidden = YES ;
        if (self.loadedFinished) {
            self.loadingView.hidden = YES;
        }
        else{
            self.loadingView.hidden = NO;
        }
        
        self.imageAndTextView.hidden = NO;
    }
    else if (index == 1) {
        //商品参数
        self.imageAndTextView.hidden = YES;
        self.goodsParameterView.hidden = NO;;
        self.serviceIntroductionsView.hidden = YES;
        self.loadingView.hidden = YES;
        
    }
    else if (index == 2) {
        //服务说明
        self.imageAndTextView.hidden = YES;
        self.goodsParameterView.hidden = YES;;
        self.serviceIntroductionsView.hidden = NO;
        self.loadingView.hidden = YES;
    }
}
#pragma mark -- UITableViewDataSource --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paramArr.count;
    //return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"GoodsParamCell";
    GoodsParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GoodsParameterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.index = indexPath;
    cell.dataDic = _paramArr[indexPath.row];
    return cell;
}
#pragma mark -- UITableViewDelegate --
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = [(NSDictionary *)_paramArr[indexPath.row] objectForKeyNotNull:@"value"];
    if (string && string.length > 0) {
        CGRect rect  = [TYTools boundingString:string size:CGSizeMake(SCREEN_WIDTH - 96 * W_ABCW - 15, 2000) fontSize:13];
        CGFloat cellNewHeight = rect.size.height + 30;
        return cellNewHeight;
    }
    return 50;
  
}
#pragma mark -- GoodsParameterCellDelegate --
-(void)heightGoodParameterCell:(GoodsParameterCell *)cell index:(NSIndexPath *)index newHeight:(CGFloat)height
{
    //[_cellHeightArr replaceObjectAtIndex:index.row withObject:[NSNumber numberWithFloat:height]];
    //[_goodsParameterView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
   
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    [_view removeFromSuperview];
//    _view = nil;
//    _view = [[UIView alloc]initWithFrame:webView.bounds];
//    _view.backgroundColor = [UIColor orangeColor];
    //[webView addSubview:_view];
   // webView.alpha = 0.01;
    //[self.HUD show:YES];
   
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
       NSMutableString * JSStr = [NSMutableString stringWithString:@"var myimg,oldimg,oldwidth; var imgs = document.getElementsByTagName(\"img\"); var maxwidth=document.body.scrollWidth; for(i=0;i <imgs.length;i++){ myimg=new Image(); myimg.src=imgs[i].src; oldimg =imgs[i];oldimg.style.cssText=\"\"; if(myimg.width != maxwidth){ oldwidth = myimg.width; oldimg.width = maxwidth; oldimg.height = myimg.height * (maxwidth/oldwidth); } };document.body.style.height = document.body.scrollHeight;"];
    [webView stringByEvaluatingJavaScriptFromString:JSStr];
    
    self.loadedFinished = YES;
    [self.loadingView removeFromSuperview];
    //self.loadingView = nil;
   
    //[self.HUD hide:YES];
    
   
}
#pragma mark -- get --
- (MBProgressHUD *)HUD {
    
    if (!_HUD) {
        
        _HUD = [[MBProgressHUD alloc] initWithView:self];
        //        _HUD.mode = MBProgressHUDModeAnnularDeterminate;
        _HUD.opacity = 0.5;
        _HUD.userInteractionEnabled = NO;
        [self addSubview:_HUD];
    }
    
    [self bringSubviewToFront:_HUD];
    return _HUD;
}
#pragma mark -- set --
-(void)setTextPicUrl:(NSString *)textPicUrl
{
    _textPicUrl = textPicUrl;
    [self.imageAndTextView loadHTMLString:_textPicUrl baseURL:nil];
}
-(void)setParamArr:(NSArray *)paramArr
{
    _paramArr = paramArr;
    
    [self.goodsParameterView reloadData];
}
-(void)setServiceUrl:(NSString *)serviceUrl
{
    //显示服务详情的内容当前是写死的 如果需要后台就给该字段赋值
    _serviceUrl = serviceUrl;
}

@end
