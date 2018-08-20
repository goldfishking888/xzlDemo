//
//  HongBaoViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "HongBaoViewController.h"
#import "HongBaoCell.h"
#import "RedEnvelope.h"

@interface HongBaoViewController ()

@end

@implementation HongBaoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {

    }
    
    return self;
}

- (void)initData
{
    num=ios7jj;
    
    isFirst=YES;
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"红包"];
    
    [self initData];
   
    UILabel *tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,44+num,iPhone_width-20,60)];
    tipLabel.textColor=XZhiL_colour;
    tipLabel.font=[UIFont systemFontOfSize:13.0f];
    tipLabel.numberOfLines=3;
    tipLabel.text=@"温馨提示：您可在微信公众账号“小职了”菜单中“我的红包”里查询您抢到的红包编号，输入编号即可使用~";
    tipLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tipLabel];
    
    _searchImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbackgroundView.png"]];
    _searchImage.userInteractionEnabled=YES;
    _searchImage.frame=CGRectMake(5,44+num+62,iPhone_width-10,40);
    [self.view addSubview:_searchImage];
    
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_search2.png"]];
    image.frame=CGRectMake(8,9,21,21);
    [_searchImage addSubview:image];
    
    //新的收索框
    newTextfield =[[UITextField alloc]initWithFrame:CGRectMake(35,-5,200,50)];
    newTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newTextfield.returnKeyType = UIReturnKeySearch;
    newTextfield.borderStyle = UITextBorderStyleNone;
    newTextfield.font = [UIFont systemFontOfSize:14];
    newTextfield.delegate = self;
    newTextfield.placeholder = @"请输入红包编号";
    [_searchImage addSubview:newTextfield];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(285,10,21,21);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"searchdelete.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchImage addSubview:deleteBtn];
    
    UIButton *deleteBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn2.backgroundColor=[UIColor clearColor];
    deleteBtn2.frame=CGRectMake(275,0,50,40);
    [deleteBtn2 addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchImage addSubview:deleteBtn2];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44+num+110,iPhone_width,200) style:UITableViewStyleGrouped];
    _tableView.alpha=0;
    _tableView.tag=101;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=XZHILBJ_colour;
    _tableView.backgroundView=nil;
    [self.view addSubview:_tableView];
    
    useBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    useBtn.backgroundColor=[UIColor clearColor];
    useBtn.frame = CGRectMake(10,268,300,40);
    useBtn.alpha=0;
    [useBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [useBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    
    RedEnvelope *envelope=[RedEnvelope standerDefault];
    
    if (envelope.isCanUse) {    //如果是使用
       
        [useBtn setTitle:@"使用红包" forState:UIControlStateNormal];
        
        [useBtn setTitle:@"使用红包" forState:UIControlStateHighlighted];
        
    }else                           //如果不是使用
    {
        _tableView.alpha=1;
        
        useBtn.alpha=1;
        
        [useBtn setTitle:@"不使用红包" forState:UIControlStateNormal];
        
        [useBtn setTitle:@"不使用红包" forState:UIControlStateHighlighted];
    }

    [useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:useBtn];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (HongBaoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"ident";
    
    HongBaoCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell=[[HongBaoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    
    //判断红包是否过期
    
    //判断红包是否已用
    
    RedEnvelope *envelpoe=[RedEnvelope standerDefault];
    
    cell.priceLabel.text=[NSString stringWithFormat:@"%d元",envelpoe.money];
    
    cell.daijinLabel.text=[[NSString alloc]initWithFormat:@"%d元代金券（仅限涨薪宝购买）",envelpoe.money];
    
    cell.dateLabel.text=[NSString stringWithFormat:@"过期日期:%@",envelpoe.overdue];
    
    if (envelpoe.isused.integerValue==1) {   //使用过
    
        cell.tipLabel.text=@"已使用";
        
        useBtn.alpha=0;
    
    }else if (envelpoe.isOutOfDate ==1 )      //过期
    {
        cell.tipLabel.text=@"已过期";
        
        useBtn.alpha=0;
        
    }else
    {
        
        if (isFirst) {
            
            isFirst=NO;
        }else
        {
            useBtn.alpha=1;
            
            _tableView.alpha=1;
            
            if (envelpoe.isCanUse) {        //使用
                
                [useBtn setTitle:@"使用红包" forState:UIControlStateNormal];
                
                [useBtn setTitle:@"使用红包" forState:UIControlStateHighlighted];
                
            }else                       //不使用
            {
                [useBtn setTitle:@"不使用红包" forState:UIControlStateNormal];
                
                [useBtn setTitle:@"不使用红包" forState:UIControlStateHighlighted];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark  UITextField代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"开始编辑的时候响应");
    
    [newTextfield becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [newTextfield resignFirstResponder];
    
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:10000];
    
    [imageView removeFromSuperview];
    
    UILabel *lab=(UILabel *)[self.view viewWithTag:10001];
    
    [lab removeFromSuperview];
    
    /***判断是否联网***/
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        newTextfield.text=@"";
        return YES;
    }
    
    textFieldStr=newTextfield.text;
    
    if ([textFieldStr length]!=0){
        
        NSString *url=kCombineURL(KXZhiLiaoAPI, kHongbao);
        
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr,@"userToken",IMEI,@"userImei",textFieldStr,@"code",nil];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:URL];
        
        [request setTimeOutSeconds:10];
        
        request.delegate=self;
        
        [request startAsynchronous];
        
    }else
    {
        ghostView.message=@"请输入红包编号";
        [ghostView show];
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸屏幕的时候执行到了。。。。");
    [newTextfield resignFirstResponder];
}

#pragma 网络请求代理

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *resultStr=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"resultStr in requestFinished is %@",resultStr);
    
    NSString *errorStr=[resultDic valueForKey:@"error"];
    
    if (errorStr&&errorStr.integerValue==0){
        
        NSArray *arr=[resultDic valueForKey:@"data"];
        
        NSDictionary *dic=[arr objectAtIndex:0];
        
        [self setCurrentView:dic];
        
    }else if(errorStr.integerValue ==1)
    {
        
        _tableView.alpha=0;
        
        useBtn.alpha=0;
        
        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
        image.tag=10000;
        image.frame=CGRectMake(110,250,100,100);
        [self.view addSubview:image];
        
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(90,360,300,50)];
        lab.tag=10001;
        lab.backgroundColor=[UIColor clearColor];
        lab.font=[UIFont systemFontOfSize:14];
        lab.textColor=[UIColor orangeColor];
        lab.text=@"亲~红包编号输入有误哦！";
        
        [self.view addSubview:lab];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    ghostView.message=@"红包查看失败，请稍后再试!";
    [ghostView show];
}

//解析下载成功的字典
- (void)setCurrentView:(NSDictionary *)dic
{
    //下载成功，将数据存放到红包中
    RedEnvelope *envelope=[RedEnvelope standerDefault];
    envelope.envelopeID=[dic valueForKey:@"id"];
    envelope.envelopeCode=[dic valueForKey:@"code"];
    
    NSNumber *number=[dic valueForKey:@"money"];
    envelope.money= [number intValue];
    envelope.isused=[dic valueForKey:@"isused"];
    envelope.overdue=[dic valueForKey:@"overdue"];
    
    NSNumber *outofdate=[dic valueForKey:@"outofdate"];
    envelope.isOutOfDate= [outofdate intValue];
    
    envelope.isCanUse=YES;
    
    _tableView.alpha=1;
    [_tableView reloadData];
}

#pragma mark 按钮响应时间

- (void)deleteBtnClick:(id)sender
{
    newTextfield.text=@"";
}

//使用红包按钮
- (void)useBtnClick:(id)sender
{
    NSLog(@"useBtnClick............");
    
    RedEnvelope *envelope=[RedEnvelope standerDefault];
    
    if (envelope.isCanUse) {
        
        if ([self.delegate respondsToSelector:@selector(hongbao)]) { //使用红包，就得出价格
            [self.delegate hongbao];
        }
        
    }else
    {
        if ([self.delegate respondsToSelector:@selector(hongbaoChange)]) {  //不使用红包，就只留下红包二字，按原价出售
            [self.delegate hongbaoChange];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
