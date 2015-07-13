// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to XMMCoreData.h instead.

#import <CoreData/CoreData.h>

extern const struct XMMCoreDataAttributes {
	__unsafe_unretained NSString *checksum;
	__unsafe_unretained NSString *systemId;
	__unsafe_unretained NSString *systemName;
	__unsafe_unretained NSString *systemUrl;
} XMMCoreDataAttributes;

@interface XMMCoreDataID : NSManagedObjectID {}
@end

@interface _XMMCoreData : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) XMMCoreDataID* objectID;

@property (nonatomic, strong) NSString* checksum;

//- (BOOL)validateChecksum:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* systemId;

//- (BOOL)validateSystemId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* systemName;

//- (BOOL)validateSystemName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* systemUrl;

//- (BOOL)validateSystemUrl:(id*)value_ error:(NSError**)error_;

@end

@interface _XMMCoreData (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveChecksum;
- (void)setPrimitiveChecksum:(NSString*)value;

- (NSString*)primitiveSystemId;
- (void)setPrimitiveSystemId:(NSString*)value;

- (NSString*)primitiveSystemName;
- (void)setPrimitiveSystemName:(NSString*)value;

- (NSString*)primitiveSystemUrl;
- (void)setPrimitiveSystemUrl:(NSString*)value;

@end
