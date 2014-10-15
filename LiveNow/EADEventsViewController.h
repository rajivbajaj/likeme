//
//  EADEventsViewController.h
//  LiveNow
//
//  Created by Rajiv Bajaj on 9/17/14.
//  Copyright (c) 2014 EliteAppDesigner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EADCollectionViewCell.h"
@interface EADEventsViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *eventsArray;
@end
