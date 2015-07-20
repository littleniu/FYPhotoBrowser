//
//  FYPhotoBrowser.h
//  weixin图片放大
//
//  Created by Charlie on 15/7/17.
//  Copyright (c) 2015年 Swift. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "FYPhoto.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds
#define kkeyWindow [UIApplication sharedApplication].keyWindow


@interface FYPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray * array;
@property (nonatomic,assign) NSInteger index;

//字符串imageUrl数组  index是点击的第几个 从0开始
-(instancetype)initWithImageUrlString:(NSArray *)urlArray atIndex:(NSInteger)index FromView:(UIView *)fromView;
//点击的哪个图片
- (void)showWithView:(UIView *)view;
@end
