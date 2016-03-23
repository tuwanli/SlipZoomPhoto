//
//  LookImageView.m
//  sunyunfei
//
//  Created by 涂婉丽 on 16/3/22.
//  Copyright © 2016年 涂婉丽. All rights reserved.
//

#import "LookImageView.h"
NSInteger tag;
#define K_W [UIScreen mainScreen].bounds.size.width
#define K_H [UIScreen mainScreen].bounds.size.height
@implementation LookImageView
-(void)showImage:(NSArray *)imageArr imageView:(UIImageView *)showImageView imageViewArr:(NSMutableArray *)ImageViews{
    _framArr = [[NSMutableArray alloc]init];
    _imageViewArr = [[NSMutableArray alloc]init];
     UIWindow *window=[UIApplication sharedApplication].keyWindow;
    NSLog(@"%@",imageArr);
    _imageArr = imageArr;
    tag = showImageView.tag;
    _imageViewArr = ImageViews;
    for (UIImageView *newImageView in _imageViewArr) {
        CGRect newfram = [newImageView convertRect:newImageView.bounds toView:window];
        NSString *str = NSStringFromCGRect(newfram);
        [_framArr addObject:str];
    }

    //创建一个scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    scrollView.delegate = self;
    _oldFram=[showImageView convertRect:showImageView.bounds toView:window];
    NSLog(@"+++++++%@",NSStringFromCGRect(_oldFram));
    scrollView.backgroundColor=[UIColor blackColor];
    scrollView.alpha=0;
    scrollView.pagingEnabled = YES;
    [window addSubview:scrollView];
    for (int i=0; i<imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_oldFram];
        //        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setImage:imageArr[i]];
        imageView.tag = 10+i;
        [scrollView addSubview:imageView];
        scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*imageArr.count, 0);
        
        UIImage *image=imageView.image;
        if (i==0) {
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame=CGRectMake(10,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width-20, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
                //        backgroundView.alpha=1;
                scrollView.alpha=1;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            
            
            imageView.frame=CGRectMake(10+i*[UIScreen mainScreen].bounds.size.width,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width-20, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            //        backgroundView.alpha=1;
            scrollView.alpha=1;
            
            
        }
        
        
    }

    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    //    [backgroundView addGestureRecognizer: tap];
    [scrollView addGestureRecognizer: tap];
    
    
}

-(void)hideImage:(UITapGestureRecognizer*)tap
{
    //    UIView *backgroundView=tap.view;
    UIScrollView *backgroundView=(UIScrollView *)tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:10+_num];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=_oldFram;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    _num = fabs((scrollView.contentOffset.x)/scrollView.frame.size.width);
    NSString *oldstr = NSStringFromCGRect(_oldFram);
    NSLog(@"%@",_framArr);
    for (int i = 0; i<_framArr.count; i++) {
        if ([oldstr isEqualToString:_framArr[i]]) {
            _oldFram = CGRectFromString(_framArr[_num+tag]);
           
        }
    }

}

@end
