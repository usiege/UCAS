//
//  ViewController.m
//  RSSSample
//
//  Created by Patrick Alessi on 1/8/13.
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

- (IBAction)buttonTapped:(id)sender {
    NSLog(@"buttonTapped");
    
    // Create the Request.
    NSURLRequest *request = [NSURLRequest requestWithURL:
        [NSURL URLWithString:@"http://rss.cnn.com/rss/cnn_topstories.rss"]
        cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval: 30.0];
    
    // Create the connection and send the request
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

// Called when a redirect will cause the URL of the request to change
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse

{
    NSLog (@"connection:willSendRequest:redirectResponse:");
    return request;
}

// Called when the server requires authentication
- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog (@"connection:didReceiveAuthenticationChallenge:");
}

// Called when the authentication challenge is cancelled on the connection
- (void)connection:(NSURLConnection *)connection
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog (@"connection:didCancelAuthenticationChallenge:");
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

// Called before the response is cached
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSLog (@"connection:willCacheResponse:");
    // Simply return the response to cache
    return cachedResponse;
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

// Called when an error occurs in loading the response
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog (@"connection:didFailWithError:");
    
    NSLog (@"%@",[error localizedDescription]);
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

// Called when the parser begins parsing the document
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog (@"parserDidStartDocument");
    self.inItemElement = NO;
}
// Called when the parser finishes parsing the document
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog (@"parserDidEndDocument");
}

// Called when the parser encounters a start element
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qualifiedName
     attributes:(NSDictionary *)attributeDict {
    NSLog (@"didStartElement");
    
    // Check to see which element we have found
    if ([elementName isEqualToString:@"item"]) {
        // We are in an item element
        self.inItemElement = YES;
    }
    
    // If we are in an item and found a title
    if (self.inItemElement && [elementName isEqualToString:@"title"]) {
        // Initialize the capturedCharacters instance variable
        self.capturedCharacters = [[NSMutableString alloc] initWithCapacity:100];
    }
}

// Called when the parser encounters an end element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSLog (@"didEndElement");
    
    // Check to see which element we have ended
    
    // If we are in an item and ended a title
    if (self.inItemElement && [elementName isEqualToString:@"title"]) {
        NSLog (@"capturedCharacters: %@" , self.capturedCharacters);
        
        self.textView.text = [self.textView.text
                              stringByAppendingFormat:@"%@\n\n",self.capturedCharacters];
        
        // Clean up the capturedCharacters instance variable
        self.capturedCharacters = nil;
    }
    
    
    if ([elementName isEqualToString:@"item"]) {
        // We are no longer in an item element
        self.inItemElement = NO;
    }
    
}

// Called when the parser finds characters contained within an element
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.capturedCharacters != nil) {
        [self.capturedCharacters appendString:string];
    }
}


@end
