//
//  OilCardViewController.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilCardViewController.h"
#import "OilCardView.h"
#import "OilRecordViewController.h"
#import "GoodsDetailViewController.h"
#import "HomePageMoreViewController.h"
#import "CustomerserviceViewController.h"
#import "BaseNaVC.h"
#import "OilCardResultVC.h"
#import "FindPasswordViewController.h"
#import "RemapayMentView.h"
#import "AccountModel.h"
#import "ApplyRIntroductionsViewController.h"

@interface OilCardViewController ()<OilCardViewDelegate, OilCardResultDelegate>

@property (nonatomic, copy) NSString * mCash;

@property (nonatomic, strong) OilCardView * oilCardView;

@property (nonatomic, strong) UIButton * commitBtn;  /**< 立即兑换按钮 */

@property (nonatomic, retain) OilCardModel * selectedModel;  /**< 当前选中的金额 */

@property (nonatomic, strong) BaseNaVC * resultNAVC;
@end

@implementation OilCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.oilCardView endEidting];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- UI
- (void)initUserInterface
{
    self.title = @"油卡兑换";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    
    _oilCardView = [[OilCardView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 45 - 64)];
    _oilCardView.delegate = self;
    [self.view addSubview:_oilCardView];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = fontForSize(15);
    [button setTitle:@"兑换记录" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [button addTarget:self action:@selector(exchangeRecordsAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    _commitBtn.frame = CGRectMake(0, self.view.viewBottomEdge - 45 - 64, self.view.viewWidth, 45);
    _commitBtn.titleLabel.font = fontForSize(17);
    [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
    
    [self requestForOilCardAD];
}

- (void)requestForOilCardAD
{
    [OilCardModel requestForMoneyItemWithComplete:^(NSMutableArray *models) {
        
        self.oilCardView.models = models;
    }];

    [OilCardModel requestForOilCardADWithComplete:^(BOOL isSuccess, OilCardModel * model, NSString *message) {
       
        if (isSuccess) {
            self.oilCardView.adModel = model;
        }else {
            
        }
    }];    
}

#pragma mark -- actions
- (void)exchangeRecordsAction:(UIButton *)sender
{
    [self.oilCardView endEidting];
    OilRecordViewController * recordVC = [[OilRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)commitBtnAction:(UIButton *)sender
{
    NSLog(@"立即兑换");
    if (!self.oilCardView.selectBtn.selected) {
        SHOW_MSG(@"请阅读油卡服务协议");
        return;
    }
    if (self.oilCardView.CINumField.text.length == 0) {
        SHOW_MSG(@"请输入IC卡号");
        return;
    }
    if(!_selectedModel){
        SHOW_MSG(@"请选择充值金额");
        return;
    }
    WEAK_SELF;
    [self.HUD show:YES];
    [OilCardModel requestForMCashWithComplete:^(BOOL isSuccess, NSString *mCash, NSString *message) {
        [self.HUD hide:YES];
        if (isSuccess) {
            [weakSelf remapayMentWithUserMoney:mCash.floatValue
                                    orderMoney:weakSelf.selectedModel.cash.floatValue];
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}

#pragma mark -- 弹框输入交易密码
/**
 *  油卡兑换，只能使用M币支付
 */
- (void)remapayMentWithUserMoney:(CGFloat)userMoney orderMoney:(CGFloat)orderMoney
{
    RemapayMentView * remapayment = [[RemapayMentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                 Withmoney:userMoney
                                                                 AndOrderM:orderMoney];
    [self.view.window addSubview:remapayment];
    
    [remapayment setFinishPay:^(NSString * password) {
        [OilCardModel requestForOilCardConvertWithCINum:self.oilCardView.CINumField.text
                                                  money:[NSString stringWithFormat:@"%.2f", orderMoney]
                                               password:password
                                               Complete:^(BOOL isSuccess, NSString *message) {
            if (isSuccess) {
                // 兑换成功
                OilCardResultVC * oilCardResultVC = [[OilCardResultVC alloc] init];
                oilCardResultVC.delegate = self;
                _resultNAVC = [[BaseNaVC alloc] initWithRootViewController:oilCardResultVC];
                [self presentViewController:_resultNAVC animated:YES completion:nil];
            }else {
                SHOW_EEROR_MSG(message);
            }
        }];
        
    }];
    
    [remapayment setShezhiPassWord:^{
        NSLog(@"点击设置密码");
        FindPasswordViewController * updateVC = [[FindPasswordViewController alloc] init];
        updateVC.isPayVC = YES;
        updateVC.isPayPassword = YES;
        [self.navigationController pushViewController:updateVC animated:YES];
    }];
}

#pragma mark -- OilCardViewDelegate
- (void)oilCardResultToRecord
{
    OilRecordViewController * recordVC = [[OilRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
    
    [_resultNAVC.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)oilCardResultToHomePage
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- OilCardViewDelegate
// 点击了广告图
- (void)oilCardView:(OilCardView *)oilCardView clickedADWitModel:(OilCardModel *)model
{
    switch (model.type) {
        case 1:{
            //商品
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = model.link;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:
            //分类
        {
            NSDictionary *dataSource = @{@"gc_id":model.link, @"gc_name":model.name};
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.dataDIc = dataSource;
            homePageMoreVC.noThirdClass = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 3:
            //品牌
        {
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
            homePageMoreVC.brandName = model.name;
            homePageMoreVC.ID = model.link;
            homePageMoreVC.brandClassId = model.classID;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 4:
            //优惠券
            break;
        case 5:
            //HTML
        {
            CustomerserviceViewController *htmlVC = [[CustomerserviceViewController alloc] init];
            htmlVC.htmlUrl = model.link;
            htmlVC.hidesBottomBarWhenPushed = YES;
            if([model.link length]>0){
                [self.navigationController pushViewController:htmlVC animated:YES];
            }
        }
            break;
        case 6:{
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = model.name;
            homePageMoreVC.goods_platform_only = model.link;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        default:
            break;
    }
}
// 选中了金额
- (void)oilCardView:(OilCardView *)oilCardView selectedItemWitModel:(OilCardModel *)model
{
    self.selectedModel = model;
    [self.oilCardView endEidting];
}

// 查看协议
- (void)didSelectedProtocol
{
    NSLog(@"查看油卡兑换协议");
    
    ApplyRIntroductionsViewController * applyRVC = [[ApplyRIntroductionsViewController alloc] init];
    applyRVC.title = @"油卡兑换协议";
    NSString * textFileContents = @"为明确双方的权利和义务，规范双方业务行为，用户在成都帮麦电子商务有限公司使用M币兑换加油卡前，须仔细阅读本协议服务条款。本协议已对与您的权益有或可能具有重大关系的条款，及本公司具有或可能具有免责或限制责任的条款用粗体字予以标注，提请您注意。\n当您点击“已阅读并同意服务协议”按钮，即表示您已与成都帮麦电子商务有限公司（以下简称“帮麦网”）及中国石油化工股份有限公司（以下简称“中国石化”）达成本协议，承诺接受并遵守本协议的约定，同意并接受全部服务条款及条件。\n一、用户的权利和义务\n1. 用户应为具备完全民事权利能力和完全民事行为能力的自然人、法人或其他组织，符合前述要求的用户均可经由注册成为中国石化用户，有权拥有其在本网站的账号及密码。\n2.用户的权利依据本网站提供服务的附件《用户应用手册》享有和行使。\n3.用户应在注册时提供真实有效的信息，如姓名、身份信息、电子邮箱、联系电话、联系地址等，以便中国石化核实并提供服务，使注册用户的合法权益得到保护。当用户信息发生变更时，用户有义务及时更新相关资料。因通过用户提供的联系方式无法与用户取得联系，从而导致用户在使用本网站服务过程中产生任何损失或增加费用的，应由用户承担相应责任。用户保证不冒用他人身份在本网站进行注册。经核实发现用户提供的资料与实际不符，发生的法律纠纷与损失由用户自行承担。如有合理理由怀疑用户提供的资料错误、不实、过时或不完整，帮麦网及中国石化有权向用户发出询问及/或要求改正的通知，并有权直接做出删除相应资料的处理，直至中止、终止对用户提供部分或全部本网站服务。帮麦网对此不承担任何责任，用户将承担因此产生的任何直接或间接损失及不利后果。\n二、帮麦网的权利和义务\n1.对于用户在本网站作出的不当行为及言论，帮麦网有权在无须征得用户同意的前提下作出终止服务、删除言论等处理。\n2.帮麦网有权对不符合业务流程要求的服务指令及订单进行撤销，并保留暂时或永久限制用户所使用的全部或部分服务功能。\n3.帮麦网有义务严格按照按中国石化网上营业厅服务的业务流程及操作规定为用户提供的服务，并保证本网站所提供服务的合法性，并有义务在现有技术上维护整个网站服务及交易的正常运行。\n4.对于用户在使用本网站服务时遇到的问题以及异常情况，帮麦网应及时作出回复并协助处理。\n三、用户隐私保护\n1.本网站保证不对外公开或向第三方提供用户信息及用户在使用网络服务时存储在本网站上的非公开内容，但下列情况除外：\n（1）事先获得用户的明确授权；\n（2）根据有关的法律法规要求；\n（3）按照相关政府主管部门的要求；\n（4）为维护社会公众的利益；\n（5）为维护用户的合法权益；\n（6）不可抗力所导致的用户信息公开；\n（7）不能归咎于本站的客观情势，导致用户信息的公开；\n（8）由于本网站的硬件和软件的能力限制，所导致用户信息的公开；\n（9）符合用户利益要求的。\n2.在不透露单个用户信息的前提下，本网站有权对整个用户数据库进行统计和分析。\n3.本网站已建立了合理的安全体系，包括身份识别体系、内部安全防范体系，以使用户数据保密。但用户了解并同意本网站在现有技术条件下无法完全杜绝全部的非安全因素，但本网站会及时更新体系，妥善维护网络及相关数据。\n四、协议的确认和变更\n1.当用户点击\"已阅读并同意接受用户协议\"按钮时，即表示用户已与帮麦网及中国石化达成本协议，同意并接受全部服务条款及条件。用户承诺接受并遵守本协议约定。用户不同意本协议约定的，应立即停止注册或停止使用本网站服务。\n2.本协议内容包括协议正文、帮麦网已经发布的服务功能、操作规定。\n3.帮麦网基于运行和交易安全的需要，有权在任何时候修改、取消网站全部或部分服务功能、操作设置，以及对本网站进行功能升级、新增网站服务内容，涉及以上变更信息的，将在网站上刊载公告，告知用户，变更、修改、新增的内容一经在本网站公布，立即自动生效，且仍然适用本协议。\n4.如用户不接受相关变更信息的，则应申请停止使用本网站服务或注销账号。如用户在公告发布后继续使用本网站服务的，即表示用户仍然同意本协议或变更后的协议。对于已变更条款，包括服务功能及操作规定被认定为无效、废止或因任何原因不可执行的，不影响其它变更内容的有效性。\n5.用户应在使用本网站服务之前认真阅读全部协议内容，如对协议有任何疑问的，可通过在线留言或电话方式向中国石化咨询。用户使用本网站服务的，即认为用户已认真阅读本协议，本协议对用户及中国石化产生约束力，届时用户不应以未阅读本协议的内容或者未获得中国石化对用户咨询问题的解答等理由，主张本协议无效或要求撤销本协议。\n五、免责声明\n1.在所适用的法律允许的范围内，任何一方均无须就数据丢失或损坏直接或间接导致的损失向另一方承担赔偿责任。\n2.帮麦网对用户使用本网站所引起的任何直接、间接、偶然、特殊及继起的损害不承担责任，损害包括但不限于以下情形：\n（1）因使用网络服务不当造成的；\n（2）因账号、密码及设备保管不善造成信息泄露的；\n（3）用户自己的过错：包括输入卡号信息错误导致充错卡号；\n（4）不可归咎于本站的客观情势变动和不可抗力引起的；\n（5）限于目前可知的，超出本站的硬件和软件能力的。\n3.因网站系统出现下列状况无法正常运作，使用户无法使用网站服务时，帮麦网有义务迅速采取措施解决，但不承担损害赔偿责任，该状况包括但不限于：\n（1）帮麦网在本网站公告之系统停机维护期间。\n（2）电信设备出现故障不能进行数据传输的。\n（3）因台风、地震、海啸、洪水、停电、战争、恐怖袭击等不可抗力之因素，造成本公司系统障碍不能执行业务的。\n（4）由于黑客攻击、电信部门技术调整或故障、网站升级、银行方面的问题等原因而造成的服务中断或者延迟。\n6.用户因使用了假冒网站导致用户信息泄露及资金损失的，本网站不承担责任。\n六、争议处理\n1.交易异常处理：用户使用本网站时同意并认可可能因系统问题、相关作业网络连线问题或其他不可抗拒因素，造成网站无法提供服务、服务指令无法完成。同时用户需确保所输入的信息无误，如果因信息错误造成交易异常状况发生，从而导致无法完成用户服务指令或及时通知用户相关交易后续处理状态的，本公司不承担任何损害赔偿责任。\n2．用户与帮麦网在履行本协议的过程中，如发生争议，应友好协商解决；协商不成的，双方可向相关部门申诉或向消费者协会等有关部门投诉。双方通过协商不能解决争议的，提交帮麦网所在地有管辖权的人民法院诉讼解决。\n七、法律适用\n网络服务条款与中华人民共和国的法律法规相一致，用户和本网站一致同意服从相关法律法规的规定。如本网站某一服务条款与中华人民共和国法律相抵触，则依照法律法规的规定重新解释相应的条款，但不影响其它条款的法律效力。\n八． 解释权保留\n本协议及相关规则的最终解释权均归成都帮麦电子商务有限公司所有。";
    applyRVC.contentString = textFileContents;
    [self.navigationController pushViewController:applyRVC animated:YES];
}
@end
