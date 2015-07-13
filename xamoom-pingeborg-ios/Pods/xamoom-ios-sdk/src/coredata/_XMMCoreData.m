// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreData.m instead.

#import "_XMMCoreData.h"

const struct XMMCoreDataAttributes XMMCoreDataAttributes = {
	.checksum = @"checksum",
	.systemId = @"systemId",
	.systemName = @"systemName",
	.systemUrl = @"systemUrl",
};

@implementation XMMCoreDataID
@end

@implementation _XMMCoreData

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"XMMCoreData" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"XMMCoreData";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"XMMCoreData" inManagedObjectContext:moc_];
}

- (XMMCoreDataID*)objectID {
	return (XMMCoreDataID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic checksum;

@dynamic systemId;

@dynamic systemName;

@dynamic systemUrl;

@end

