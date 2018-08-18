//
//  JQCollectionViewBrickLayout.h
//  JQCollectionViewBrickLayout
//
//  Created by Joker on 2018/8/17.
//

#import <UIKit/UIKit.h>

@class JQCollectionViewBrickLayout;

@protocol UICollectionViewDelegateBrickLayout <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(JQCollectionViewBrickLayout*)collectionViewLayout maximumItemReferenceSizeForSectionAtIndex:(NSInteger)section;

@end

@interface JQCollectionViewBrickLayout : UICollectionViewFlowLayout

@property (nonatomic) CGSize maximumItemReferenceSize;

@end
