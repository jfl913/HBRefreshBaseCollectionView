//
//  TestCollectionView.m
//  HBRefreshBaseCollectionViewDemo
//
//  Created by JunfengLi on 16/1/3.
//  Copyright © 2016年 JunfengLi. All rights reserved.
//

#import "TestCollectionView.h"
#import "TestCollectionViewCell.h"

@interface TestCollectionView () <HBRefreshBaseCollectionViewDelegate>

@end

@implementation TestCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.refreshDelegate = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TestCollectionViewCell"];
        [self doneLoadingCollectionViewData];
    }
    
    return self;
}

#pragma mark - HBRefreshBaseCollectionViewDelegate

- (void)sendFirstPageRequest
{
    [self performSelector:@selector(doneLoadingCollectionViewData) withObject:nil afterDelay:3.0];
}

- (void)doneLoadingCollectionViewData
{
    NSArray *array = @[@"1", @"2", @"3", @"4", @"1", @"2", @"3", @"4", @"1", @"2", @"3", @"4", @"1", @"2", @"3", @"4"];
    [self finishLoadCollectionViewDataSource:array atPage:1];
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCollectionViewCell" forIndexPath:indexPath];
    cell.testLabel.text = [NSString stringWithFormat:@"%@", self.modelsArray[indexPath.item]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

@end
