//
//  ViewController.m
//  ContentAnalysis
//
//  Created by Patrick Alessi on 1/24/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)analyzeContent:(id)sender {
    NSLog (@"analyzeContent");
    
    // Hide the keyboard
    [self.textToAnalyzeTextView resignFirstResponder];
    
    // Clear the old extracted terms
    self.extractedTermsTextView.text = @"";
    
    // Create a string for the URL
    NSString *urlString =
    @"http://query.yahooapis.com/v1/public/yql";
    
    // Create the NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Create a mutable request because we will append data to it.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval: 30.0];
    
    // Set the HTTP method of the request to POST
    [request setHTTPMethod:@"POST"];
    
    // Build a string for the parameters
    NSString *parameters = [[NSString alloc] initWithFormat:
                @"q=select * from contentanalysis.analyze where text='%@'",
                self.textToAnalyzeTextView.text];

    // Set the body of the request
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection =
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Make sure that the connection is good
    if (connection) {
        // Instantiate the responseData data structure to store to response
        self.responseData = [NSMutableData data];
        
    }
    else {
        NSLog (@"The connection failed");
    }
    

}

// Called when the connection has enough data to create an NSURLResponse
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    NSLog (@"connection:didReceiveResponse:");
    NSLog(@"expectedContentLength: %qi", [response expectedContentLength] );
    NSLog(@"textEncodingName: %@", [response textEncodingName]);
    
    [self.responseData setLength:0];
    
}

// Called each time the connection receives a chunk of data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSLog (@"connection:didReceiveData:");
    
    // Append the received data to our responseData property
    [self.responseData appendData:data];
    
}

// Called when the connection has successfully received the complete response
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog (@"connectionDidFinishLoading:");
    
    // Convert the data to a string and log the response string
    NSString *responseString = [[NSString alloc]
                                initWithData:self.responseData
                                encoding:NSUTF8StringEncoding];
    NSLog(@"Response String: \n%@", responseString);

    
    [self parseXML];
}

- (void) parseXML {
    NSLog (@"parseXML");
    
    // Initialize the parser with our NSData from the RSS feed
    NSXMLParser *xmlParser = [[NSXMLParser alloc]
                              initWithData:self.responseData];
    
    // Set the delegate to self
    [xmlParser setDelegate:self];
    
    // Start the parser
    if (![xmlParser parse])
    {
        NSLog (@"An error occurred in the parsing");
    }
    
}

// Called when the parser encounters a start element
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict {
    
    // Check to see which element we have found
    if ([elementName isEqualToString:@"text"]) {
        // Initialize the capturedCharacters instance variable
        self.capturedCharacters = [[NSMutableString alloc] initWithCapacity:100];
    }
}

// Called when the parser encounters an end element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog (@"didEndElement");
    
    // Check to see which element we have ended
    
    // We ended a Result element
    if ([elementName isEqualToString:@"text"]) {
        NSLog (@"capturedCharacters: %@" , self.capturedCharacters);
        
        self.extractedTermsTextView.text = [self.extractedTermsTextView.text
                                            stringByAppendingFormat:@"%@\n",
                                            self.capturedCharacters];
        
        // Clean up the capturedCharacters instance variable
        self.capturedCharacters = nil;
    }
    
    
    
}

// Called when the parser finds characters contained within an element
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.capturedCharacters != nil) {
        [self.capturedCharacters appendString:string];
    }
}



@end
