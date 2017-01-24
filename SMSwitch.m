//
//  SMSwitch.m
//
//  Created by Zeacone on 2017/1/22.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SMSwitch.h"

#define defaultOnColor [UIColor colorWithRed:197/255.0 green:61/255.0 blue:57/255.0 alpha:1.0]
#define defaultOffColor [UIColor colorWithRed:172/255.0 green:174/255.0 blue:176/255.0 alpha:1.0]

@interface SMSwitch ()

@property (nonatomic, strong) UIImageView *indicator;

@property (nonatomic, strong) UIImageView *left;
@property (nonatomic, strong) UIImageView *right;

@end

@implementation SMSwitch

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSetting];
    }
    return self;
}

- (void)initializeSetting {
    
    self.sideLength = 30;
    self.padding = 3;
    self.contentImageSize = CGSizeMake(self.sideLength/2, self.sideLength/2);
    
    
    self.layer.cornerRadius = 3.0;
    
    self.left = [self imageViewWithTitle:@"on"];
    self.right = [self imageViewWithTitle:@"off"];
    
    [self setBoundsAndCenter];
    
    
    self.indicator = [self imageViewWithTitle:@"ind"];
    self.indicator.layer.cornerRadius = 3;
    self.indicator.center = self.left.center;
    
    [self addSubview:self.left];
    [self addSubview:self.right];
    [self addSubview:self.indicator];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
    
    self.on = YES;
    self.onColor = defaultOnColor;
    self.offColor = defaultOffColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setBoundsAndCenter];
    
    self.indicator.bounds = CGRectMake(0, 0, self.sideLength, self.sideLength);
}


- (void)setBoundsAndCenter {
    
    self.bounds = CGRectMake(0, 0, self.sideLength * 2 + self.padding * 3, self.sideLength + self.padding * 2);
    
    self.left.center = CGPointMake(CGRectGetWidth(self.left.bounds)+self.padding, CGRectGetMidY(self.bounds));
    self.right.center = CGPointMake(CGRectGetWidth(self.bounds)-self.padding-CGRectGetWidth(self.right.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - Setter methods
- (void)setOn:(BOOL)on {
    _on = on;
    
    [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:.4
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (on) {
                             self.indicator.center = self.right.center;
                             self.backgroundColor = self.onColor;
                         } else {
                             self.indicator.center = self.left.center;
                             self.backgroundColor = self.offColor;
                         }
                     } completion:^(BOOL finished) {
                         if (self.delegate && [self.delegate respondsToSelector:@selector(isOn:)]) {
                             [self.delegate isOn:on];
                         }
                     }];
}

- (void)setSideLength:(CGFloat)sideLength {
    _sideLength = sideLength;
    [self setNeedsLayout];
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    [self setNeedsLayout];
}

- (void)setOnColor:(UIColor *)onColor {
    _onColor = onColor;
    self.on = self.on;
}

- (void)setOffColor:(UIColor *)offColor {
    _offColor = offColor;
    self.on = self.on;
}

- (void)setContentImageSize:(CGSize)contentImageSize {
    _contentImageSize = contentImageSize;
    CGRect bounds = {.size = contentImageSize};
    self.left.bounds = bounds;
    self.right.bounds = bounds;
}

- (void)setLeftImage:(UIImage *)leftImage {
    self.left.image = leftImage;
}

- (void)setRightImage:(UIImage *)rightImage {
    self.right.image = rightImage;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    self.indicator.image = indicatorImage;
}

#pragma mark - Lazy load UIImageView
- (UIImageView *)imageViewWithTitle:(NSString *)name {
    
    UIImageView *imageView = [UIImageView new];
    
    CGRect bounds = {.size = self.contentImageSize};
    imageView.bounds = bounds;
    imageView.image = [UIImage imageNamed:name];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    return imageView;
}

#pragma mark - Actions about handle switch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.on = !self.on;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    static CGFloat fraction = 0;
    
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
            {
                CGFloat translation = [pan translationInView:pan.view].x;
                
                fraction += translation;
                
                NSLog(@"translation = %@", @(ABS(fraction)/CGRectGetWidth(pan.view.bounds)));
                
                self.indicator.center = CGPointMake(self.indicator.center.x+translation, self.indicator.center.y);
                
                [pan setTranslation:CGPointZero inView:pan.view];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            {
                if (ABS(fraction) / CGRectGetWidth(pan.view.bounds) < 0.25) {
                    self.on = self.on;
                } else {
                    self.on = !self.on;
                }
                fraction = 0;
            }
            break;
            
        default:
            break;
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
