//
//  FoundFeetViewController.m
//  FootBook
//
//  Created by Charles Northup on 4/2/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "FoundFeetViewController.h"
#import "CellWithImageCollectionViewCell.h"

@interface FoundFeetViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray* photosArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation FoundFeetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   // myCollectionView.delegate = self;
   // myCollectionView.dataSource = self;
    //parsedUrls = [NSMutableArray new];
   // arrayOfPhotoData = [NSMutableArray new];
   // arrayOfAnimalPhotos = [NSMutableArray new];
   // sortedPhotos = [NSMutableArray new];
   // rows = arrayOfAnimalPhotos.count;
    photosArray = [NSMutableArray new];
    NSLog(@"hit");
    NSURL* url = [NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3b9f5d531b74e0c59b9393be78a30157&tags=feet&safe_search=1&per_page=100&place_id&has_geo&extras=+geo&format=json&nojsoncallback=1"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError* error;
        NSDictionary* feet = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary* feetPhotos = feet[@"photos"];
        NSArray* photos = feetPhotos[@"photo"];
        NSMutableArray* parsedUrls = [NSMutableArray new];
        NSMutableArray* arrayOfPhotoData = [NSMutableArray new];
        
//        for (NSDictionary*photo in photos) {
//            NSString* string = photo[@"latitude"];
//            NSLog(@"%@", string);
//            if (string.doubleValue > 3) {
//                [sortedPhotos addObject:photo];
//            }
//        }
    
        for (NSDictionary*photoInfo in photos) {
            NSURL* photoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", photoInfo[@"farm"], photoInfo[@"server"], photoInfo[@"id"], photoInfo[@"secret"]]];
            [parsedUrls addObject:photoUrl];
        }
        NSLog(@"%lu", (unsigned long)parsedUrls.count);
        for (NSURL*currentUrl in parsedUrls) {
            NSData* photoData = [NSData dataWithContentsOfURL:currentUrl];
            [arrayOfPhotoData addObject:photoData];
            
        }
        NSLog(@"%lu", (unsigned long)arrayOfPhotoData.count);
        NSLog(@"%@", [arrayOfPhotoData[0] class]);
        
        for (NSData*currentPhotoData in arrayOfPhotoData) {
            UIImage* feetImage = [UIImage imageWithData:currentPhotoData];
            [photosArray addObject:feetImage];
            
        }
        NSLog(@"%lu", (unsigned long)photosArray.count);
        
        //rows = arrayOfAnimalPhotos.count;
        [self.myCollectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellWithImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoReuseCellID" forIndexPath:indexPath];
    cell.image.image = [photosArray objectAtIndex:indexPath.row];
    NSLog(@"cell");
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return photosArray.count;
}


@end
