//
//  CellWithImageCollectionViewCell.h
//  FootBook
//
//  Created by Charles Northup on 4/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellWithImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *addButtonPressed;
@property NSString* photoID;

@end
