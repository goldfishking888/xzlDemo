//
//  NewjianliViewController.m
//  JobKnow
//
//  Created by Zuo on 14-2-18.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "NewjianliViewController.h"
#import "More.h"
#import "MyTableCell.h"
#import "jiaoyuxxViewController.h"
#import "qiuzhiyxViewController.h"
#import "jibenwansViewController.h"
#import "jingliViewController.h"
#import "peixunViewController.h"
#import "waiyuViewController.h"
#import "jibenxxViewController.h"
#import "AudioButton.h"
#import "GGFullScreenImageViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Photo.h"
#import "VoiceConverter.h"
#import "ASINetworkQueue.h"
#import "SDDataCache.h"
#import "ASIDownloadCache.h"
@interface NewjianliViewController ()

@end

@implementation NewjianliViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _moreArray = [NSMutableArray array];
        NSArray *more = [NSArray arrayWithObjects:@"图片",@"语音",@"文件",@"基本信息",@"教育信息",@"求职意向",@"基本信息完善",@"工作经历",@"工作能力与自我评价",@"培训经历",@"外语能力",nil];
        NSMutableArray *zu = [NSMutableArray array];
        for (NSInteger i = 0; i < more.count; i++)
        {
            More *m = [[More alloc] init];
            NSString *image = [NSString stringWithFormat:@"more_menu_%d@2x",i];
            m.moreImage = [UIImage imageNamed:image];
            m.moreName = [more objectAtIndex:i];
            [zu addObject:m];
            switch (i)
            {
                case 2:
                    [_moreArray addObject:zu];
                    zu = [NSMutableArray array];
                    break;
                case 5:
                    [_moreArray addObject:zu];
                    zu = [NSMutableArray array];
                    break;
                case 10:
                    [_moreArray addObject:zu];
                    zu = [NSMutableArray array];
                    break;
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int num=ios7jj;
    _soundArray = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
    _fileArray = [NSMutableArray array];
    self.view.backgroundColor = XZHILBJ_colour;
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStyleGrouped];
    myTableView.delegate =self;
    myTableView.dataSource = self;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
    UIImage *image = [UIImage imageNamed:@"bg.png"];
    imgProfile = [[UIImageView alloc] initWithImage:image];
    imgProfile.frame = CGRectMake(0, 44+num, iPhone_width, 130);
    [self.view addSubview:imgProfile];
    //头像所在阴影
    myView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, 130)];
    myView.backgroundColor =[UIColor  colorWithPatternImage:[UIImage imageNamed:@"jianliiYinying.png"]];
    [self.view addSubview:myView];
    
    //相框
    UIImageView *img01 = [[UIImageView alloc]init];
    img01.frame = CGRectMake(15, 15, 89, 90);
    img01.image = [UIImage imageNamed:@"headerimg_bg"];
    [myView addSubview:img01];
    //头像
    headImg = [[UIImageView alloc]init];
    headImg.frame = CGRectMake(21, 21, 76, 76);
    headImg.layer.masksToBounds = YES;
    headImg.image = [UIImage imageNamed:@"header_default"];
    [myView addSubview:headImg];
    //照相机icon
    UIImageView *img03 = [[UIImageView alloc]init];
    img03.frame = CGRectMake(74, 74, 33, 33);
    img03.image = [UIImage imageNamed:@"camera"];
    [myView addSubview:img03];
    [self addBackBtn];
    [self addTitleLabel:@"简历中心"];
    //上传头像按钮
    UIButton *button01 = [UIButton buttonWithType:UIButtonTypeCustom];
    button01.frame =CGRectMake(15, 15, 89, 95);
    [button01 addTarget:self action:@selector(takephoto:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:button01];
    //预览简历按钮
    UIButton *button02 = [UIButton buttonWithType:UIButtonTypeCustom];
    button02.frame =CGRectMake(225, 15, 89, 95);
    [button02 addTarget:self action:@selector(takephoto2:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:button02];
   

    
    
    
    

}
#pragma mark------上传简历头像方法
- (void)takephoto:(id)sender
{
    _isHead = YES;
    [self openCameraWithTitle:@"上传简历头像"];
}
//预览简历方法
- (void)takephoto2:(id)sender
{
}
- (void)openCameraWithTitle:(NSString *)title
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentModalViewController:imagePickerController animated:YES];
    }else if (actionSheet.tag == 256)
    {
        switch (buttonIndex) {
            case 0:
                // 预览
                if (selectFile.fileItem == FileImage) {
                    GGFullscreenImageViewController *imageVC = [[GGFullscreenImageViewController alloc] init];
                    FileButton *fileBtn = (FileButton *)[rootScrollView viewWithTag:selectTag];
                    SDDataCache *imageCache = [SDDataCache sharedDataCache];
                    NSData *imageData = [imageCache dataFromKey:selectFile.fileRealName fromDisk:YES];
                    UIImage *image = [UIImage imageWithData:imageData];
                    fileBtn.bgView.image = image;
                    //UIImageView *iv = [[UIImageView alloc] initWithImage:image];
                    imageVC.liftedImageView =fileBtn.bgView;
                    [self presentModalViewController:imageVC animated:YES];
                }else if(selectFile.fileItem == FileSound)
                {
                    [sheetRecord showInView:self.view];
                    [self addRecordViewPlay:YES];
                    updateProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setAudioProgress) userInfo:nil repeats:YES];
                    [self playRecordPath:selectFile.openPath];
                }else
                {
                    [self getFileFromServer];
                }
                break;
            case 1:
                // 删除
                [self deleteResumeFileBtn];
                break;
            case 2:
                // 与简历解绑
                [self unbindingFromResume];
                break;
            case 3:
                // 取消
                break;
        }
        
    }
    
}
//解绑
- (void)unbindingFromResume
{
    FileButton *fileBtn = (FileButton *)[rootScrollView viewWithTag:selectTag];
    NSString *urlString = kshouzhijiURL(kShouzhijiURLStr, @"message.php?ac=attachment_status&");
    NSDictionary *paramter = nil;
    NSString *authId = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthID];
    if (selectFile.binding) {
        paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"mtype",selectFile.attachment_id,@"file_id",authId,kAuthID, nil];
        
    }else
    {
        paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"mtype",selectFile.attachment_id,@"file_id",authId,kAuthID, nil];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:paramter urlString:urlString];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        NSLog(@"image----------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        if (selectFile.binding) {
            selectFile.binding = NO;
            fileBtn.binding = NO;
            fileBtn.bindingView.alpha = 0;
        }else
        {
            fileBtn.bindingView.alpha = 1;
            fileBtn.binding = YES;
            selectFile.binding = YES;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
}

//删除文件
- (void)deleteResumeFileBtn
{
    NSString *urlString = kshouzhijiURL(kShouzhijiURLStr, @"message.php?ac=attachment_del&");
    NSDictionary *paramter = nil;
    NSString *authId = [[NSUserDefaults standardUserDefaults] valueForKey:kAuthID];
    paramter = [NSDictionary dictionaryWithObjectsAndKeys:selectFile.attachment_id,@"attachment_id",authId,kAuthID, nil];
    urlString = [[NSString alloc] initWithFormat:@"%@%@=%@",urlString,kAuthID,authId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:selectFile.attachment_id forKey:@"attachment_id"];
    [request setPostValue:authId forKey:kAuthID];
    [request setRequestMethod:@"POST"];
    
    [request setCompletionBlock:^{
        NSLog(@"image----------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
        if (selectFile.fileItem == FileImage) {
            [_imageArray removeObject:selectFile];
            SDDataCache *cache = [SDDataCache sharedDataCache];
            [cache removeDataForKey:selectFile.fileRealName];
        }
        else if (selectFile.fileItem == FileSound) {
            
            [[NSFileManager defaultManager] removeItemAtPath:selectFile.openPath error:nil];
            [_soundArray removeObject:selectFile];
        }else {
            [_fileArray removeObject:selectFile];
        }
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self addFileInView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}

- (void)getFileFromServer
{
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:[selectFile.downloadPath lastPathComponent]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:selectFile.downloadPath];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        selectFile.openPath = path;
        [request.responseData writeToFile:path atomically:YES];
        [self openFile];
    }];
    [request setFailedBlock:^{
        alert.message = @"网络连接失败，请检查网络";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
    
}

- (void)openFile
{
    UIDocumentInteractionController *documentVc = [[UIDocumentInteractionController alloc]init];
    
    documentVc.URL = [NSURL fileURLWithPath:selectFile.openPath];
    documentVc.delegate = self;
    [documentVc presentPreviewAnimated:YES];
    
}


#pragma mark-------tablewView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 5;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        cell.accessoryView = nil;
    }
    
    More *m = [[_moreArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = m.moreName;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    [cell.contentView addSubview:label];
    label.text = [NSString stringWithFormat:@"不完整"];
    ResumeOperation *sr = [ResumeOperation defaultResume];
    if (indexPath.section ==2 && indexPath.row==4) {
        NSString *ste = [sr.resumeDictionary valueForKey:@"leve_waiyu"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==2 && indexPath.row==3) {
        NSString *ste = [sr.resumeDictionary valueForKey:@"leve_peixun"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==2 && indexPath.row==2)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"pingjia"];
        if (ste.length>0) {
            if ([ste isEqualToString:@"工作能力及自我评价(800字以内)"]) {
                label.text = [NSString stringWithFormat:@"不完整"];
            }else{
                label.text = [NSString stringWithFormat:@"完整"];
            }
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }
    else if (indexPath.section ==2 && indexPath.row==0)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"leve-jiben"];
        if (ste.length==2) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==1 && indexPath.row==0)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"jibenxinxi"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==1 && indexPath.row==1)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"education"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section ==1 && indexPath.row==2)
    {
        NSString *ste  = [sr.resumeDictionary valueForKey:@"expect"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
        
    }else if (indexPath.section ==2 && indexPath.row==1)
    {
        NSString *ste = [sr.resumeDictionary valueForKey:@"workExperience"];
        if (ste.length==2 ) {
            label.text = [NSString stringWithFormat:@"完整"];
        }else{
            label.text = [NSString stringWithFormat:@"不完整"];
        }
    }else if (indexPath.section==0 && indexPath.row==0){
        label.text= [NSString stringWithFormat:@"l"];
    }else if (indexPath.section==0 && indexPath.row==1){
        label.text= [NSString stringWithFormat:@"r"];
    }else if (indexPath.section==0 && indexPath.row==2){
        label.text= [NSString stringWithFormat:@"g"];
    }
    
    if (label.text.length>2) {
        label.textColor = [UIColor orangeColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0){
        return 150;
    }
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section==1)
	{
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,-5, tableView.bounds.size.width,25)];
        UILabel *labrl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, iPhone_width-20, 30)];
        labrl.backgroundColor =[UIColor clearColor];
        labrl.text = @"必填:填完后即可配合附件简历速投职位!";
        labrl.font = [UIFont fontWithName:Zhiti size:14];
        labrl.textColor = [UIColor darkGrayColor];
        [view addSubview:labrl];
		return view;
	}else if(section==2){
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,20)];
        UILabel *labrl1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, iPhone_width-20, 30)];
        labrl1.backgroundColor =[UIColor clearColor];
        labrl1.text = @"完善:完善信息后坐等企业主动联系您!";
        labrl1.font = [UIFont fontWithName:Zhiti size:14];
        labrl1.textColor = [UIColor darkGrayColor];
        [view addSubview:labrl1];
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        jibenxxViewController *jiben = [[jibenxxViewController alloc]init];
        [self.navigationController pushViewController:jiben animated:YES];
    }
    else if(indexPath.row == 1 && indexPath.section == 1)
    {
        jiaoyuxxViewController *jiaoyu = [[jiaoyuxxViewController alloc]init];
        [self.navigationController pushViewController:jiaoyu animated:YES];
    }else if(indexPath.row == 2 && indexPath.section == 1)
    {
        qiuzhiyxViewController *qiuzhi = [[qiuzhiyxViewController alloc]init];
        [self.navigationController pushViewController:qiuzhi animated:YES];
    }
    else if (indexPath.section == 2&& indexPath.row == 0)
    {
        jibenwansViewController *jiben = [[jibenwansViewController alloc]init];
        [self.navigationController pushViewController:jiben animated:YES];
    }else if (indexPath.section == 2&& indexPath.row == 1){
        jingliViewController *jingji = [[jingliViewController alloc]init];
        [self.navigationController pushViewController:jingji animated:YES];
    }
    else if (indexPath.section == 2&& indexPath.row == 2)
    {
        pingjiaViewController *pingjia = [[pingjiaViewController alloc]init];
        pingjia.deleat =self;
        [self.navigationController pushViewController:pingjia animated:YES];
    }
    else if (indexPath.section == 2&& indexPath.row == 3)
    {
        peixunViewController *peixun = [[peixunViewController alloc]init];
        [self.navigationController pushViewController:peixun animated:YES];
    }else if (indexPath.section == 2&& indexPath.row == 4)
    {
        waiyuViewController *waiyu = [[waiyuViewController alloc]init];
        [self.navigationController pushViewController:waiyu animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int num = ios7jj;
    if (scrollView.contentOffset.y<=0) {
        imgProfile.frame=CGRectMake(0+scrollView.contentOffset.y, 44+num+scrollView.contentOffset.y, 320-scrollView.contentOffset.y*2, 131-scrollView.contentOffset.y*2);
        myView.frame = CGRectMake(0, 44+num-scrollView.contentOffset.y,myView.frame.size.width,myView.frame.size.height );
    }else {
        CGRect f = imgProfile.frame;
        f.origin.y = -scrollView.contentOffset.y+44+num;
        imgProfile.frame = f;
        
        CGRect g =myView.frame;
        g.origin.y = -scrollView.contentOffset.y+44+num;
        myView.frame = g;
    }
    
}
#pragma mark  POHorizontalListDelegate

- (void) didSelectItem:(ListItem *)item {
    NSLog(@"Horizontal List Item %@ selected", item.imageTitle);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
