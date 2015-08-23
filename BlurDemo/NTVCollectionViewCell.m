//
//  NTVCollectionViewCell.m
//  BlurDemo
//
//  Created by kiran on 22/08/2015.
//  Copyright (c) 2015 Nativ Mobile. All rights reserved.
//

#import "NTVCollectionViewCell.h"

@interface NTVCollectionViewCell ()

@property (strong, nonatomic, readwrite) UILabel *titleLabel;
@property (strong, nonatomic, readwrite) UILabel *descriptionLabel;
@property (strong, nonatomic, readwrite) UIImageView *imageView;
@property (strong, nonatomic, readwrite) CIContext *context;

@end

@implementation NTVCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSDictionary *options = @{ kCIContextWorkingColorSpace : [NSNull null] };
        self.context = [CIContext contextWithEAGLContext:eaglContext options:options];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"Obama unveils compensation package for Israel after Iran deal";
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20.0f];
        
        [self addSubview:self.titleLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.descriptionLabel.text = @"The New York Times on Friday revealed the details of a compensation package Israel is set to receive from the United States after world powers and Iran agreed to a historic nuclear agreement in early July.";
        self.descriptionLabel.textColor = [UIColor colorWithRed:127/255.0f green:140/255.0f blue:141/255.0f alpha:1.0f];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:16.0f];
        
        [self addSubview:self.descriptionLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView(10)]-(10)-[label(>=25)]-(>=10)-[descriptionLabel]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"imageView":self.imageView, @"label": self.titleLabel, @"descriptionLabel": self.descriptionLabel}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[label]-20-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"label": self.titleLabel}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[label]-20-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"label": self.descriptionLabel}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[imageView]-(0)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"imageView": self.imageView}]];
    }
    
    return self;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setBodyText:(NSString *)bodyText {
    _bodyText = bodyText;
    self.descriptionLabel.text = bodyText;
}

- (void)setImage:(UIImage *)image {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *temp = image;
        CIImage *image = [CIImage imageWithCGImage:temp.CGImage];
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
        [clampFilter setValue:image forKey:@"inputImage"];
        [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputImage",clampFilter.outputImage,@"inputRadius",[NSNumber numberWithFloat:60.0f],nil];
        
        CIImage *outimage = filter.outputImage;
        
        CGImageRef cgImage = [self.context createCGImage:outimage fromRect:[image extent]];
        
        UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = uiImage;
        });
        
        CGImageRelease(cgImage);
    });

    _image = image;
    self.imageView.image = image;
}

@end
