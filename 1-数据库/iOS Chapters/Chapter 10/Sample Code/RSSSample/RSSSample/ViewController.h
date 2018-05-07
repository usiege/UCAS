//
//  ViewController.h
//  RSSSample
//
//  Created by Patrick Alessi on 1/8/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate>


@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableString *capturedCharacters;
@property (nonatomic) BOOL inItemElement;

@property (weak, nonatomic) IBOutlet UITextView *textView;


- (IBAction)buttonTapped:(id)sender;

- (void) parseXML;


@end
