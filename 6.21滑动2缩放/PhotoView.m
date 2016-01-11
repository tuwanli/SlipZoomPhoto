//
//  PhotoView.m
//
//  Created by 涂婉丽 on 15/12/30.
//  Copyright (c) 2015年 涂婉丽. All rights reserved.
//

#import "PhotoView.h"
#import "UIImageView+WebCache.h"

@interface PhotoView ()<UIScrollViewDelegate>
{
    
    BOOL ishidden;
}

@end

@implementation PhotoView

-(id)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)photoUrl{
    self = [super initWithFrame:frame];
    if (self) {
        //添加scrollView
        [self createScrollView];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"loading.png"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            NSLog(@"图片加载完成");
            
        }];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withPhotoImage:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        //添加scrollView
        [self createScrollView];
        [self.imageView setImage:image];
    }
    return self;
}
- (void)createScrollView
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 3;
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    //添加图片
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.imageView setUserInteractionEnabled:YES];
    [_scrollView addSubview:self.imageView];
    
    //添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;//需要点两下
    twoFingerTap.numberOfTouchesRequired = 2;//需要两个手指touch
    
    [self.imageView addGestureRecognizer:singleTap];
    [self.imageView addGestureRecognizer:doubleTap];
    [self.imageView addGestureRecognizer:twoFingerTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];//如果双击了，则不响应单击事件
    
    [_scrollView setZoomScale:1];
}
#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}


#pragma mark - 图片的点击，touch事件
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer.numberOfTapsRequired == 1) {
        if (ishidden) {
            [self.delegate TapHiddenPhotoView:1.0];
            ishidden = NO;
        }else{
            
            [self.delegate TapHiddenPhotoView:0.0];
            ishidden = YES;
        }
        
    }
}

-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if(_scrollView.zoomScale == 1){
            float newScale = [_scrollView zoomScale] *2;
            _zoomScale = newScale;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
            [self.delegate TapHiddenPhotoView:0.0];
            
        }else{
            float newScale = [_scrollView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            _zoomScale = newScale;
            [_scrollView zoomToRect:zoomRect animated:YES];
            [self.delegate TapHiddenPhotoView:1.0];
        }
        
    }
}

-(void)handleTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer{
    
    float newScale = [_scrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}


#pragma mark - 缩放大小获取方法
-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [_scrollView frame].size.height/scale;
    zoomRect.size.width = [_scrollView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    [_scrollView setZoomScale:zoomScale animated:YES];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
