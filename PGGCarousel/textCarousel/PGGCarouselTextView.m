//
//  PGGCarouselTextView.m
//  PGGCarousel
//
//  Created by 陈鹏 on 2017/10/31.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//GitHub 地址 https://github.com/penghero/PGGCarousel.git

#import "PGGCarouselTextView.h"
static NSInteger const advertScrollViewTitleFont = 13;
@interface PGGCarouselTextView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;//布局方向
@property (nonatomic, strong) UICollectionView *collectionView;//显示主视图
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, strong) NSArray *titleArr;//单标题
@property (nonatomic, strong) NSArray *imageArr;//单标识图片
@property (nonatomic, strong) NSArray *bottomImageArr;//双标题
@property (nonatomic, strong) NSArray *bottomTitleArr;//双标题数组

@end

@implementation PGGCarouselTextView

static NSInteger const ScrollViewMaxSections = 500;
static NSString *const ScrollViewSingelCell = @"PGGScrollViewSingleCell";
static NSString *const ScrollViewDoubleCell = @"PGGScrollViewDoubleCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
    [self setupSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initialization];
        [self setupSubviews];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self removeTimer];
    }
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)initialization {
    _scrollTimeInterval = 2;
    [self addTimer];
    _ScrollViewStyle = PGGScrollViewStyleSingle;
}

- (void)setupSubviews {
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[PGGScrollViewSingleCell class] forCellWithReuseIdentifier:ScrollViewSingelCell];
    }
    return _collectionView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _collectionView.frame = self.bounds;
    if (self.titleArr.count > 1) {
        [self defaultSelectedScetion];
    }
}

- (void)defaultSelectedScetion {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0.5 * ScrollViewMaxSections] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

#pragma mark - - - UICollectionView 的 dataSource、delegate方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return ScrollViewMaxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ScrollViewStyle == PGGScrollViewStyleDouble) {
        PGGScrollViewDoubleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScrollViewDoubleCell forIndexPath:indexPath];
        NSString *topImagePath = self.imageArr[indexPath.item];
            //        if ([topImagePath hasPrefix:@"http"]) {
            //            [cell.topSignImageView sd_setImageWithURL:[NSURL URLWithString:topImagePath]];
            //
            //        } else {
        cell.topSignImageView.image = [UIImage imageNamed:topImagePath];
            //        }
        cell.topLabel.text = self.titleArr[indexPath.item];
        
        NSString *imagePath = self.bottomImageArr[indexPath.item];
            //        if ([imagePath hasPrefix:@"http"]) {
            //            [cell.bottomSignImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            //
            //        } else {
        cell.bottomSignImageView.image = [UIImage imageNamed:imagePath];
            //        }
        cell.bottomLabel.text = self.bottomTitleArr[indexPath.item];
        
        if (self.titleFont) {
            cell.topLabel.font = self.titleFont;
            cell.bottomLabel.font = self.titleFont;
        }
        
        if (self.topTitleColor) {
            cell.topLabel.textColor = self.topTitleColor;
        }
        if (self.bottomTitleColor) {
            cell.bottomLabel.textColor = self.bottomTitleColor;
        }
        return cell;
        
    } else {
        PGGScrollViewSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ScrollViewSingelCell forIndexPath:indexPath];
        NSString *imagePath = self.imageArr[indexPath.item];
            //        if ([imagePath hasPrefix:@"http"]) {
            //            [cell.signImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            //
            //        } else {
        cell.signImageView.image = [UIImage imageNamed:imagePath];
            //        }
        
        cell.titleLabel.text = self.titleArr[indexPath.item];
        if (self.textAlignment) {
            cell.titleLabel.textAlignment = self.textAlignment;
        }
        if (self.titleFont) {
            cell.titleLabel.font = self.titleFont;
        }
        if (self.titleColor) {
            cell.titleLabel.textColor = self.titleColor;
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pggScrollView:didSelectedItemAtIndex:)]) {
        [self.delegate pggScrollView:self didSelectedItemAtIndex:indexPath.item];
    }
}

#pragma mark - - - NSTimer
- (void)addTimer {
    [self removeTimer];
    self.timer = [NSTimer timerWithTimeInterval:self.scrollTimeInterval target:self selector:@selector(beginUpdateUI) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)beginUpdateUI {
    if (self.titleArr.count == 0) return;
        // 1、当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
        // 马上显示回最中间那组的数据
    NSIndexPath *resetCurrentIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:0.5 * ScrollViewMaxSections];
    [self.collectionView scrollToItemAtIndexPath:resetCurrentIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        // 2、计算出下一个需要展示的位置
    NSInteger nextItem = resetCurrentIndexPath.item + 1;
    NSInteger nextSection = resetCurrentIndexPath.section;
    if (nextItem == self.titleArr.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
        // 3、通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

#pragma mark - - - setting
- (void)setScrollViewStyle:(PGGScrollViewStyle)ScrollViewStyle {
    _ScrollViewStyle = ScrollViewStyle;
    if (ScrollViewStyle == PGGScrollViewStyleDouble) {
        _ScrollViewStyle = PGGScrollViewStyleDouble;
        [_collectionView registerClass:[PGGScrollViewDoubleCell class] forCellWithReuseIdentifier:ScrollViewDoubleCell];
    }
}

- (void)setSignImages:(NSArray *)signImages {
    _signImages = signImages;
    if (signImages) {
        self.imageArr = [NSArray arrayWithArray:signImages];
    }
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    if (titles.count > 1) {
        [self addTimer];
    } else {
        [self removeTimer];
    }
    self.titleArr = [NSArray arrayWithArray:titles];
    [self.collectionView reloadData];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
}

- (void)setTopSignImages:(NSArray *)topSignImages {
    _topSignImages = topSignImages;
    if (topSignImages) {
        self.imageArr = [NSArray arrayWithArray:topSignImages];
    }
}

- (void)setTopTitles:(NSArray *)topTitles {
    _topTitles = topTitles;
    if (topTitles.count > 1) {
        [self addTimer];
    } else {
        [self removeTimer];
    }
    self.titleArr = [NSArray arrayWithArray:topTitles];
    [self.collectionView reloadData];
}

- (void)setBottomSignImages:(NSArray *)bottomSignImages {
    _bottomSignImages = bottomSignImages;
    if (bottomSignImages) {
        self.bottomImageArr = [NSArray arrayWithArray:bottomSignImages];
    }
}

- (void)setBottomTitles:(NSArray *)bottomTitles {
    _bottomTitles = bottomTitles;
    if (bottomTitles) {
        self.bottomTitleArr = [NSArray arrayWithArray:bottomTitles];
    }
}

- (void)setScrollTimeInterval:(CFTimeInterval)scrollTimeInterval {
    _scrollTimeInterval = scrollTimeInterval;
    if (scrollTimeInterval) {
        [self addTimer];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface PGGScrollViewSingleCell()

@end
@implementation PGGScrollViewSingleCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.signImageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spacing = 5;
    CGFloat signImageViewW = self.signImageView.image.size.width;
    CGFloat signImageViewH = self.signImageView.image.size.height;
    CGFloat signImageViewX = 0;
    CGFloat signImageViewY = 0;
    self.signImageView.frame = CGRectMake(signImageViewX, signImageViewY, signImageViewW, signImageViewH);
    CGFloat labelX = 0;
    if (self.signImageView.image == nil) {
        labelX = 0;
    } else {
        labelX = CGRectGetMaxX(self.signImageView.frame) + 0.5 * spacing;
    }
    CGFloat labelY = 0;
    CGFloat labelW = self.frame.size.width - labelX;
    CGFloat labelH = self.frame.size.height;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    
    CGPoint topPoint = self.signImageView.center;
    topPoint.y = _titleLabel.center.y;
    _signImageView.center = topPoint;
}

- (UIImageView *)signImageView {
    if (!_signImageView) {
        _signImageView = [[UIImageView alloc] init];
    }
    return _signImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:advertScrollViewTitleFont];
    }
    return _titleLabel;
}
@end


@interface PGGScrollViewDoubleCell()
@end
@implementation PGGScrollViewDoubleCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.topSignImageView];
        [self.contentView addSubview:self.topLabel];
        [self.contentView addSubview:self.bottomSignImageView];
        [self.contentView addSubview:self.bottomLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spacing = 5;
    CGFloat topSignImageViewW = self.topSignImageView.image.size.width;
    CGFloat topSignImageViewH = self.topSignImageView.image.size.height;
    CGFloat topSignImageViewX = 0;
    CGFloat topSignImageViewY = spacing;
    self.topSignImageView.frame = CGRectMake(topSignImageViewX, topSignImageViewY, topSignImageViewW, topSignImageViewH);
    CGFloat topLabelX = 0;
    if (self.topSignImageView.image == nil) {
        topLabelX = 0;
    } else {
        topLabelX = CGRectGetMaxX(self.topSignImageView.frame) + 0.5 * spacing;
    }
    CGFloat topLabelY = topSignImageViewY;
    CGFloat topLabelW = self.frame.size.width - topLabelX;
    CGFloat topLabelH = 0.5 * (self.frame.size.height - 2 * topLabelY);
    self.topLabel.frame = CGRectMake(topLabelX, topLabelY, topLabelW, topLabelH);
    
    CGPoint topPoint = self.topSignImageView.center;
    topPoint.y = _topLabel.center.y;
    _topSignImageView.center = topPoint;
    
    CGFloat bottomSignImageViewW = self.bottomSignImageView.image.size.width;
    CGFloat bottomSignImageViewH = self.bottomSignImageView.image.size.height;
    CGFloat bottomSignImageViewX = 0;
    CGFloat bottomSignImageViewY = CGRectGetMaxY(self.topLabel.frame);
    self.bottomSignImageView.frame = CGRectMake(bottomSignImageViewX, bottomSignImageViewY, bottomSignImageViewW, bottomSignImageViewH);
    
    CGFloat bottomLabelX = 0;
    if (self.bottomSignImageView.image == nil) {
        bottomLabelX = 0;
    } else {
        bottomLabelX = CGRectGetMaxX(self.bottomSignImageView.frame) + 0.5 * spacing;
    }
    CGFloat bottomLabelY = CGRectGetMaxY(self.topLabel.frame);
    CGFloat bottomLabelW = self.frame.size.width - bottomLabelX;
    CGFloat bottomLabelH = topLabelH;
    self.bottomLabel.frame = CGRectMake(bottomLabelX, bottomLabelY, bottomLabelW, bottomLabelH);
    
    CGPoint bottomPoint = self.bottomSignImageView.center;
    bottomPoint.y = _bottomLabel.center.y;
    _bottomSignImageView.center = bottomPoint;
}

- (UIImageView *)topSignImageView {
    if (!_topSignImageView) {
        _topSignImageView = [[UIImageView alloc] init];
    }
    return _topSignImageView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.textColor = [UIColor blackColor];
        _topLabel.font = [UIFont systemFontOfSize:advertScrollViewTitleFont];
    }
    return _topLabel;
}

- (UIImageView *)bottomSignImageView {
    if (!_bottomSignImageView) {
        _bottomSignImageView = [[UIImageView alloc] init];
    }
    return _bottomSignImageView;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = [UIColor blackColor];
        _bottomLabel.font = [UIFont systemFontOfSize:advertScrollViewTitleFont];
    }
    return _bottomLabel;
}
@end
