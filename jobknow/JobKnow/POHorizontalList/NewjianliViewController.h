//
//  NewjianliViewController.h
//  JobKnow
//
//  Created by Zuo on 14-2-18.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "pingjiaViewController.h"
#import "ResumeFile.h"
#import "FileButton.h"
@interface NewjianliViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,miaosuDeleat,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UITableView *myTableView;
    UIImageView *imgProfile;  //大树背景
    UIView *myView;           //阴影
    UIImageView *headImg;     //头像
    ResumeFile *selectFile;//选择的文件信息
    NSInteger selectTag;//选择的btn的tag值
}
@property (nonatomic,retain)NSMutableArray *moreArray;  //表头数组
@property (nonatomic, assign) BOOL isHead;   //判断上传头像和图片
@property (nonatomic, strong) NSMutableArray *soundArray;//语音数组
@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, strong) NSMutableArray *fileArray;//文档数组
@end
