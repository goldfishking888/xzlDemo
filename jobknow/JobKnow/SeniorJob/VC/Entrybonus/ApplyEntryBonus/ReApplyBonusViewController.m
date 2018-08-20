//
//  ReApplyBonusViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/9/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ReApplyBonusViewController.h"
#import "MBProgressHUD.h"

#import "ASIDownloadCache.h"
#import "GTMBase64.h"//图片转为base64
#import "CommonFunc.h"
#import "JSONKit.h"
#import "UIButton+WebCache.h"//btn缓存图片
#import "AppDelegate.h"
@interface ReApplyBonusViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendRequest>
{
    UIButton * ImageBtn;
    UITextView * textView;
    UIImage * imageSuccess;
     MBProgressHUD *loadView;
}
@end

@implementation ReApplyBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"提交入职证明材料"];
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    [self createUI];
    self.view.backgroundColor = RGBA(243, 243, 243, 1);
    // Do any additional setup after loading the view.
}
-(void)createUI
{
    ImageBtn = [MyControl createButtonFrame:CGRectMake(self.view.frame.size.width / 2 - 35,44 + ios7jj + 20, 70, 70) bgImageName:@"url_image_loading" image:nil title:nil method:@selector(addPhotoClick:) target:self];
    [self.view addSubview:ImageBtn];
    UILabel * nameLabel = [MyControl createLableFrame:CGRectMake(ImageBtn.frame.origin.x, ImageBtn.frame.origin.y + ImageBtn.frame.size.height + 5, 100, 12) font:12 title:@"点击添加图片"];
    nameLabel.textColor = RGBA(110, 110, 110, 1);
    [self.view addSubview:nameLabel];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(15, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, self.view.frame.size.width - 30, 100)];
    textView.delegate = self;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.text = @"说明(100字以内)";
    textView.textColor = RGBA(110, 110, 110, 1);
    [self.view addSubview:textView];
    
    UIButton * tijiaoBtn = [MyControl createButtonFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y + textView.frame.size.height + 10, self.view.frame.size.width - 30, 35) bgImageName:nil image:nil title:@"提交入职证明" method:@selector(tijiaoBtnClick) target:self];
    tijiaoBtn.backgroundColor = [UIColor orangeColor];
    tijiaoBtn.layer.cornerRadius = 4;
    tijiaoBtn.layer.masksToBounds = YES;
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:tijiaoBtn];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)addPhotoClick:(UIButton *)sender
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"本地上传", nil];
    [sheet showInView:self.view];
}
-(void)textViewDidBeginEditing:(UITextView *)TextView
{
    textView.text = @"";
}
-(void)tijiaoBtnClick
{
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString *str = [st valueForKey:@"UserName"];
    if ([textView.text isEqualToString:@"说明(100字以内)"]) {
        textView.text = @"";
    }
    if (imageSuccess != nil && textView.text.length > 0 && ![textView.text isEqualToString:@"说明(100字以内)"]) {
        if ([textView.text isEqualToString:@"说明(100字以内)"]) {
            textView.text = @"";
        }
        [self uploadPath2:imageSuccess name:[NSString stringWithFormat:@"%@_ruzhi.png",str]];
    }
    else
    {
        ghostView.message=@"信息不完善";
        [ghostView show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"拍照上传");
        [self takePhotos];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"本地上传");
        [self callPhotos];
    }
    else if (buttonIndex == 2)
    {
        NSLog(@"取消");
    }
}
#pragma mark - 拍照
-(void)takePhotos
{//拍照
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
    vc.delegate = self;
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark - 打开相册
-(void)callPhotos
{
    UIImagePickerController * vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = YES;
    //vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        //
    }];
}
#pragma mark - Picker的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //头像保存本地
//    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//    NSString *str = [st valueForKey:@"UserName"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    NSString*finame = [NSString stringWithFormat:@"_ruzhi%@.png",str];
//    SDDataCache *imageCache = [SDDataCache sharedDataCache];
//    [imageCache storeData:imageData forKey:finame];
//    [_pathCover setAvatarImage:image];
    //上传头像
//    [self uploadPath2:image name:[NSString stringWithFormat:@"%@_ruzhi.png",str]];
    imageSuccess = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [ImageBtn setBackgroundImage:imageSuccess forState:UIControlStateNormal];

}
//上传头像
- (void)uploadPath2:(UIImage *)image name:(NSString *)name
{
    NetWorkConnection *net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",self.payID,@"id",textView.text,@"desc", nil];
    //Filedata
    //[net send2ToServerWithImage:image imageName:name param:params];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/senior/up_certify?"];
    [net send_HRIcon_ToServerWithImage:image imageName:name param:params withURLStr:urlStr];
}

- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *requestDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"shang传头像_______%@",requestDic);
    
    NSNumber * state = [requestDic valueForKey:@"error"];
    if(!requestDic){
        [loadView hide:YES];
        return;
    }
    
    if ([state boolValue] == 0) {
        //[self uploadResult:requestDic];
        NSString *fileName = [NSString stringWithFormat:@"%@",[requestDic valueForKey:@"fileName"]];
        [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:@"headerIdentifierUrl"];
        [[SDImageCache sharedImageCache] storeImage:imageSuccess forKey:fileName toDisk:YES];
        
        [ImageBtn setBackgroundImage:imageSuccess forState:UIControlStateNormal];
        [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        ghostView.message=@"提交成功,请耐心等待审核结果";
        [ghostView show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)receiveDataFail:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)requestTimeOut
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
