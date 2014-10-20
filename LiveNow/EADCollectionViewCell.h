//
//  EADCollectionViewCell.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 10/5/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventCreatedBy;

@end
