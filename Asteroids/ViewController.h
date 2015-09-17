//
//  ViewController.h
//  Asteroids
//
//  Created by Markus Möller on 17/09/15.
//  Copyright © 2015 Markus Möller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *asteroidsTable;
@property (weak, nonatomic) IBOutlet UITextField *minDistanceField;
@property (weak, nonatomic) IBOutlet UITextField *maxDistanceField;

@property (strong, nonatomic) NSArray *asteroids;

@end

