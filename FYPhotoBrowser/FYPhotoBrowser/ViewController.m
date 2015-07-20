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
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) ;
     table =[[UITableView alloc]initWithFrame:frame];
    [self.view addSubview:table];
    table.delegate = self ;
    table.dataSource = self ;
    dataArray = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                    @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                    @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                    @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                    @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
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
        [im  sd_setImageWithURL:[NSURL URLWithString:dataArray[i]] placeholderImage:nil];
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
    [photoWeb showWithView:tap.view];
    
}

@end
