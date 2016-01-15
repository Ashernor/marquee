//
//  FirstViewController.m
//  marquee
//
//  Created by Thomas Robin on 06/01/2016.
//  Copyright © 2016 thomasrobin. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self refreshMarqueesCounter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendMarquee:(id)sender {
    NSString *marqueeText = [_textField text];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastMarquee"];
    
    int timeInterval = 61;
    if (oldDate != nil)
       timeInterval = abs((int)[oldDate timeIntervalSinceNow]/60);
    
    NSLog(@"%i",timeInterval);
    
    if (timeInterval > 60){
        PFObject *marqueeObject = [PFObject objectWithClassName:@"Marquee"];
        marqueeObject[@"content"] = marqueeText;
        [marqueeObject saveInBackground];
        [_textField setText:@""];
        [_textField resignFirstResponder];
        [userDefaults setObject:[NSDate date] forKey:@"lastMarquee"];
        [self refreshMarqueesCounter];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry !" message:@"You can oly post one marquee per hour" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)refreshMarqueesCounter {
    PFQuery *queryTotal = [PFQuery queryWithClassName:@"Marquee"];
    [queryTotal countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        [_marqueesPosted setText:[NSString stringWithFormat:@"%d",count]];
    }];
    
    PFQuery *queryToday = [PFQuery queryWithClassName:@"Marquee"];
    [queryToday countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        [_marqueesToday setText:[NSString stringWithFormat:@"%d",count]];
    }];
}


@end
