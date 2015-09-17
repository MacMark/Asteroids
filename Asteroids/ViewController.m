//
//  ViewController.m
//  Asteroids
//
//  Created by Markus Möller on 17/09/15.
//  Copyright © 2015 Markus Möller. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.asteroids.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Basic" forIndexPath:indexPath];
    
    NSString *name = [self.asteroids objectAtIndex:indexPath.row][@"full_name"];
    cell.textLabel.text = [NSString stringWithFormat:@"Name: %@", name];
    NSString *distance = [self.asteroids objectAtIndex:indexPath.row][@"closeness"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Entfernung: %@", distance];
    return cell;
}

#pragma mark - button action

- (IBAction)refreshDistance:(UIButton *)sender {
    [self.minDistanceField endEditing:YES];
    [self.maxDistanceField endEditing:YES];
    NSNumber *minDistance = @([self.minDistanceField.text floatValue]);
    NSNumber *maxDistance = @([self.maxDistanceField.text floatValue]);
    [self updateAsteroidsWithMinimumDistance:minDistance maximumDistance:maxDistance];
}

#pragma mark - simple requests

- (void)updateAsteroidsWithMinimumDistance:(NSNumber *)minDistance maximumDistance:(NSNumber *)maxDistance {
    
    if (maxDistance.floatValue <= 0.0f) return;
    
    // Example URL
    // http://asterank.com/api/asterank?query={"closeness":{"$gt":3001.0}}&{"closeness":{"$lt":3010.0}}&limit=3
    
    NSString *urlString = @"http://asterank.com/api/asterank?query={\"closeness\":{\"$gt\":MIN}}&{\"closeness\":{\"$lt\":MAX}}&limit=42";
    
    NSString *urlStringWithDistance = nil;
    urlStringWithDistance = [urlString stringByReplacingOccurrencesOfString:@"MAX" withString:[maxDistance description]];
    urlStringWithDistance = [urlString stringByReplacingOccurrencesOfString:@"MIN" withString:[minDistance description]];
    
    NSString *urlEscapedString = [urlStringWithDistance stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *asteroidUrl = [NSURL URLWithString:urlEscapedString];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    [[urlSession dataTaskWithURL:asteroidUrl
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSError *parsingError = nil;
                id updatedAsteroids = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parsingError];
                
                if (parsingError) {
                    NSLog(@"Error during parsing asteroids: %@", [parsingError localizedDescription]);
                    self.asteroids = nil;
                }
                else {
                    NSLog(@"Asteroid data %@", updatedAsteroids);
                    self.asteroids = updatedAsteroids;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.asteroidsTable reloadData];
                    });
                }

                
            }] resume];
}

@end
