//
//  PhotoView.h
//
//  Created by 涂婉丽 on 15/12/30.
//  Copyright (c) 2015年 涂婉丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewDelegate <NSObject>


-(void)TapHiddenPhotoView:(NSInteger)alphaValue;

@end

@interface PhotoView : UIView

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, assign) id<PhotoViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)photoUrl;

-(id)initWithFrame:(CGRect)frame withPhotoImage:(UIImage *)image;
@property (nonatomic,assign)BOOL isUrl;
@property (nonatomic,assign)CGFloat zoomScale;
@property (nonatomic,retain)UIScrollView *scrollView;
@end
