/*
 * GVCNetworking.m
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCNetworking.h"
#import <objc/runtime.h>

GVC_DEFINE_STRVALUE(GVC_HTTP_METHOD_KEY_get,	GET)
GVC_DEFINE_STRVALUE(GVC_HTTP_METHOD_KEY_post,	POST)

GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_content_type,   Content-Type)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_content_length,	Content-Length)

GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_cache_control,  Cache-Control)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_connection,     Connection)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_date,           Date)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_expires,        Expires)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_keep_alive,     Keep-Alive)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_mime_version,   MIME-Version)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_pragma,         Pragma)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_server,         Server)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_set_cookie,     Set-Cookie)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_cookie,         Cookie)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_transfer_encoding, Transfer-Encoding)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_soap_action,	SOAPAction)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_user_agent,		User-Agent)
GVC_DEFINE_STRVALUE(GVC_HTTP_HEADER_KEY_host,			Host)

#pragma mark - encoding Types
GVC_DEFINE_STRVALUE(GVC_ENCODING_TYPE_ascii,		ascii)
GVC_DEFINE_STRVALUE(GVC_ENCODING_TYPE_isolatin1,	isolatin1)
GVC_DEFINE_STRVALUE(GVC_ENCODING_TYPE_isolatin2,	isolatin2)
GVC_DEFINE_STRVALUE(GVC_ENCODING_TYPE_iso2022jp,	iso2022jp)
GVC_DEFINE_STRVALUE(GVC_ENCODING_TYPE_utf8,			utf8)
GVC_DEFINE_STRVALUE(GVC_ENCODING_TYPE_utf16,		utf16)

#pragma mark - HTTP Headers

static NSCharacterSet *gvc_rfc1521_special_characterset = nil;
NSCharacterSet *gvc_RFC1521SpecialCharacters(void)
{
    static dispatch_once_t gvc_rfc1521_special_charactersetDispatch;
	dispatch_once(&gvc_rfc1521_special_charactersetDispatch, ^{
        gvc_rfc1521_special_characterset = [NSCharacterSet characterSetWithCharactersInString:@"()<>@,;:\\\"/[]?="];
    });
    return gvc_rfc1521_special_characterset;
    
}

static NSCharacterSet *gvc_rfc1521_token_characterset = nil;
NSCharacterSet *gvc_RFC1521TokenCharacters(void)
{
    static dispatch_once_t gvc_rfc1521_token_charactersetDispatch;
	dispatch_once(&gvc_rfc1521_token_charactersetDispatch, ^{
        NSMutableCharacterSet *workingSet = [[gvc_RFC1521SpecialCharacters() invertedSet] mutableCopy];
        [workingSet removeCharactersInString:@" "];
        [workingSet formIntersectionWithCharacterSet:[[NSCharacterSet controlCharacterSet] invertedSet]];
        [workingSet addCharactersInString:@"/"];

        gvc_rfc1521_token_characterset = [workingSet copy];
    });
    return gvc_rfc1521_token_characterset;
    
}

static NSCharacterSet *gvc_rfc1521_non_token_characterset = nil;
NSCharacterSet *gvc_RFC1521NonTokenCharacters(void)
{
    static dispatch_once_t gvc_rfc1521_non_token_charactersetDispatch;
	dispatch_once(&gvc_rfc1521_non_token_charactersetDispatch, ^{
        NSMutableCharacterSet *workingSet = [[gvc_RFC1521SpecialCharacters() invertedSet] mutableCopy];
        [workingSet removeCharactersInString:@" "];
        [workingSet formIntersectionWithCharacterSet:[[NSCharacterSet controlCharacterSet] invertedSet]];
        
        gvc_rfc1521_non_token_characterset = [workingSet invertedSet];
    });
    return gvc_rfc1521_non_token_characterset;
    
}

#pragma mark - MIME Types
GVC_DEFINE_STRVALUE(GVC_MIME_TYPE_text_xml,	text/xml)


static NSSet *gvc_mimetype_image_set = nil;
NSSet *gvc_MimeType_Images(void)
{
    static dispatch_once_t gvc_mimetype_image_setDispatch;
	dispatch_once(&gvc_mimetype_image_setDispatch, ^{
        gvc_mimetype_image_set = [[NSSet alloc] initWithObjects: @"image/tiff", @"image/jpeg", @"image/gif", @"image/png", @"image/ico", @"image/x-icon", @"image/bmp", @"image/x-bmp", @"image/x-xbitmap", @"image/x-win-bitmap", nil];
    });
    return gvc_mimetype_image_set;
}

