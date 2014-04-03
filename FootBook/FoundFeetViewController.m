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
@property (strong, nonatomic) NSIndexPath* indexPathForSelectedCell;
@property NSMutableArray* photosToPost;
@property NSMutableArray* searchedPhotoIDs;
@property NSMutableArray* postedPhotoIDs;
@end

@implementation FoundFeetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosToPost = [NSMutableArray new];
    self.postedPhotoIDs = [NSMutableArray new];
    self.searchedPhotoIDs = [NSMutableArray new];
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
            [self.searchedPhotoIDs addObject:photoInfo[@"id"]];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CellWithImageCollectionViewCell *cell = (CellWithImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.addButtonPressed.enabled = YES;
    self.indexPathForSelectedCell = indexPath;
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CellWithImageCollectionViewCell *cell = (CellWithImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.addButtonPressed.enabled = NO;
}

-(IBAction)addButtonPressedForFavorite:(id)sender{
    CellWithImageCollectionViewCell* cell = (CellWithImageCollectionViewCell*)[self.myCollectionView cellForItemAtIndexPath:self.indexPathForSelectedCell];
    [self.photosToPost addObject:cell.image.image];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellWithImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoReuseCellID" forIndexPath:indexPath];
    cell.image.image = [photosArray objectAtIndex:indexPath.row];
    cell.addButtonPressed.enabled = NO;
    cell.photoID = self.searchedPhotoIDs[indexPath.row];
    if ([self.postedPhotoIDs containsObject:cell.photoID]) {
        cell.addButtonPressed.hidden = YES;
    }
    else{
        cell.addButtonPressed.hidden = NO;
    }
    NSLog(@"cell");
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return photosArray.count;
}


@end
