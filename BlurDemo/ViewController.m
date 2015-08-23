//
//  ViewController.m
//  BlurDemo
//
//  Created by kiran on 21/08/2015.
//  Copyright (c) 2015 Nativ Mobile. All rights reserved.
//

#import "ViewController.h"
#import "NTVReusableView.h"

#import "NTVCollectionViewCell.h"
#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.h>
#import <SOZOChromoplast/SOZOChromoplast.h>

static NSString * kNTVTitle [3] = {@"Obama unveils compensation package for Israel after Iran deal", @"Why Donald Trump Won’t Fold: Polls and People Speak", @"Obama on the Vineyard? Been There, Seen That"};
static NSString * kNTVBody [3] = {@"The New York Times on Friday revealed the details of a compensation package Israel is set to receive from the United States after world powers and Iran agreed to a historic nuclear agreement in early July", @"In the command centers of Republican presidential campaigns, aides have drawn comfort from the belief that Donald J. Trump’s dominance in the polls is a political summer fling, like Herman Cain in 2011 — an unsustainable boomlet...", @ "CHILMARK, Mass. — In 2009, this island buzzed with excitement as President Obama, then still a newcomer to the Oval Office, arrived here for his first presidential summer vacation."};

static NSString *kNTVURLs [3] = {@"obama.jpeg", @"obama_vineyard.jpg", @"trump.jpg"};

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic, readwrite) NTVReusableView *headerView;
@property (strong, nonatomic, readwrite) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 200.0f);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 64.0f);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
        layout.parallaxHeaderAlwaysOnTop = YES;

        // If we want to disable the sticky header effect
        layout.disableStickyHeaders = YES;
    }

    self.view.backgroundColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0f];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delaysContentTouches = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    
    [self.collectionView registerClass:[NTVCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[NTVReusableView class]
            forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                   withReuseIdentifier:@"header"];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView": self.collectionView}]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView": self.collectionView}]];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width - 10.0f, 190.0f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 0.0f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    return self.headerView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NTVCollectionViewCell *card = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    card.titleText = kNTVTitle[indexPath.row % 3];
    card.bodyText = kNTVBody[indexPath.row % 3];
    card.image = [UIImage imageNamed:kNTVURLs[indexPath.row % 3]];
    
    card.backgroundColor = [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:10.0f];
    card.layer.cornerRadius = 5.0f;
    card.layer.masksToBounds = YES;
    
    return card;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 140.0f) {
        self.headerView.radius = (scrollView.contentOffset.y - 140.0f) * 0.2;
    } else {
        self.headerView.radius = 0;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
