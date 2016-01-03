//
//  HBRefreshBaseCollectionView.m
//  HBRefreshBaseCollectionViewDemo
//
//  Created by JunfengLi on 16/1/3.
//  Copyright © 2016年 JunfengLi. All rights reserved.
//

#import "HBRefreshBaseCollectionView.h"
#import "EGORefreshTableHeaderView.h"
#import <SVPullToRefresh.h>

#define kRefreshHeaderViewHeight 176

@interface HBRefreshBaseCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) UILabel *noMoreLabel;
@property (nonatomic) NSInteger currentPage;

@end

@implementation HBRefreshBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor lightGrayColor];
        [self.collectionView addSubview:self.refreshHeaderView];
        __weak typeof(self) weakSelf = self;
        [self.collectionView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadMoreDataSource];
        }];
        [self addSubview:self.collectionView];
        
        self.modelsArray = [@[] mutableCopy];
    }
    
    return self;
}

- (void)finishLoadCollectionViewDataSource:(NSArray *)dataSource atPage:(NSInteger)currentPage
{
    self.currentPage = currentPage;
    self.isLoading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    [self.collectionView.infiniteScrollingView stopAnimating];
    
    if (currentPage == 1) {
        [self.modelsArray removeAllObjects];
    }
    
    if (dataSource.count > 0) {
        [self.modelsArray addObjectsFromArray:dataSource];
        self.noMoreLabel.hidden = YES;
        [self.collectionView reloadData];
    } else {
        [self.collectionView reloadData];
        self.noMoreLabel.hidden = NO;
        CGFloat yPos = self.collectionView.contentSize.height;
        CGRect frame = self.noMoreLabel.frame;
        frame.origin.y = yPos;
        self.noMoreLabel.frame = frame;
        [self.collectionView addSubview:self.noMoreLabel];
    }
}

- (void)reloadCollectionViewDataSource
{
    self.isLoading = YES;
    if ([self.refreshDelegate respondsToSelector:@selector(sendFirstPageRequest)]) {
        [self.refreshDelegate sendFirstPageRequest];
    }
}

- (void)loadMoreDataSource
{
    if ([self.refreshDelegate respondsToSelector:@selector(sendNextPageRequest)]) {
        [self.refreshDelegate sendNextPageRequest];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadCollectionViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.isLoading;
}

#pragma mark - Accessors

- (EGORefreshTableHeaderView *)refreshHeaderView
{
    if (!_refreshHeaderView) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -kRefreshHeaderViewHeight, [UIScreen mainScreen].bounds.size.width, kRefreshHeaderViewHeight)];
        _refreshHeaderView.delegate = self;
    }
    
    return _refreshHeaderView;
}

- (UILabel *)noMoreLabel
{
    if (!_noMoreLabel) {
        _noMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        _noMoreLabel.textColor = [UIColor grayColor];
        _noMoreLabel.textAlignment = NSTextAlignmentCenter;
        _noMoreLabel.font = [UIFont systemFontOfSize:14];
        _noMoreLabel.text = @"没有更多了";
    }

    return _noMoreLabel;
}

@end
