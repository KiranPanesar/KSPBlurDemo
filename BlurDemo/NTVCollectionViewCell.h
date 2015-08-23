//
//  NTVCollectionViewCell.h
//  BlurDemo
//
//  Created by kiran on 22/08/2015.
//  Copyright (c) 2015 Nativ Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTVCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic, readwrite) NSString *titleText;
@property (strong, nonatomic, readwrite) NSString *bodyText;
@property (strong, nonatomic, readwrite) UIImage *image;

@end
