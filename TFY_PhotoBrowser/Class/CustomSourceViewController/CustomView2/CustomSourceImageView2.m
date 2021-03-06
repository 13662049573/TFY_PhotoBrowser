//
//  CustomSourceImageView2.m
//  TFY_PhotoBrowser
//
//  Created by LuKane on 2021/5/23.
//  Copyright © 2021 LuKane. All rights reserved.
//

#import "CustomSourceImageView2.h"

@implementation CustomSourceImageView2

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    UILabel *l = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:l];
    
    SDAnimatedImageView *img = [[SDAnimatedImageView alloc] initWithFrame:self.bounds];
    [self addSubview:img];
    self.imageView = img;
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.userInteractionEnabled = false;
    b.frame = self.bounds;
    [self addSubview:b];
}

@end
