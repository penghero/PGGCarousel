# PGGCarousel
欢迎使用鹏哥哥轮播控件
//GitHub 地址 https://github.com/penghero/PGGCarousel.git
如果对您有帮助 请前往上面地址 送我一颗星星呗
无限轮播 包含头部视图左右轮播 还有文字消息的上下轮播
该轮播原理 基于collectionView进行的封装
就是几个collectionView，至于无限轮播，很简单，只需要你的轮播数组给collectionView赋值的时候乘以一个较大的数字即可（例如500），collectionView本身处理了重用等一系列问题。
该轮播包含两个类 一个是顶部视图轮播类 PGGCarouselView
调用
该轮播包含两个类 一个是顶部视图轮播类 PGGCarouselView方法
//带标语的初始化方法
+ (instancetype)PGGCarouseScrollViewWithFrame:(CGRect)frame imgsData:(NSArray *)imgsData titlesData:(NSArray *)titlesData;
//不带标语的初始化方法
+ (instancetype)PGGCarouseScrollViewWithFrame:(CGRect)frame imgsData:(NSArray *)imgsData;
另一个是文字消息的轮播类 PGGCarouselTextView
实现原理跟PGGCarouselView的一样 
调用
    /**创建文字轮播   设置各个属性 根据项目需要自行添加*/
    PGGCarouselTextView *pggText = [[PGGCarouselTextView alloc] initWithFrame:CGRectMake(0, 330, PGG_Weight, 30)];
    pggText.titles = titles;
    pggText.backgroundColor = [UIColor clearColor];
    pggText.titleColor = [UIColor whiteColor];
    pggText.textAlignment = NSTextAlignmentCenter;
    pggText.delegate = self;
    pggText.signImages = signImageArray;
    pggText.titleFont = [UIFont systemFontOfSize:24];
    [self.view addSubview:pggText];
注：借鉴网上各大神著 感谢
