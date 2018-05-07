//
//  ViewController.h
//  ContentAnalysis
//
//  Created by Patrick Alessi on 1/24/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textToAnalyzeTextView;
@property (weak, nonatomic) IBOutlet UITextView *extractedTermsTextView;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableString *capturedCharacters;
- (IBAction)analyzeContent:(id)sender;
- (void) parseXML;
@end
