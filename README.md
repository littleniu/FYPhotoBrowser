# FYPhotoBrowser

用法很简答的：

           FYImageView * im =[[FYImageView alloc]initWithFrame:CGRectMake((130 * (i % 3) )+ 30, 10 + 120 * (i / 3), 100, 80)];

           [im addTarget:self action:@selector(cellClick:)];//相当于button





然后呢 ：


dataArray 是imageUrlArray ，index 是点击图片的索引，FromView 是点击图片的父视图，tap.view 是图片本身。


                       FYPhotoBrowser * photoWeb = [[FYPhotoBrowser alloc]initWithImageUrlString:dataArray atIndex:index FromView:cell.contentView];
                       photo.isFromNet = YES;//有本地image和网络下载两种情况
                        [photoWeb showWithView:tap.view];



博客地址：http://blog.csdn.net/ios_and_swift
