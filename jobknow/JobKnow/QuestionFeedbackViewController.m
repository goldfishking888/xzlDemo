//
//  QuestionFeedbackViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "QuestionFeedbackViewController.h"
#import "Cell.h"
#import "SubCateViewController.h"
#import "UIFolderTableView.h"
#import "JSON.h"
#import "TipsView.h"

@interface QuestionFeedbackViewController ()

@end

@implementation QuestionFeedbackViewController
int num;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        num = ios7jj;
        _dataListArray = [NSMutableArray arrayWithObjects:@"小职了为什么这么受欢迎？",@"为什么说小职了实现了所在城市100%职位覆盖？",@"小职了怎么让求职者'巨方便'了？",@"小职了怎样保障职位的真实性？",@"为什么有些企业职位信息不完整？",@"最方便的小职了语音简历怎么使用？",@"小职了也需要注册简历吗？",@"小职了求职怎样投递简历？",@"企业可以直接在小职了发布招聘信息吗？",@"新的职位信息什么时候推送给我？",@"怎样才算新增职位？",@"小职了为什么风靡蓝领人士？",@"白领为什么也风靡使用小职了？",@"小职了为什么成为学生求职的标配？",@"怎样平衡订阅职位精度与数量？",@"发现没有实现职位100%覆盖怎么办？",@"小职了为什么在某些城市看不到职位信息？",@"为什么有些学校可以优先于其他学校使用小职了？", nil];//标头
        
        _detailArray = [NSMutableArray arrayWithObjects:@"小职了是国内首个整合所在城市所有招聘渠道实现100%职位覆盖的手机求职应用，其最大特点是'巨方便'：通过手机即时接收100%最全职位、无需注册简历通过手机即时投递职位、无需拨号即时呼叫企业及即时接收企业通知等。",@"小职了通过先进的职位内容系统、庞大的职位内容团队及全方面的行业合作3大力量整合了所在城市所有招聘源头：所有网站、报纸、现场、校园等途径，保障了所在城市100%当日新增职位的覆盖。您可以通过首页的'遗漏举报'功能核查内容的完整性，内容团队的绩效与内容的完备性直接相关。",@"1、'全城职位全知道'-100%整合了所在城市所有招聘源头：所有网站、报纸、现场、校园等途径，巨方便地通过手机订阅接收当日所有新增职位；\n2、'随时随地接收、投递'-手机随时接收最新职位，无需注册简历直接手机邮件投递，无需拨号直接手机呼叫企业。小职了相当于自己的专业'求职秘书'，根据您的要求不知疲倦、一丝不苟地为您搜集所在城市当日所有的新增职位，而不让自己因为忙碌失去任何职业良机，这也是小职了不但广受求职者，也广受在职者欢迎的原因所在。",@"小职了的信息全部来自于城市现有正规招聘途径，在信息发布之前已经过合同确认、人工审核，不存在非合同企业免费发布招聘信息的情况。",@"部分企业原始招聘信息本就不完备时就会出现这种情况。比如报纸招聘缺少详细的要求介绍等。有时候企业也可能不公开电话等联系方式。",@"您只需要按住录音按钮，说出您的求职意向、工作履历、电话号码及姓名等信息，保存后即可把您的语音简历投放至企业。这项功能暂时只对高级用户开放。",@"小职了不需要注册简历。您的简历可以以word等文件格式直接通过email投递或者直接投递语音简历（暂时只对高级用户开放）。",@"直接email投递简历、直接电话联系、直接投递语音简历（暂时只对高级用户开放）。",@"不可以。小职了不接受企业直接的收费或免费职位发布。发布职位请通过我们推荐给您的所在城市任何现有招聘途径发布。发布后会自动在小职了平台同步。",@"每天推送一次，默认的时间为每天早上9点，您可以根据自身需要在'设置'里设定推送时间。",@"小职了之前，求职者很头疼的问题之一就是网站发布的同一个职位，企业会通过职位刷新每天虚假的呈现为新职位，这样的新职位实际上80%以上是老职位，这导致求职者每天搜索得到的所谓新职位其实大多数是之前看过的，这大大耗费了求职者精力。\n小职了彻底解决了这个问题：通过新增职位的查重去重功能，系统会自动甄别该企业的该职位是否之前已经发布，如果已经发布，则不再作为新职位发布，除非该重复职位上次发布日期距离查重日超过15天以上，才视其为新增职位。",@"由于工作繁重和上网、外出的不方便，在小职了之前，蓝领人士在职位获取方面是很不方便的，是不平等的。有了小职了，蓝领人士不用花费任何时间精力即可和别人一样获得全部的职位，实现了机会面前人人平等，进而实现了职业上的主动性，减少了盲目性和被动性。之前是离家再找工作，有了小职了后是离家前就找好了工作。也因此小职了成为了国家人力资源和社会保障部民生示范工程。",@"每个白领都希望能够不错过任何一个更好的职业机会的，但是没有任何一个人能够花费巨大的精力一边工作着一边每天浏览所有的网站、报纸、参加所有的招聘会去看尽所有的职位。小职了，'全城职位全知道'，100%整合了所在城市所有招聘源头，只需订阅符合自己期望的职位即可每天收获所有机会；同时手机的隐秘性也消除了工作场所电脑浏览别的公司职位的尴尬。小职了相当于自己的专业'求职秘书'，根据您的要求不知疲倦、一丝不苟地为您搜集所在城市当日所有的新增职位，而不让自己因为忙碌失去任何职业良机。",@"大学生群体尤其是马上面临就业的大学生，最想得知当前市场的全部求职信息，无论是社会的，还是任何校园的。小职了就因为做到了信息100%最全，让同学不会错过任何机会从而成为了学生的标配，也成为国家教育部就业示范工程。",@"打开首页订阅功能后，在职位订阅器中根据自身求职需要选择行业、职业、薪资要求等信息，即可订阅职位；输入职位关键字，可使职位订阅更加精确。根据自身需要，可设置多个职位订阅器。",@"小职了职位实现了所在城市职位的100%覆盖，包括所在城市列出的所有主要招聘通路。如果我们的内容团队疏漏了，请您马上点击首页遗漏举报按钮帮我们改进！您的举报一经核实，当月内您将获赠手机充值卡10元/条。充值后将电话通知您。",@"小职了的核心价值是提供所在城市100%的职位覆盖。在我们没有实现所在城市职位100%覆盖之前，出于对用户的负责，我们暂时不开通相关城市的服务，敬请等待。",@"各个学校对学生就业工作的力度和进度是不同的。在小职了的使用过程中，一些学校的就业促进工作会领先于企业学校，一些会稍微滞后。请联系咨询所在学校的就业指导相关部门了解进度。", nil];//展开内容
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"常见问题"];
    
    [self.view setBackgroundColor:XZHILBJ_colour];
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
	self.myTabView = [[UIFolderTableView alloc]initWithFrame:CGRectMake(0, 44+num, 320, iPhone_height-44)style:UITableViewStyleGrouped];
    self.myTabView.delegate = self;
    self.myTabView.dataSource = self;
    
    UIView *tvBg = [[UIView alloc] initWithFrame:_myTabView.frame];
    [tvBg setBackgroundColor:XZHILBJ_colour];
    
    [self.myTabView setBackgroundView:tvBg];
    
    [self.view addSubview:self.myTabView];
}

- (void)request
{
//    NetWorkConnection *net = [[NetWorkConnection alloc] init];
//    net.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI, @"question.php?");
    NSDictionary *par = [NSDictionary dictionaryWithObjectsAndKeys:kVerificationStr,@"o_id", nil];
//    [net sendRequestURLStr:url ParamDic:par Method:@"GET"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:par urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        mAlertView(nil, @"反馈成功");
    }];
    [request setFailedBlock:^{
//        [loadView hide:YES];
    }];
    [request startAsynchronous];
}

- (void)receiveDataFinish:(NSData *)receData1 Connection:(NSURLConnection *)connection
{
//    NSString *result = [[NSString alloc] initWithData:receData1 encoding:NSUTF8StringEncoding];
    //NSString *string = [self string2Json2:result];
}

- (NSString *)string2Json2:(NSString *)jsonString{
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\r"withString:@"\\r"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n"withString:@"&"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\t"withString:@"\\t"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\f"withString:@"\\f"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\\"withString:@"\\\\"];
    return jsonString;
}

- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)myBack:(id)sender
{
    FeedbackVC *feed = [[FeedbackVC alloc]init];
    feed.deleat= self;
    [self.navigationController pushViewController:feed animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.myTabView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    Cell *cell = (Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    NSString *name = [_dataListArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = name;
    [cell.titleLabel setTextColor:RGBA(1, 1, 1, 1)];
    [cell.titleLabel setFont:[UIFont systemFontOfSize:14]];
    cell.titleLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(5, 0);
    cell.myImg.image = [UIImage imageNamed:@"point.png"];
    CGRect rect = CGRectInset(cellFrame, 45, 8);
    cell.titleLabel.frame = rect;
    [cell.titleLabel sizeToFit];
    if (cell.titleLabel.frame.size.height>35) {
        cellFrame.size.height = 58+cell.titleLabel.frame.size.height-46;
    }else{
        cellFrame.size.height = 40;
    }
    [cell setFrame:cellFrame];
    return cell;
    
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell *)[self.myTabView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell changeArrowWithUp:YES];
    
    SubCateViewController *subVc = [[SubCateViewController alloc]
                                    initWithNibName:NSStringFromClass([SubCateViewController class])
                                    bundle:nil];
    subVc.Info = [_detailArray objectAtIndex:indexPath.row];
    self.myTabView.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     
                                     NSLog(@"执行到了123");
                                     
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    
                                     NSLog(@"执行到了321");
                                
                                }
                           completionBlock:^{
                               NSLog(@"执行到了321123");
                               self.myTabView.scrollEnabled = YES;
                               [cell changeArrowWithUp:NO];
                           }];
}


-(void)CloseAndOpenACtion:(NSIndexPath *)indexPath
{
    NSLog(@"tong mei");
    if ([indexPath isEqual:self.selectIndex]) {
        self.isOpen = NO;
        [self didSelectCellRowFirstDo:NO nextDo:NO];
        self.selectIndex = nil;
    }
    else
    {
        if (!self.selectIndex) {
            self.selectIndex = indexPath;
            [self didSelectCellRowFirstDo:YES nextDo:NO];
            
        }
        else
        {
            [self didSelectCellRowFirstDo:NO nextDo:YES];
        }
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell *cell = (Cell *)[self.myTabView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.myTabView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

- (void)changeColur02
{
    ghostView.message = @"感谢您的宝贵意见!";
    ghostView.position = OLGhostAlertViewPositionCenter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
