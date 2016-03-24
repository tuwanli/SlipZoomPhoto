//
//  PictureVC.m
//  6.21滑动2缩放
//
//  Created by 涂婉丽 on 15/12/17.
//  Copyright © 2015年 lovena. All rights reserved.
//

#import "PictureVC.h"
#import "AlbumViewController.h"
#import "LookImageView.h"
#define K_W [UIScreen mainScreen].bounds.size.width
#define K_H [UIScreen mainScreen].bounds.size.height

@interface PictureVC ()
{

    LookImageView *lookImage;
    NSMutableArray *imageViewArr;
}
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,copy)NSString *zoomImageType;
@end

@implementation PictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FirstController";
    self.view.backgroundColor = [UIColor whiteColor];
    _imageArray = [[NSMutableArray alloc]init];
    lookImage = [[LookImageView alloc]init];
    imageViewArr = [[NSMutableArray alloc]init];
    [self creatData];
    [self createUI];
//    _zoomImageType = @"slip";
    _zoomImageType = @"zoom";
    
}
- (void)creatData
{
    for (int i=0; i<9; i++) {
        NSString *str = [NSString stringWithFormat:@"%d.jpg", i+1];
        UIImage *image = [UIImage imageNamed:str];
        [_imageArray addObject:image];
    }
}
- (void)createUI
{

    UIView *pictureView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, K_W, 400)];
    pictureView.backgroundColor = [UIColor greenColor];
//    pictureView.center = self.view.center;
    [self.view addSubview:pictureView];
    for (int i=0; i<_imageArray.count; i++) {

        NSInteger row = i/4;
        NSInteger col = i%4;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+col*((K_W-50)/4+10), 10+row*((K_W-50)/4+10),(K_W-50)/4, (K_W-50)/4)];
        [imageViewArr addObject:imageView];
        imageView.backgroundColor = [UIColor redColor];
        [imageView setImage:_imageArray[i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomImage:)];
        [imageView addGestureRecognizer:tap];
        [pictureView addSubview:imageView];
    }
}
- (void)zoomImage:(UITapGestureRecognizer *)tap
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    UIImageView *imageView = (UIImageView *)tap.view;
//    NSLog(@"%d",imageView.tag);
    for (NSInteger j = imageView.tag; j<_imageArray.count; j++) {
        [array addObject:_imageArray[j]];
    }
    if ([_zoomImageType isEqualToString:@"slip"]) {
        
        
        AlbumViewController *zoomVC = [[AlbumViewController alloc]init];
        zoomVC.imgArr = array;
        [self.navigationController pushViewController:zoomVC animated:YES];

    }else if([_zoomImageType isEqualToString:@"zoom"])
    {
        [lookImage showImage:array imageView:imageView imageViewArr:imageViewArr superView:self.view];
    
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
