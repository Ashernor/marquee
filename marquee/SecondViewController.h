//
//  SecondViewController.h
//  marquee
//
//  Created by Thomas Robin on 06/01/2016.
//  Copyright © 2016 thomasrobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATLabel.h"

@interface SecondViewController : UIViewController

@property (strong, nonatomic) NSArray *marqueeList;
@property (strong, nonatomic) IBOutlet ATLabel *animatedLabel;


@end

