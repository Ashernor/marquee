//
//  FirstViewController.h
//  marquee
//
//  Created by Thomas Robin on 06/01/2016.
//  Copyright © 2016 thomasrobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *marqueesPosted;
@property (strong, nonatomic) IBOutlet UILabel *marqueesToday;

-(IBAction)sendMarquee:(id)sender;


@end

