//
//  DetailViewController.h
//  FootBook
//
//  Created by Charles Northup on 4/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UISwitch *friendSwitch;

@property BOOL friended;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
