//
//  LookImageView.h
//  sunyunfei
//
//  Created by 涂婉丽 on 16/3/22.
//  Copyright © 2016年 涂婉丽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <math.h>

@interface LookImageView : NSObject<UIScrollViewDelegate>


-(void)showImage:(NSArray *)imageArr imageView:(UIImageView *)showImageView imageViewArr:(NSMutableArray *)ImageViews superView:(UIView *) superView;

@end
