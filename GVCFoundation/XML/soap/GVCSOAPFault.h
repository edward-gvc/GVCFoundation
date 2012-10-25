/*
 * GVCSOAPFault.h
 * 
 * Created by David Aspinall on 2012-10-24. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "GVCXMLContainerNode.h"
#import "GVCXMLTextNode.h"

/**
 * <#description#>
 */
@interface GVCSOAPFault : GVCXMLContainerNode


@end


@interface GVCSOAPFaultCode : GVCXMLTextNode

@end

@interface GVCSOAPFaultString : GVCXMLTextNode

@end
