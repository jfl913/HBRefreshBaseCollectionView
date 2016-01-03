//
//  ViewController.m
//  HBRefreshBaseCollectionViewDemo
//
//  Created by JunfengLi on 16/1/3.
//  Copyright © 2016年 JunfengLi. All rights reserved.
//

#import "ViewController.h"
#import "TestCollectionView.h"

@interface ViewController ()

@property (nonatomic, strong) TestCollectionView *testCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.testCollectionView];
}


#pragma mark - Accessors

- (TestCollectionView *)testCollectionView
{
    if (!_testCollectionView) {
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
        _testCollectionView = [[TestCollectionView alloc] initWithFrame:CGRectMake(0, 20, width, height -20) collectionViewLayout:[UICollectionViewFlowLayout new]];
    }
    
    return _testCollectionView;
}

@end
