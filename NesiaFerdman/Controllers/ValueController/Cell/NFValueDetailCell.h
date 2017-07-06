//
//  NFValueDetailCell.h
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 7/6/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFManifestation.h"

@interface NFValueDetailCell : UITableViewCell
@property (strong, nonatomic) NFManifestation *manifestation;

- (void)addDataToCell:(NFManifestation*)manifestation;

@end
