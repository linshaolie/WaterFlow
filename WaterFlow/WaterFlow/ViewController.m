//
//  ViewController.m
//  WaterFlow
//
//  Created by lin on 14-11-20.
//  Copyright (c) 2014年 linshaolie. All rights reserved.
//

#import "ViewController.h"
#import "LinWaterFlowLayout.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<LinWaterFlowLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *cellHeights;
@end

static int count = 10;
@implementation ViewController

#pragma mark - Accessors
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        LinWaterFlowLayout *layout = [[LinWaterFlowLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    self.title = @"WaterFallFlow";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayout];
}


- (void)updateLayout
{
    LinWaterFlowLayout *layout =
    (LinWaterFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemWidth = 160;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =
    (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    cell.layer.cornerRadius = 80;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-------------%d",indexPath.item);
}

#pragma mark -LinWaterFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(LinWaterFlowLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
//    return arc4random()%200+100;          //返回所需要的高度

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(LinWaterFlowLayout *)collectionViewLayout eachColumnStartingY:(NSUInteger)column
{
    if( column == 1 )
    {
        return 80;
    }
    return 0;
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%f----%f", scrollView.contentOffset.y, scrollView.contentSize.height);
    if( scrollView.contentOffset.y + SCREENHEIGHT > scrollView.contentSize.height + 60 )
    {
        count += 10;
        CGPoint offset = scrollView.contentOffset;
        offset.y += 60;
        scrollView.contentOffset = offset;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
    }
    
}

@end
