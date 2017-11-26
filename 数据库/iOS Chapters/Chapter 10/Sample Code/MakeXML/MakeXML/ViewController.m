//
//  ViewController.m
//  MakeXML
//
//  Created by Patrick Alessi on 1/14/13.
//  Copyright (c) 2013 Patrick Alessi. All rights reserved.
//

#import "ViewController.h"
#import <libxml/parser.h>
#import <libxml/tree.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateXML];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) generateXML {
    xmlDocPtr doc;
    xmlNodePtr rootNode;
    
    // Create a new xml document
    doc = xmlNewDoc(BAD_CAST "1.0");
    
    // Create the root node
    rootNode = xmlNewNode(NULL, BAD_CAST "rootNode");
    
    // Set the root of the document
    xmlDocSetRootElement(doc, rootNode);
    
    // Create a new child off the root
    xmlNewChild(rootNode, NULL, BAD_CAST "ChildNode1",
                BAD_CAST "Child Node Content");
    
    // Add a node with attributes
    xmlNodePtr attributedNode;
    attributedNode = xmlNewChild (rootNode, NULL,
                                  BAD_CAST "AttributedNode", NULL);
    xmlNewProp(attributedNode, BAD_CAST "attribute1", BAD_CAST "First");
    xmlNewProp(attributedNode, BAD_CAST "attribute2", BAD_CAST "Second");
    
    // Create a node as a child of the attributed node
    xmlNewChild (attributedNode, NULL, BAD_CAST "AttributedChild",
                 BAD_CAST "Attributed Node Child Node");
    
    // You can also build nodes and text separately then and add them
    // to the tree later
    xmlNodePtr attachNode = xmlNewNode(NULL, BAD_CAST "AttachedNode");
    xmlNodePtr nodeText = xmlNewText(BAD_CAST "Attached Node Text");
    // Add the text to the node
    xmlAddChild(attachNode, nodeText);
    // Add the node to the root
    xmlAddChild(rootNode, attachNode);
    
    // You can even include comments
    xmlNodePtr comment;
    comment = xmlNewComment(BAD_CAST "This is an XML Comment");
    xmlAddChild(rootNode, comment);
    
    
    
    // Write the doc
    xmlChar *outputBuffer;
    int bufferSize;
    
    // You are responsible for freeing the buffer using xmlFree
    // Dump the document to a buffer
    xmlDocDumpFormatMemory(doc, &outputBuffer, &bufferSize, 1);
    
    // Create an NSString from the buffer
    NSString *xmlString = [[NSString alloc] initWithBytes:outputBuffer
                                                   length:bufferSize
                                                 encoding:NSUTF8StringEncoding];
    
    // Log the XML string that we created
    NSLog (@"output: \n%@", xmlString);
    
    // Display the text in the textview
    [self.textView setText:xmlString];
        
    // Clean up
    // Free the output buffer
    xmlFree(outputBuffer);
    
    // Release all of the structures in the document including the tree
    xmlFreeDoc(doc);
    xmlCleanupParser();
    
}


@end
