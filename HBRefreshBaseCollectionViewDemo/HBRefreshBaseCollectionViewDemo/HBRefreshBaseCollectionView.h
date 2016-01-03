//
//  HBRefreshBaseCollectionView.h
//  HBRefreshBaseCollectionViewDemo
//
//  Created by JunfengLi on 16/1/3.
//  Copyright © 2016年 JunfengLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBRefreshBaseCollectionViewDelegate <NSObject>

@optional

- (void)sendFirstPageRequest;
- (void)sendNextPageRequest;

@end

@interface HBRefreshBaseCollectionView : UIView

@property (nonatomic, weak) id <HBRefreshBaseCollectionViewDelegate> refreshDelegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelsArray;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
- (void)finishLoadCollectionViewDataSource:(NSArray *)dataSource atPage:(NSInteger)currentPage;

@end
