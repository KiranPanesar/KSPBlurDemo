//
//  NTVReusableView.m
//  BlurDemo
//
//  Created by kiran on 21/08/2015.
//  Copyright (c) 2015 Nativ Mobile. All rights reserved.
//

#import "NTVReusableView.h"

@interface NTVReusableView () {
    CIContext *context;
}

@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UIImageView *imageView;
@end

@implementation NTVReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.image = [UIImage imageNamed:kNTVReusableViewImageName];
        self.image = [UIImage imageNamed:kNTVReusableViewImageName];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"Politics & Diplomacy";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Light" size:20.0f];
        
        EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
        context = [CIContext contextWithEAGLContext:eaglContext options:options];
        
        self.clipsToBounds = YES;
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"imageView": self.imageView}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"imageView": self.imageView}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[label]-(>=0)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"label": self.titleLabel}]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:5.0f]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"label": self.titleLabel}]];

    }
    
    return self;
}

- (void)setRadius:(CGFloat)radius {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _radius = radius;
        
        if (radius == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageNamed:kNTVReusableViewImageName];
            });
            return;
        } else if (radius >= 37.0f) {
            return;
        }

        UIImage *temp = [UIImage imageNamed:kNTVReusableViewImageName];
        CIImage *image = [CIImage imageWithCGImage:temp.CGImage];

        CGAffineTransform transform = CGAffineTransformIdentity;
        CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
        [clampFilter setValue:image forKey:@"inputImage"];
        [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];

        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputImage",clampFilter.outputImage,@"inputRadius",[NSNumber numberWithFloat:radius],nil];
        
        CIImage *outimage = filter.outputImage;

        CGImageRef cgImage = [context createCGImage:outimage fromRect:[image extent]];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = uiImage;
        });
        
        CGImageRelease(cgImage);
    });
}

@end
