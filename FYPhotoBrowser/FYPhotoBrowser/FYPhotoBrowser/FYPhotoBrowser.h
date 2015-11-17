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


@protocol FYPhotoBrowserDelegate <NSObject>

@optional
/**
 *  滚动到第几张图
 *
 *  @param index 图的索引
 */
-(void)scrollToPhotoIndex:(NSNumber*)index ;
/**
 *  点击了第几张图
 *
 *  @param index 图的索引
 */
-(void)clickPhotoIndex:(NSNumber *)index;

@end

@interface FYPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray * imagesUrlArray;
@property (nonatomic,assign) NSInteger index;
//默认图
@property (nonatomic,strong) NSArray * imagesArray;

@property (nonatomic,assign) BOOL isFromNet;
@property (nonatomic,weak) id<FYPhotoBrowserDelegate> delegate;

//字符串imageUrl数组  index是点击的第几个 从0开始
-(instancetype)initWithImageUrlString:(NSArray *)urlArray atIndex:(NSInteger)index FromView:(UIView *)fromView;
//点击的哪个图片
- (void)showWithView:(UIView *)view;
@end
