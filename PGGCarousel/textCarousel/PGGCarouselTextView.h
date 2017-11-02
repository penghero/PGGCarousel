//
//  PGGCarouselTextView.h
//  PGGCarousel
//
//  Created by 陈鹏 on 2017/10/31.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//GitHub 地址 https://github.com/penghero/PGGCarousel.git

#import <UIKit/UIKit.h>
@class PGGCarouselTextView;
/**
 文字轮播类
 */
typedef NS_ENUM(NSInteger,PGGScrollViewStyle) {
    PGGScrollViewStyleSingle,
    PGGScrollViewStyleDouble,
};
@protocol PGGCarouselTextViewDelegate <NSObject>
//点击响应代理方法
- (void)pggScrollView:(PGGCarouselTextView *)ScrollView didSelectedItemAtIndex:(NSInteger)index;
@end

@interface PGGCarouselTextView : UIView
#pragma mark - - - 公共 API
/** delegate */
@property (nonatomic, weak) id<PGGCarouselTextViewDelegate> delegate;
/** 默认 PGGScrollViewStyleSingle 样式 */
@property (nonatomic, assign) PGGScrollViewStyle ScrollViewStyle;
/** 滚动时间间隔，默认为2 */
@property (nonatomic, assign) CFTimeInterval scrollTimeInterval;
/** 标题字体字号，默认为13号字体 */
@property (nonatomic, strong) UIFont *titleFont;

#pragma mark - - - PGGScrollViewStyleSingle 样式下的 API
/** 左边标志图片数组 */
@property (nonatomic, strong) NSArray *signImages;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 标题字体颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 标题文字位置，默认为 NSTextAlignmentLeft，仅仅针对标题起作用 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/**右边背景图片数组 */
@property (nonatomic,strong) NSArray *singleRightImages;
#pragma mark - - - PGGScrollViewStyleDouble 样式下的 API
/** 顶部左边标志图片数组 */
@property (nonatomic, strong) NSArray *topSignImages;
/** 顶部标题数组 */
@property (nonatomic, strong) NSArray *topTitles;
/** 底部左边标志图片数组 */
@property (nonatomic, strong) NSArray *bottomSignImages;
/** 底部标题数组 */
@property (nonatomic, strong) NSArray *bottomTitles;
/** 顶部标题字体颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *topTitleColor;
/** 底部标题字体颜色，默认为黑色 */
@property (nonatomic, strong) UIColor *bottomTitleColor;
/**右边背景图片数组 */
@property (nonatomic,strong) NSArray *doubleRightImages;
@end

#pragma mark - - - PGGScrollViewSingleCell
@interface PGGScrollViewSingleCell: UICollectionViewCell
@property (nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

#pragma mark - - - PGGScrollViewDoubleCell
@interface PGGScrollViewDoubleCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *topSignImageView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIImageView *bottomSignImageView;
@property (nonatomic, strong) UILabel *bottomLabel;
@end
