//
//  ViewController.m
//  weixin图片放大
//
//  Created by Charlie on 15/7/17.
//  Copyright (c) 2015年 Swift. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray * dataArray ;
    UITableView * table;
}
@property (nonatomic,strong) UIButton * btn;
@property (nonatomic,strong) UIView * bgview;
@end

@implementation ViewController

-(void)btnClick:(UIButton * )sender
{
   //http://img5.imgtn.bdimg.com/it/u=1604509887,3331516596&fm=21&gp=0.jpg
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) ;
     table =[[UITableView alloc]initWithFrame:frame];
    [self.view addSubview:table];
    table.delegate = self ;
    table.dataSource = self ;
    dataArray = @[@"http://pic46.nipic.com/20140825/2531170_154743881000_2.jpg",
                    @"http://img3.3lian.com/2006/027/04/050.jpg",
                    @"http://cdn.duitang.com/uploads/item/201409/01/20140901084048_RJWPs.thumb.224_0.jpeg",
                    @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                    @"http://photo.l99.com/bigger/21/1359554344075_z6qfc5.jpg",
                    @"http://ww4.sinaimg.cn/thumbnail/9e9cb0c9jw1ep7nlyu8waj20c80kptae.jpg"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc]init];
    for (int i = 0; i < 6; i ++) {
        FYImageView * im =[[FYImageView alloc]initWithFrame:CGRectMake((130 * (i % 3) )+ 30, 10 + 120 * (i / 3), 100, 80)];
        [im addTarget:self action:@selector(cellClick:)];
         im.contentMode = UIViewContentModeScaleAspectFit ;
        [im  sd_setImageWithURL:[NSURL URLWithString:dataArray[i]] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
           
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        im.tag = i ;
        [cell.contentView addSubview:im];
        
        
        
    }
    return cell ;
}
-(void)cellClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag ;
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    FYPhotoBrowser * photoWeb = [[FYPhotoBrowser alloc]initWithImageUrlString:dataArray atIndex:index FromView:cell.contentView];
    photoWeb.isFromNet = YES ;
    [photoWeb showWithView:tap.view];
    
}

@end
