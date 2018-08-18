//
//  JQViewController.m
//  JQCollectionViewBrickLayout
//
//  Created by coder-zjq on 08/17/2018.
//  Copyright (c) 2018 coder-zjq. All rights reserved.
//

#import "JQViewController.h"
#import "JQCollectionViewBrickLayout.h"

static CGFloat const kPadding = 5.f;
#define kHeaderFooterSize CGSizeMake(50.f, 50.f)

@interface JQViewController ()<UICollectionViewDelegateBrickLayout, UICollectionViewDataSource>

/// collection view
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
/// collection view data
@property (nonatomic, strong) NSMutableArray *data;
/// collection view scroll direction
@property (nonatomic) UICollectionViewScrollDirection direction;

@end

@implementation JQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    self.direction = UICollectionViewScrollDirectionVertical;
}

#pragma mark -
#pragma mark - action

- (IBAction)changeScrollDirection:(id)sender {
    self.direction = self.direction == UICollectionViewScrollDirectionVertical ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
}

#pragma mark -
#pragma mark - getter & setter

- (void)setDirection:(UICollectionViewScrollDirection)direction {
    _direction = direction;
    JQCollectionViewBrickLayout *layout = (JQCollectionViewBrickLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = direction;
    _data = nil;
    [self.collectionView reloadData];
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i ++) {
            NSMutableArray *sizes = [[NSMutableArray alloc] init];
            NSInteger count = 30;
            for (int j = 0; j < count; j++)
            {
                [sizes addObject:@(CGSizeMake(20 + arc4random() % 50, 20 + arc4random() % 50))];
            }
            [_data addObject:sizes];
        }
    }
    return _data;
}

#pragma mark -
#pragma mark - JQCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewBrickLayout *)collectionViewLayout maximumItemReferenceSizeForSectionAtIndex:(NSInteger)section {
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sizes = self.data[indexPath.section];
    return [sizes[indexPath.item] CGSizeValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sizes = self.data[section];
    return sizes.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor greenColor];
        return header;
    } else {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor blueColor];
        return footer;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // test update
    NSMutableArray *sizes = self.data[indexPath.section];
    if (sizes.count == 1) {
        [self.data removeObjectAtIndex:indexPath.section];
        [collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    } else {
        [sizes removeObjectAtIndex:indexPath.item];
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return kHeaderFooterSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return kHeaderFooterSize;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kPadding;
}

@end

