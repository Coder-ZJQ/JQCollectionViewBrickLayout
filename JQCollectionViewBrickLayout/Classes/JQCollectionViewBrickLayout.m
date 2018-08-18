//
//  JQCollectionViewBrickLayout.m
//  JQCollectionViewBrickLayout
//
//  Created by Joker on 2018/8/17.
//

#import "JQCollectionViewBrickLayout.h"

@interface UICollectionView (BrickHook)

@property (nonatomic, weak, nullable) id<UICollectionViewDelegateBrickLayout> delegate;

@end

@interface JQCollectionViewBrickLayout ()

@property (nonatomic, strong) NSMutableDictionary *layoutAttributes;

@end

@implementation JQCollectionViewBrickLayout (attributes)

- (CGFloat)jq_ratioForItemHeightWidthAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        CGSize size = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        return size.height != 0.f ? size.width / size.height : 0;
    }
    else
    {
        CGSize size = self.itemSize;
        return size.height != 0.f ? size.width / size.height : 0;
    }
}

- (CGSize)jq_maximumItemReferenceSizeForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:maximumItemReferenceSizeForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateBrickLayout> delegate = (id<UICollectionViewDelegateBrickLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self maximumItemReferenceSizeForSectionAtIndex:section];
    }
    else
    {
        return self.maximumItemReferenceSize;
    }
}

- (CGFloat)jq_minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    else
    {
        return self.minimumInteritemSpacing;
    }
}

- (CGFloat)jq_minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    else
    {
        return self.minimumLineSpacing;
    }
}

- (UIEdgeInsets)jq_insetForSectionAtIndex:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    else
    {
        return self.sectionInset;
    }
}

- (CGSize)jq_sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    else
    {
        return self.itemSize;
    }
}

- (BOOL)jq_hasHeaderInSection:(NSInteger)section
{
    CGSize size = [self jq_referenceSizeForHeaderInSection:section];
    return !CGSizeEqualToSize(size, CGSizeZero);
}

- (BOOL)jq_hasFooterInSection:(NSInteger)section
{
    CGSize size = [self jq_referenceSizeForFooterInSection:section];
    return !CGSizeEqualToSize(size, CGSizeZero);
}

- (CGSize)jq_referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    else
    {
        return self.headerReferenceSize;
    }
}

- (CGSize)jq_referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.collectionView.delegate && [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    else
    {
        return self.footerReferenceSize;
    }
}

@end

NSString *JQGenerateCacheKey(NSString *kind, NSIndexPath *indexPath)
{
    return [NSString stringWithFormat:@"<%@,%ld,%ld>", kind, (long) indexPath.section, (long) indexPath.item];
}
NSString *const JQCollectionElementKindCell = @"JQCollectionElementKindCell";
static NSString *const kContentHeightWidth = @"kContentHeightWidth";
static NSString *const kItemRatio = @"kItemRatio";
static NSString *const kItemIndexPath = @"kItemIndexPath";

@implementation JQCollectionViewBrickLayout (cache)

- (void)jq_cacheLayoutAttribute:(UICollectionViewLayoutAttributes *)attribute of:(NSString *)kind at:(NSIndexPath *)indexPath
{
    NSString *key = JQGenerateCacheKey(kind, indexPath);
    self.layoutAttributes[key] = attribute;
}

- (UICollectionViewLayoutAttributes *)jq_cachedLayoutAttributeOf:(NSString *)kind at:(NSIndexPath *)indexPath
{
    NSString *key = JQGenerateCacheKey(kind, indexPath);
    return self.layoutAttributes[key];
}

@end

@implementation JQCollectionViewBrickLayout (calculate)

- (CGFloat)jq_calculateAndCacheItemRatios:(NSArray *)ratios maxLength:(CGFloat)maxLength preMax:(CGFloat)preMax spacing:(CGFloat)spacing start:(CGFloat)start maxItemReferenceSize:(CGSize)maxItemReferenceSize
{
    NSString *keyPath = [NSString stringWithFormat:@"@sum.%@", kItemRatio];
    CGFloat sumRatio = [[ratios valueForKeyPath:keyPath] floatValue];
    NSInteger count = ratios.count;
    CGFloat max = (maxLength - (count - 1) * spacing) / sumRatio;
    BOOL isVertical = self.scrollDirection == UICollectionViewScrollDirectionVertical;
    CGFloat maxReference = isVertical ? maxItemReferenceSize.height : maxItemReferenceSize.width;
    max = MIN(maxReference, max);
    CGFloat prePosition = start;
    for (int i = 0; i < count; i++)
    {
        NSDictionary *dict = ratios[i];
        NSIndexPath *indexPath = dict[kItemIndexPath];
        CGFloat ratio = [dict[kItemRatio] floatValue];
        CGFloat x = isVertical ? prePosition : preMax;
        CGFloat y = isVertical ? preMax : prePosition;
        CGFloat width = isVertical ? max * ratio : max;
        CGFloat height = isVertical ? max : max * ratio;
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = CGRectMake(x, y, width, height);
        [self jq_cacheLayoutAttribute:attr of:JQCollectionElementKindCell at:indexPath];
        prePosition += spacing + (isVertical ? width : height);
    }
    return max;
}

@end

@implementation JQCollectionViewBrickLayout

#pragma mark -
#pragma mark - prepare

- (void)prepareLayout
{
    [self.layoutAttributes removeAllObjects];
    self.layoutAttributes = [[NSMutableDictionary alloc] init];
    NSInteger sections = [self.collectionView numberOfSections];
    BOOL isVertical = self.scrollDirection == UICollectionViewScrollDirectionVertical;
    CGFloat preMax = 0.f;
    for (NSInteger section = 0; section < sections; section++)
    {
        NSInteger items = [self.collectionView numberOfItemsInSection:section];

        //*********************** layout info ***********************//
        CGFloat minimumInteritemSpacing = [self jq_minimumInteritemSpacingForSectionAtIndex:section];
        CGFloat minimumLineSpacing = [self jq_minimumLineSpacingForSectionAtIndex:section];
        CGSize maxItemReferenceSize = [self jq_maximumItemReferenceSizeForSectionAtIndex:section];
        CGFloat maxItemWidthHeight = isVertical ? maxItemReferenceSize.width : maxItemReferenceSize.height;
        BOOL hasHeader = [self jq_hasHeaderInSection:section];
        BOOL hasFooter = [self jq_hasFooterInSection:section];
        CGSize headerSize = [self jq_referenceSizeForHeaderInSection:section];
        CGSize footerSize = [self jq_referenceSizeForFooterInSection:section];
        UIEdgeInsets sectionInset = [self jq_insetForSectionAtIndex:section];
        UIEdgeInsets contentInset = self.collectionView.contentInset;
        CGFloat maxWidth = CGRectGetWidth(self.collectionView.frame) - contentInset.left - contentInset.right - sectionInset.left - sectionInset.right;
        CGFloat maxHeight = CGRectGetHeight(self.collectionView.frame) - contentInset.top - contentInset.bottom - sectionInset.top - sectionInset.bottom;
        CGFloat maxLength = isVertical ? maxWidth : maxHeight;

        //*********************** header ***********************//
        if (hasHeader)
        {
            UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headerAttr.frame = isVertical ? CGRectMake(0, preMax, self.collectionView.frame.size.width - contentInset.left - contentInset.right, headerSize.height) : CGRectMake(preMax, 0, headerSize.width, self.collectionView.frame.size.height - contentInset.top - contentInset.bottom);
            [self jq_cacheLayoutAttribute:headerAttr of:UICollectionElementKindSectionHeader at:[NSIndexPath indexPathForItem:0 inSection:section]];
            preMax += isVertical ? CGRectGetHeight(headerAttr.frame) : CGRectGetWidth(headerAttr.frame);
        }

        preMax += isVertical ? sectionInset.top : sectionInset.right;

        //*********************** cell ***********************//
        CGFloat totalLengthPerLine = 0.f;
        NSMutableArray *ratios = [[NSMutableArray alloc] init];
        for (NSInteger item = 0; item < items; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGFloat ratio = [self jq_ratioForItemHeightWidthAtIndexPath:indexPath];
            [ratios addObject:@{ kItemRatio: @(ratio),
                                 kItemIndexPath: indexPath }];
            totalLengthPerLine += ratio * maxItemWidthHeight;
            if (totalLengthPerLine > maxLength)
            {
                CGFloat start = isVertical ? sectionInset.left : sectionInset.top;
                CGFloat height = [self jq_calculateAndCacheItemRatios:ratios maxLength:maxLength preMax:preMax spacing:minimumInteritemSpacing start:start maxItemReferenceSize:maxItemReferenceSize];
                preMax += height + minimumLineSpacing;
                [ratios removeAllObjects];
                totalLengthPerLine = 0.f;
            }
            else if (item == items - 1)
            {
                CGFloat start = isVertical ? sectionInset.left : sectionInset.top;
                CGFloat height = [self jq_calculateAndCacheItemRatios:ratios maxLength:maxLength preMax:preMax spacing:minimumInteritemSpacing start:start maxItemReferenceSize:maxItemReferenceSize];
                preMax += height;
            }
        }
        if (items == 0)
        {
            preMax += isVertical ? sectionInset.top + sectionInset.bottom : sectionInset.left + sectionInset.right;
        }
        else
        {
            preMax += isVertical ? sectionInset.bottom : sectionInset.right;
        }

        //*********************** footer ***********************//
        if (hasFooter)
        {
            CGFloat biggestXY = preMax;
            UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            footerAttr.frame = isVertical ? CGRectMake(0, biggestXY, self.collectionView.frame.size.width - contentInset.left - contentInset.right, footerSize.height) : CGRectMake(biggestXY, 0, footerSize.width, self.collectionView.frame.size.height - contentInset.top - contentInset.bottom);
            [self jq_cacheLayoutAttribute:footerAttr of:UICollectionElementKindSectionFooter at:[NSIndexPath indexPathForItem:0 inSection:section]];
            preMax = isVertical ? CGRectGetMaxY(footerAttr.frame) : CGRectGetMaxX(footerAttr.frame);
        }
    }
    self.layoutAttributes[kContentHeightWidth] = @(preMax);
}

#pragma mark -
#pragma mark - layout

- (CGSize)collectionViewContentSize
{
    CGFloat contentHeightWidth = [self.layoutAttributes[kContentHeightWidth] floatValue];
    BOOL isVertical = self.scrollDirection == UICollectionViewScrollDirectionVertical;
    return isVertical ? CGSizeMake(self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right, contentHeightWidth) : CGSizeMake(contentHeightWidth, self.collectionView.frame.size.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attrs = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attr in self.layoutAttributes.allValues)
    {
        if (![attr isKindOfClass:[UICollectionViewLayoutAttributes class]]) continue;
        if (CGRectIntersectsRect(attr.frame, rect))
        {
            [attrs addObject:attr];
        }
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self jq_cachedLayoutAttributeOf:JQCollectionElementKindCell at:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return [self jq_cachedLayoutAttributeOf:elementKind at:indexPath];
}

@end
