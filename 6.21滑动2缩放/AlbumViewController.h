//
//  AlbumViewController.h
//  云端产品级适配版本
//
//  Created by 涂婉丽 on 15/12/30.
//  Copyright (c) 2015年 涂婉丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController

/**
 *  接收图片数组，数组类型可以是url数组，image数组
 */
@property(nonatomic, strong) NSMutableArray *imgArr;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UILabel *sliderLabel;
@property(nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,copy)NSString *path;
@property (nonatomic,assign)BOOL isUrl;
//@property (nonatomic,copy)NSString *titleLable;
@end
