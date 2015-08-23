//
//  NTVReusableView.h
//  BlurDemo
//
//  Created by kiran on 21/08/2015.
//  Copyright (c) 2015 Nativ Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kNTVReusableViewImageName = @"obama.jpeg";

@interface NTVReusableView : UICollectionReusableView

@property (assign, nonatomic, readwrite) CGFloat radius;
@property (strong, nonatomic, readwrite) UIImage *image;

@end
