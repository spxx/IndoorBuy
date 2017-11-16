//
//  UserProtocolVC.m
//  DP
//
//  Created by LiuP on 16/8/16.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "UserProtocolVC.h"

@interface UserProtocolVC ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation UserProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self initUserInterface];
}

- (void)initUserInterface
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 64)];
    [self.view addSubview:_scrollView];
    UILabel * title = [UILabel new];
    title.font = [UIFont boldSystemFontOfSize:15];
    title.viewSize = CGSizeMake(self.view.viewWidth, 15);
    title.center = CGPointMake(self.view.center.x, 30);
    title.text = @"成都帮麦电子商务有限公司“银行卡绑定”服务协议";
    title.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:title];
    
    UILabel * content = [UILabel new];
    content.viewSize = CGSizeMake(self.view.viewWidth - 20, 0);
    content.font = [UIFont systemFontOfSize:11];
    content.numberOfLines = 0;
    [_scrollView addSubview:content];
    
    content.text = @"      成都帮麦电子商务有限公司（以下简称“帮麦网”）“银行卡绑定”服务协议（以下简称“本协议”）是帮麦网与帮麦网客户签订关于绑卡事项所订立的有效合约。您勾选确认接受本协议，即表示您知悉、理解并同意接受本协议的全部内容，确认承担由此产生的一切法律后果。\n\n      在确认接受本协议之前，请您仔细阅读本协议的全部内容。如果您不同意本协议的任何内容，或者无法准确理解相关条款的解释，请不要进行后续操作。\n\n      本协议所称“银行卡绑定”是指您按照帮麦绑定卡号时行为与操作。及后续该卡进行提现申请功能，及其衍生功能。\n\n一、申请\n\n      1．您在申请本服务过程中，勾选“银行卡绑定”协议接受本协议即表示您同意接受本协议项下的全部内容，同意帮麦网获取您填写的相关信息（包括但不限于姓名，银行卡卡号，开户行等）提供给帮麦网进行余额提现等资金服务，（帮麦网仅出于完成本协议项下功能而使用您提供的信息，且对您的相关信息进行严格保密）。同意后将在您进行余额提现功能等资金服务时。会将资金服务提供给所选定的卡。并同意承担由此产生的一切法律后果。\n\n      2．您须确保您在申请本服务时绑定的银行卡为您本人的银行卡，并确保使用银行卡的行为合法、有效，未侵犯任何第三方合法权益；否则因此造成帮麦网、发卡行及任何第三方损失的，您应负责赔偿并承担全部法律责任。\n\n      3．您同意在申请本服务过程中，准确提供您的相关信息，并保证信息（如卡号，开户行信息等）的真实、合法、有效、完整，并授权帮麦网收集您的银行卡等信息。同时应及时更新您的资料。因您未及时更新资料，导致本服务无法提供或提供时发生任何错误，由此产生的后果将由您自行承担。若帮麦网有合理理由怀疑您提供的资料不实、非法、无效或不完整，帮麦网有权拒绝、暂停或终止向您提供本服务，帮麦网对此不承担任何责任，您将承担因此产生的责任和损失。\n\n二、声明与承诺\n\n      1.您知悉并同意帮麦网为本服务收集、使用并传递您的姓名、证件号码、银行卡号、手机号码等个人资料。\n\n      2.我司不会以任何理由和形式要求您提交银行卡交易密码，请持卡人务必自行保管银行卡交易密码。\n\n      3.因持卡人填写银行卡绑定信息错误导致的提现资金损失，提现打款失败、延期等情况，由持卡人自行承担相关责任。\n\n      4.您知悉并同意：帮麦网有权因法律法规政策、系统升级或其他合理原因，修改、暂停、终止本协议，并在修改、暂停或终止协议前通过帮麦网网站进行公告，无需另行单独通知您；若您在本协议修改公告发布后继续使用本服务的，表示您已充分阅读、理解并接受修改后的协议内容，也将遵循修改后的协议内容；若您不同意修改后的协议内容，您应向帮麦网申请终止使用本服务。\n\n      5.出现下列情况之一的，帮麦网有权立即终止您相关服务而无需承担任何责任：（1）违反本协议的约定；（2）违反帮麦网/或其他关联第三方的条款、协议、规则、通告等相关规定，而被上述任一第三方终止提供服务的；（3）帮麦网认为向您提供本服务存在风险的；";
    [content sizeToFit];
    content.center = CGPointMake(self.view.center.x, title.viewBottomEdge + 20 + content.viewHeight / 2);
    _scrollView.contentSize = CGSizeMake(self.view.viewWidth, content.viewBottomEdge + 15);
}
@end
