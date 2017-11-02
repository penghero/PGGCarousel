//
//  PGGCarouselView.h
//  PGGCarousel
//
//  Created by 陈鹏 on 2017/10/31.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//
/*
 
 该轮播是基于collectionView进行的封装
 原理：
 是几个collectionView，至于无限轮播，很简单，只需要你的轮播数组给collectionView赋值的时候乘以一个较大的数字即可（例如100），collectionView本身处理了重用等一系列问题。
 */
#import <UIKit/UIKit.h>
@class PGGCarouselView;
/**
 图片轮播类
 */

@protocol PGGCarouselDelegate <NSObject>
@optional
//点击选中轮播图片的响应函数
- (void)PGGCarouseScrollView:(PGGCarouselView *)CarouseView didSelectAtIndex:(NSInteger )index;
@end

@interface PGGCarouselView : UIView
#pragma mark - 公开的API
@property (nonatomic, assign) CFTimeInterval TimerInterval;//轮播间隔 （默认两秒）
@property (nonatomic, weak) id<PGGCarouselDelegate> delegate;//代理 需要点击响应则设置代理

//带标语的初始化方法
+ (instancetype)PGGCarouseScrollViewWithFrame:(CGRect)frame imgsData:(NSArray *)imgsData titlesData:(NSArray *)titlesData;
//不带标语的初始化方法
+ (instancetype)PGGCarouseScrollViewWithFrame:(CGRect)frame imgsData:(NSArray *)imgsData;

@end


#pragma mark - PGGCollectionViewCell
@interface PGGCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@end


