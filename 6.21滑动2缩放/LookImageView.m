//
//  LookImageView.m
//  sunyunfei
//
//  Created by 涂婉丽 on 16/3/22.
//  Copyright © 2016年 涂婉丽. All rights reserved.
//

#import "LookImageView.h"
#import "AppDelegate.h"
//NSInteger tag;

#define K_W [UIScreen mainScreen].bounds.size.width
#define K_H [UIScreen mainScreen].bounds.size.height

@interface LookImageView()

@property (nonatomic,assign) NSInteger num;
@property (nonatomic,assign) CGRect oldFram;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic,strong) NSMutableArray *imageViewArr;
@property (nonatomic,strong) NSMutableArray *framArr;
@property (nonatomic,strong) UIView *superView;

@end

@implementation LookImageView

-(void)showImage:(NSArray *)imageArr imageView:(UIImageView *)showImageView imageViewArr:(NSMutableArray *)ImageViews superView:(UIView *)superView{
    
    self.superView = superView;
    _framArr      = [[NSMutableArray alloc]init];
    _imageViewArr = [[NSMutableArray alloc]init];
    
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _imageArr = imageArr;
    _imageViewArr = ImageViews;
    
    // 没必要将所有的ImageView的frame保存起来，只将当前以及之后的imageview的frame存起来
    NSInteger index = ImageViews.count - imageArr.count;
    
    for(int i = 0; i < imageArr.count; i++){
        UIImageView *newImageView = ImageViews[index + i];
        CGRect newfram = [newImageView convertRect:newImageView.bounds toView:window];
        NSString *str = NSStringFromCGRect(newfram);
        [_framArr addObject:str];
    }

    //创建一个scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    scrollView.delegate = self;
    _oldFram = [showImageView convertRect:showImageView.bounds toView:window];
//    NSLog(@"+++++++%@",NSStringFromCGRect(_oldFram));
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.alpha = 0;
    scrollView.pagingEnabled = YES;
    [window addSubview:scrollView];
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * imageArr.count, 0);
    
    for (int i = 0; i < imageArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_oldFram];
        [imageView setImage:imageArr[i]];
        imageView.tag = 10 + i;
        [scrollView addSubview:imageView];

        UIImage *image = imageView.image;
        
        if (i == 0) {

            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame=CGRectMake(10,
                                           (K_H - image.size.height * K_W / image.size.width) / 2,
                                           K_W - 20,
                                           image.size.height * K_W / image.size.width);
                scrollView.alpha=1;
            } completion:^(BOOL finished) { }];
        }else{

            imageView.frame = CGRectMake(10 + i * K_W,
                                         (K_H - image.size.height * K_W / image.size.width) / 2,
                                         K_W-20,
                                         image.size.height * K_W / image.size.width);
            scrollView.alpha=1;
        }
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    //    [backgroundView addGestureRecognizer: tap];
    [scrollView addGestureRecognizer: tap];
}

-(void)hideImage:(UITapGestureRecognizer*)tap
{
    UIScrollView *backgroundView = (UIScrollView *)tap.view;
    
    UIImageView *imageView = (UIImageView*)[backgroundView viewWithTag:10 + _num];
//    CGRect rect =  [self.superView convertRect:imageView.frame fromView:backgroundView];
    CGRect rect =  [backgroundView convertRect:_oldFram fromView:self.superView];

    [UIView animateWithDuration:2 animations:^{
        imageView.frame = rect;
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        _num = 0;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _num = fabs((scrollView.contentOffset.x) / scrollView.frame.size.width);
    _oldFram = CGRectFromString(_framArr[_num]);
}

@end
