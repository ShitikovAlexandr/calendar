//
//  NFTutorialCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFTutorialCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)addDataToCell;

@end