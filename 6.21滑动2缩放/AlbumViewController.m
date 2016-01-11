//
//  AlbumViewController.m
//  云端产品级适配版本
//
//  Created by 涂婉丽 on 15/12/30.
//  Copyright (c) 2015年 涂婉丽. All rights reserved.
//
//查看放大图片类
#import "AlbumViewController.h"
#import "PhotoView.h"
#define K_W [UIScreen mainScreen].bounds.size.width
#define K_H [UIScreen mainScreen].bounds.size.height
@interface AlbumViewController ()<UIScrollViewDelegate,PhotoViewDelegate>
{
    CGFloat lastScale;
    NSMutableArray *_subViewList;
    PhotoView *photoV;
    UIView *NavView;
}

@end

@implementation AlbumViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    lastScale = 1.0;
    self.view.backgroundColor = [UIColor blackColor];
    //自定义导航栏
    [self initScrollView];
    [self addLabels];
    [self setPicCurrentIndex:self.currentIndex];
    [self createNavBar];
}
- (void)createNavBar
{
    NavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, K_W, 64)];
    [self.view addSubview:NavView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:NavView.frame];
    [imageView setImage:[UIImage imageNamed:@"title.png"]];
    imageView.userInteractionEnabled = YES;
    [NavView addSubview:imageView];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setFrame:CGRectMake(10, 74/2-9, 37, 18)];
    [returnBtn setImage:[UIImage imageNamed:@"fanhui_white.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBefore) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:returnBtn];
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, K_W, 54)];
    [titleL setText:@"查看图片"];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont boldSystemFontOfSize:17];
    [titleL setTextColor:[UIColor whiteColor]];
    [NavView addSubview:titleL];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initScrollView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.center = self.view.center;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count*self.view.frame.size.width, 0);
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.scrollView];
    _subViewList = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.imgArr.count; i++) {
        [_subViewList addObject:[NSNull class]];
    }
}

-(void)addLabels{
    
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, K_H-50, K_W, 50)];
    self.sliderLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    self.sliderLabel.alpha = 0.7;
    self.sliderLabel.textColor = [UIColor whiteColor];
    self.sliderLabel.text = [NSString stringWithFormat:@"%ld/%lu",self.currentIndex+1,(unsigned long)self.imgArr.count];
    
    [self.sliderLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.sliderLabel];
}

-(void)setPicCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*currentIndex, 0);
    [self loadPhote:_currentIndex];
    [self loadPhote:_currentIndex+1];
    [self loadPhote:_currentIndex-1];
}

-(void)loadPhote:(NSInteger)index{
    if (index<0 || index >=self.imgArr.count) {
        return;
    }
    
    id currentPhotoView = [_subViewList objectAtIndex:index];
    if (![currentPhotoView isKindOfClass:[PhotoView class]]) {
        //url数组
        CGRect frame = CGRectMake(index*_scrollView.frame.size.width+5, -32, self.view.frame.size.width-10, self.view.frame.size.height);
        if (_isUrl) {
            photoV = [[PhotoView alloc] initWithFrame:frame withPhotoUrl:[self.imgArr objectAtIndex:index]];
        }
        else{
            photoV = [[PhotoView alloc] initWithFrame:frame withPhotoImage:[self.imgArr objectAtIndex:index]];
        }
        photoV.center = CGPointMake(self.view.center.x+index*self.view.frame.size.width, self.view.center.y-10);
        photoV.tag = index;
        photoV.delegate = self;
        [self.scrollView insertSubview:photoV atIndex:0];
        [_subViewList replaceObjectAtIndex:index withObject:photoV];
    }else{
        photoV = (PhotoView *)currentPhotoView;
    }
}

#pragma mark - PhotoViewDelegate
-(void)TapHiddenPhotoView:(NSInteger)alphaValue{
    //隐藏导航栏
    [UIView animateWithDuration:0.5 animations:^{
        
        [NavView setAlpha:alphaValue];
        [_sliderLabel setAlpha:alphaValue];
        if (alphaValue == 0) {
            if (NavView.center.y<0||_sliderLabel.center.y>K_H) {
                
            }else{
                
                [NavView setCenter:CGPointMake(NavView.center.x, NavView.center.y-70*(alphaValue+1))];
                [_sliderLabel setCenter:CGPointMake(_sliderLabel.center.x, _sliderLabel.center.y+70*(alphaValue+1))];
            }
        }else{
            if (NavView.center.y>30||_sliderLabel.center.y<K_H-70) {
                
            }else{
                
                [NavView setCenter:CGPointMake(NavView.center.x, NavView.center.y+70*alphaValue)];
                [_sliderLabel setCenter:CGPointMake(_sliderLabel.center.x, _sliderLabel.center.y-70*alphaValue)];
            }
        }
    }];
}

int pre=0;
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int i = scrollView.contentOffset.x/self.view.frame.size.width;
    [self loadPhote:i-1];
    [self loadPhote:i];
    [self loadPhote:i+1];
    PhotoView *imageScro=(PhotoView *)[scrollView viewWithTag:pre];
    if(i!=pre)
    {
        [imageScro setZoomScale:1.0];
    }
    pre=i;
    self.sliderLabel.text = [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)self.imgArr.count];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)returnBefore
{
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
