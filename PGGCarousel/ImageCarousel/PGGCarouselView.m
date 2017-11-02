//
//  PGGCarouselView.m
//  PGGCarousel
//
//  Created by 陈鹏 on 2017/10/31.
//  Copyright © 2017年 penggege.CP. All rights reserved.
//GitHub 地址 https://github.com/penghero/PGGCarousel.git

#import "PGGCarouselView.h"
@interface PGGCarouselView () <UICollectionViewDataSource, UICollectionViewDelegate>
#pragma mark - 私有API
@property (nonatomic, strong) UICollectionView *BgMainCollectionView; // 显示图片的collectionView
@property (nonatomic, strong) UICollectionViewFlowLayout *BgMainflowLayout; //布局方式 横向滑动
@property (nonatomic, strong) NSTimer *timer; //定时器
@property (nonatomic, assign) NSInteger totalCount; //collectionViewCell总数 (通过这个数很大 来实现无线轮播)
@property (nonatomic, strong) UIPageControl *pageControl; //页面进度
@property (nonatomic, strong) NSArray *titlesData;//传入的标语数据 传则有  不传则无 （默认无标语）
@property (nonatomic, strong) NSArray *imgsData;//传入的图片数据

@end
static  NSString *ID = @"PGGCELLID";
@implementation PGGCarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _TimerInterval = 2;
        [self addSubview:self.BgMainCollectionView];
        [self setupTimer];
    }
    return self;
}
- (UICollectionView *)BgMainCollectionView{
    if (_BgMainCollectionView == nil) {
        self.BgMainflowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.BgMainflowLayout.itemSize = self.frame.size;
        self.BgMainflowLayout.minimumLineSpacing = 0;
        self.BgMainflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _BgMainCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.BgMainflowLayout];
        _BgMainCollectionView.backgroundColor = [UIColor darkTextColor];
        _BgMainCollectionView.pagingEnabled = YES;
        _BgMainCollectionView.showsHorizontalScrollIndicator = NO;
        _BgMainCollectionView.showsVerticalScrollIndicator = NO;
        [_BgMainCollectionView registerClass:[PGGCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _BgMainCollectionView.dataSource = self;
        _BgMainCollectionView.delegate = self;
    }
    return _BgMainCollectionView;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake( 0, self.frame.size.height-10, self.frame.size.width, 2)];
        _pageControl.numberOfPages = self.imgsData.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}
//创建定时器
- (void)setupTimer
{
    [self removeTimer];
     self.timer = [NSTimer scheduledTimerWithTimeInterval:self.TimerInterval target:self selector:@selector(pggScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}
- (void)pggScroll {
    int currentIndex = self.BgMainCollectionView.contentOffset.x / self.BgMainflowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == self.totalCount) {
        targetIndex = self.totalCount * 0.5;
        [self.BgMainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.BgMainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
#pragma mark - Setting
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _BgMainflowLayout.itemSize = self.frame.size;
}

- (void)setTimerInterval:(CFTimeInterval)TimerInterval
{
    _TimerInterval = TimerInterval;
    if (_TimerInterval) {
        [self setupTimer];
    }
}
//对totalCount进行赋值 同时开启定时器
- (void)setImgsData:(NSArray *)imgsData{
    
    _imgsData = imgsData;
    _totalCount = imgsData.count * 500;
    [self setupTimer];
    [self addSubview:self.pageControl];
    
}
#pragma mark - 初始化
//无标语初始化
+ (instancetype)PGGCarouseScrollViewWithFrame:(CGRect)frame imgsData:(NSArray *)imgsData{
    PGGCarouselView *pggView = [[self alloc] initWithFrame:frame];
    pggView.imgsData = imgsData;
    return pggView;
}
//有标语初始化
+ (instancetype)PGGCarouseScrollViewWithFrame:(CGRect)frame imgsData:(NSArray *)imgsData titlesData:(NSArray *)titlesData{
    PGGCarouselView *pggView = [[self alloc] initWithFrame:frame];
    pggView.imgsData = imgsData;
    pggView.titlesData = titlesData;
    return pggView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.BgMainCollectionView.frame = self.bounds;
    if (self.BgMainCollectionView.contentOffset.x == 0) {
        [self.BgMainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.totalCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    CGSize size = [self.pageControl sizeForNumberOfPages:self.imgsData.count];
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    CGFloat y = self.BgMainCollectionView.frame.size.height - size.height ;
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
    [self.pageControl sizeToFit];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imgsData.count;
    cell.imageView.image = self.imgsData[itemIndex];
    if (self.titlesData.count) {
        cell.title = self.titlesData[itemIndex];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(PGGCarouseScrollView:didSelectAtIndex:)]) {
        [self.delegate PGGCarouseScrollView:self didSelectAtIndex:indexPath.item % self.imgsData.count];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.BgMainCollectionView.frame.size.width * 0.5) / self.BgMainCollectionView.frame.size.width;
    int indexOnPageControl = itemIndex % self.imgsData.count;
    self.pageControl.currentPage = indexOnPageControl;
}
//触摸滑动时停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}
//滑动结束时开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark - PGGCollectionViewCell
@interface PGGCollectionViewCell()

@end

@implementation PGGCollectionViewCell
{
    __weak UILabel *titleLabel;
}
@synthesize imageView;
@synthesize title;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *pggimageView = [[UIImageView alloc] init];
        imageView = pggimageView;
        [self addSubview:pggimageView];
        
        UILabel *pggtitleLabel = [[UILabel alloc] init];
        pggtitleLabel.backgroundColor = [UIColor clearColor];
        pggtitleLabel.hidden = YES;
        pggtitleLabel.textColor = [UIColor whiteColor];
        pggtitleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel = pggtitleLabel;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    title = [title copy];
    titleLabel.text = [NSString stringWithFormat:@"   %@", title];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    imageView.frame = self.bounds;
    CGFloat titleLabelW = self.frame.size.width;
    CGFloat titleLabelH = 30;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.frame.size.height - titleLabelH;
    titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    titleLabel.hidden = !titleLabel.text;
}

@end

