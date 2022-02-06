//
//  TFY_ActionSheet.m
//  TFY_PhotoBrowser
//
//  Created by 田风有 on 2022/2/6.
//

#import "TFY_ActionSheet.h"
#import "TFY_ActionSheetItem.h"

#define KWidth [UIScreen mainScreen].bounds.size.width

#define KHeight [UIScreen mainScreen].bounds.size.height

#define kActionCoverBackgroundColor [UIColor colorWithRed:30/255.f green:30/255.f blue:30/255.f alpha:1.f]
#define kActionBgViewBackgroundColor [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1.f]

#define kActionDuration 0.3

@interface TFY_ActionSheet ()<ActionSheetItemDelegate>{
    NSString *_title;
    UIColor  *_titleColor;
    NSString *_cancelTitle;
    ActionSheetBlock _sheetBlock;
    NSMutableArray *_titleArray;
    NSMutableArray *_destruciveArray;
    
    TFY_ActionSheetItem *_cancelItem;
    
    UIView  *_coverView;
    UIView  *_bgView;
    UIView  *_bottomView;
    NSMutableArray *_itemsArr;
    NSMutableArray *_lineArr;
    BOOL _isShow;
    
    CGFloat _kTFY_ActionItemHeight;
    CGFloat _padding;
}
@end

@implementation TFY_ActionSheet

+ (TFY_ActionSheet *)share{
    static dispatch_once_t onceToken;
    static TFY_ActionSheet *share;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return share;
}

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock{
    return [self initWithTitle:title titleColor:nil cancelTitle:cancelTitle titleArray:titleArray actionSheetBlock:sheetBlock];
}

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             destructiveArray:(NSMutableArray <NSString *> *)destructiveArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock{
    return [self initWithTitle:title titleColor:nil cancelTitle:cancelTitle titleArray:titleArray destructiveArray:destructiveArray actionSheetBlock:sheetBlock];
}

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(nullable UIColor *)titleColor
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock{
    if (self = [super init]) {
        _title       = title;
        _titleColor  = titleColor;
        _cancelTitle = cancelTitle;
        _titleArray  = titleArray;
        _sheetBlock  = sheetBlock;
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(nullable UIColor *)titleColor
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSMutableArray <NSString *> *)titleArray
             destructiveArray:(NSMutableArray <NSString *> *)destructiveArray
             actionSheetBlock:(ActionSheetBlock)sheetBlock{
    if (self = [super init]) {
        _title       = title;
        _titleColor  = titleColor;
        _cancelTitle = cancelTitle;
        _titleArray  = titleArray;
        _sheetBlock  = sheetBlock;
        _destruciveArray = destructiveArray;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    _kTFY_ActionItemHeight = 48.7;
    _padding             = 0.3;
    
    if (KWidth <= 375) {
        _kTFY_ActionItemHeight = 48.5;
        _padding             = 0.5;
    }
    
    if ([self isEmptyArray:_titleArray]) {
        return;
    }
    
    if (![self isEmptyArray:_destruciveArray]) {
        if (_destruciveArray.count > _titleArray.count) {
            return;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceWillOrientation)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFrame:[UIScreen mainScreen].bounds];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.bounds];
    [coverView setBackgroundColor:kActionBgViewBackgroundColor];
    [coverView setAlpha:0];
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewDidClick)]];
    [self addSubview:coverView];
    _coverView = coverView;
    
    UIView *bgView = [[UIView alloc] init];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    _bgView = bgView;
    
    if ([self isEmptyString:_cancelTitle]) {
        _cancelTitle = @"取消";
    }
    
    _itemsArr = [NSMutableArray array];
    _lineArr  = [NSMutableArray array];
    
    if (![self isEmptyString:_title]) {
        TFY_ActionSheetItem *item = [[TFY_ActionSheetItem alloc] init];
        item.userInteractionEnabled = false;
        if (_titleColor) {
            item.color = _titleColor;
        }
        item.title = _title;
        [_itemsArr addObject:item];
        [bgView addSubview:item];
        
        CALayer *line = [CALayer layer];
        [line setBackgroundColor:[kActionBgViewBackgroundColor CGColor]];
        [bgView.layer addSublayer:line];
        [_lineArr addObject:line];
    }
    
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        TFY_ActionSheetItem *item = [[TFY_ActionSheetItem alloc] init];
        for (NSInteger j = 0; j < _destruciveArray.count; j++) {
            NSInteger jIndex = [_destruciveArray[j] integerValue];
            if (jIndex < _titleArray.count) {
                if (i == jIndex) {
                    item.color = [UIColor redColor];
                }
            }
        }
        
        item.title = _titleArray[i];
        item.tag = i;
        item.delegate = self;
        [_itemsArr addObject:item];
        [bgView addSubview:item];
        
        CALayer *line = [CALayer layer];
        [line setBackgroundColor:[kActionBgViewBackgroundColor CGColor]];
        [bgView.layer addSublayer:line];
        [_lineArr addObject:line];
    }
    
    TFY_ActionSheetItem *cancelItem = [[TFY_ActionSheetItem alloc] init];
    cancelItem.title = _cancelTitle;
    [cancelItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewDidClick)]];
    [bgView addSubview:cancelItem];
    _cancelItem = cancelItem;
}

- (void)deviceWillOrientation{
    [self dismiss];
}

- (void)actionSheetItemDidClick:(NSInteger)index{
    if (_sheetBlock) {
        _sheetBlock(index);
    }
    [self dismiss];
}

- (void)coverViewDidClick{
    if (_sheetBlock) {
        _sheetBlock(-1);
    }
    [self dismiss];
}

- (void)showOnView:(UIView *)view{
    [_coverView setAlpha:0];
    [_bgView setTransform:CGAffineTransformIdentity];
    
    [view addSubview:self];
    _isShow = true;
}

- (void)dismiss{
    [UIView animateWithDuration:kActionDuration animations:^{
        [self->_coverView setAlpha:0];
        [self->_bgView setTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    _isShow = false;
}

- (BOOL)isEmptyString:(NSString *)string{
    if(string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        return true;
    }
    return false;
}
- (BOOL)isEmptyArray:(NSArray *)array{
    if(array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0){
        return true;
    }
    return false;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _coverView.frame = self.bounds;
    
    if (@available(iOS 11.0, *)){
        UIEdgeInsets insets = self.safeAreaInsets;
        CGFloat height = _kTFY_ActionItemHeight * (_itemsArr.count + 1) + 8;
        _bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, height + insets.bottom);
        [self addRectCorners:UIRectCornerTopLeft | UIRectCornerTopRight width:13 view:_bgView];
        for (NSInteger i = 0; i < _itemsArr.count; i++) {
            TFY_ActionSheetItem *item = _itemsArr[i];
            if (i == 0) {
                [self addRectCorners:UIRectCornerTopLeft | UIRectCornerTopRight width:13 view:item];
            }
            
            item.frame = CGRectMake(0, (_kTFY_ActionItemHeight + _padding) * i, _bgView.frame.size.width, _kTFY_ActionItemHeight);
            CALayer *line = _lineArr[i];
            if (i != _itemsArr.count - 1) {
                line.frame = CGRectMake(0, CGRectGetMaxY(item.frame), _bgView.frame.size.width, _padding);
            }else{
                line.frame = CGRectMake(0, CGRectGetMaxY(item.frame), _bgView.frame.size.width, _padding + 8);
            }
        }
        
        _cancelItem.frame = CGRectMake(0, _bgView.frame.size.height - _kTFY_ActionItemHeight - insets.bottom, _bgView.frame.size.width, _kTFY_ActionItemHeight);
        
        if (_isShow) {
            _isShow = false;
            [UIView animateWithDuration:kActionDuration animations:^{
                [self->_coverView setAlpha:0.3];
                [self->_bgView setTransform:CGAffineTransformMakeTranslation(0, -self->_bgView.frame.size.height)];
            }];
        }
    } else {
        CGFloat height = _kTFY_ActionItemHeight * (_itemsArr.count + 1) + 8;
        _bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, height);
        [self addRectCorners:UIRectCornerTopLeft | UIRectCornerTopRight width:13 view:_bgView];
        for (NSInteger i = 0; i < _itemsArr.count; i++) {
            TFY_ActionSheetItem *item = _itemsArr[i];
            if (i == 0) {
                [self addRectCorners:UIRectCornerTopLeft | UIRectCornerTopRight width:13 view:item];
            }
            item.frame = CGRectMake(0, (_kTFY_ActionItemHeight + _padding) * i, _bgView.frame.size.width, _kTFY_ActionItemHeight);
            CALayer *line = _lineArr[i];
            if (i != _itemsArr.count - 1) {
                line.frame = CGRectMake(0, CGRectGetMaxY(item.frame), _bgView.frame.size.width, _padding);
            }else{
                line.frame = CGRectMake(0, CGRectGetMaxY(item.frame), _bgView.frame.size.width, _padding + 8);
            }
        }
        
        _cancelItem.frame = CGRectMake(0, _bgView.frame.size.height - _kTFY_ActionItemHeight, _bgView.frame.size.width, _kTFY_ActionItemHeight);
        
        if (_isShow) {
            _isShow = false;
            [UIView animateWithDuration:kActionDuration animations:^{
                [self->_coverView setAlpha:0.3];
                [self->_bgView setTransform:CGAffineTransformMakeTranslation(0, -self->_bgView.frame.size.height)];
            }];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addRectCorners:(UIRectCorner)corners width:(CGFloat)width view:(UIView *)view{
    if (width > view.frame.size.width) {
        return;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(width, width)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

@end
