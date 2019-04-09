//
//  MVPCoredataInput.m
//  mvc-base
//
//  Created by 张超 on 2018/12/22.
//  Copyright © 2018 orzer. All rights reserved.
//

#import "MVPCoredataInput.h"
//#import "Account+CoreDataProperties.h"
@import CoreData;
@import MagicalRecord;
@import oc_string;
#import "MVPProtocol.h"
@interface MVPCoredataInput() <NSFetchedResultsControllerDelegate>
{

}
@property (nonatomic, strong) NSFetchedResultsController* fetch;
@property (nonatomic, strong) NSMutableArray *sectionChanges;
@property (nonatomic, strong) NSMutableArray *itemChanges;
@end

@implementation MVPCoredataInput

- (id)allModels
{
    return [self.fetch fetchedObjects];
}

- (Class)mvp_modelClass
{
    return [NSManagedObjectModel class];
}

- (void)rebuildFetch
{
    self.fetch = nil;
}

- (BOOL)containsModel:(id<MVPModelProtocol>)model
{
    if (![model isKindOfClass:[NSManagedObject class]]) {
        return NO;
    }
    return !![self.fetch indexPathForObject:model];
//    return [[self allModels] containsObject:model];
}

- (NSFetchedResultsController *)fetch
{
    if (!_fetch) {
        NSFetchRequest* r = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self mvp_modelClass])];
        if ([self respondsToSelector:@selector(sortDescriptors)]) {
            [r setSortDescriptors:[self sortDescriptors]];
        }
        else {
            
        }
        
        if ([self respondsToSelector:@selector(predicate)]) {
            [r setPredicate:[self predicate]];
        }
   
        
        if ([self fetchLimitCount] != 0) {
            r.fetchLimit = [self fetchLimitCount];
        }
        
        _fetch = [[NSFetchedResultsController alloc] initWithFetchRequest:r managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:[self sectionKeyPath] cacheName:nil];
        
        [_fetch setDelegate:self];
        
        NSError* error;
        [_fetch performFetch:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    return _fetch;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.complexSection = 0;
    }
    return self;
}

- (NSUInteger)fetchLimitCount
{
    return 0;
}

- (NSString*)sectionKeyPath
{
    return nil;
}

- (id<MVPModelProtocol>)dataAtIndex:(NSUInteger)idx { 
    return [self.fetch objectAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
}

- (NSUInteger)mvp_addModel:(id<MVPModelProtocol>)model {
    NSManagedObjectContext* context = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObject* o = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self mvp_modelClass]) inManagedObjectContext:context];
    if ([self respondsToSelector:@selector(loadCoreData:fromModel:)]) {
        [self loadCoreData:o fromModel:model];
    }
    NSError*e;
    [context save:&e];
//    NSLog(@"%@",e);
    return 1;
}

- (NSUInteger)mvp_count {
//    id<NSFetchedResultsSectionInfo> info = [[self.fetch sections] firstObject];
//    return [info numberOfObjects];
//    return [[self mvp_modelClass] MR_countOfEntities];
    return [self.fetch fetchedObjects].count;
}

- (id<MVPModelProtocol>)mvp_deleteModelAtIndexPath:(NSIndexPath *)path{
    __kindof NSManagedObject* o  = nil;
    if (self.complexSection != 0 && path.section > 0) {
        o = [self.fetch objectAtIndexPath:[NSIndexPath indexPathForRow:path.row inSection:0]];
    }
    else {
        o = [self.fetch objectAtIndexPath:path];
    }
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSManagedObject* o2 = [o MR_inContext:localContext];
        [o2 MR_deleteEntity];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    return nil;
}

- (void)mvp_deleteModel:(id<MVPModelProtocol>)model
{
    NSIndexPath* p = [self mvp_indexPathWithModel:model];
    [self mvp_deleteModelAtIndexPath:p];
}

- (NSUInteger)mvp_insertModel:(id<MVPModelProtocol>)model atIndex:(NSUInteger)idx
{
    return [self mvp_addModel:model];
}

- (id<MVPModelProtocol>)mvp_modelAtIndexPath:(NSIndexPath *)path
{
    if (self.complexSection != 0 && path.section > 0) {
        id d = [self.fetch objectAtIndexPath:[NSIndexPath indexPathForRow:path.row inSection:0]];
        return d;
    }
    id d = [self.fetch objectAtIndexPath:path];
    return d;
}

- (void)mvp_moveModelFromIndexPath:(NSIndexPath *)path1 toPath:(NSIndexPath *)path2
{
    NSLog(@"%s 不能使用",__func__);
}

- (void)mvp_cleanAll
{
    NSLog(@"%s 不能使用",__func__);
}

- (NSIndexPath *)mvp_indexPathWithModel:(id<NSFetchRequestResult>)model
{
    return [self.fetch indexPathForObject:model];
}

- (void)mvp_updateModel:(id<MVPModelProtocol>)model atIndexPath:(NSIndexPath*)path { 
    __kindof NSManagedObject* o = [self.fetch objectAtIndexPath:path];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSManagedObject* o2 = [o MR_inContext:localContext];
        if ([self respondsToSelector:@selector(loadCoreData:fromModel:)]) {
            [self loadCoreData:o2 fromModel:model];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    id<NSFetchedResultsSectionInfo> info = [[self.fetch sections] firstObject];
    return [info numberOfObjects];
}

- (NSUInteger)numberOfSections { 
     return [[self.fetch sections] count];
}

- (void)loadCoreData:(__kindof NSManagedObject *)obj fromModel:(id<MVPModelProtocol>)model
{
    NSArray* p = [model propertys];
    [p enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:[(id)model valueForKey:obj2] forKey:obj2];
//        [obj setObject:[(id)model valueForKey:obj2] forKey:obj2];
    }];
}

#pragma mark - fetch



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
     if ([self.outputer respondsToSelector:@selector(performBatchUpdates:completion:)]) {
     }
     else {
         [self.outputer beginUpdates];
     }
    self.sectionChanges = [[NSMutableArray alloc] init];
    self.itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if ([self.outputer respondsToSelector:@selector(performBatchUpdates:completion:)]) {
        NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
        change[@(type)] = @(sectionIndex);
        [self.sectionChanges addObject:change];
    }
    else {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.outputer insertSectionAtIndex:sectionIndex];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.outputer deleteSectionAtIndex:sectionIndex];
                break;
                
            default:
                return;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(NSManagedObject*)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([self.outputer respondsToSelector:@selector(performBatchUpdates:completion:)]) {
        NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
        switch(type) {
            case NSFetchedResultsChangeInsert:
                change[@(type)] = newIndexPath;
                break;
            case NSFetchedResultsChangeDelete:
                change[@(type)] = indexPath;
                break;
            case NSFetchedResultsChangeUpdate:
                change[@(type)] = indexPath;
                break;
            case NSFetchedResultsChangeMove:
                change[@(type)] = @[indexPath, newIndexPath];
                break;
        }
        [self.itemChanges addObject:change];
    }
    else {
        NSIndexPath* p1 = newIndexPath;
        NSIndexPath* p2 = indexPath;
        if (self.complexSection != 0) {
            p1 = [NSIndexPath indexPathForRow:p1.row inSection:self.complexSection];
            p2 = [NSIndexPath indexPathForRow:p2.row inSection:self.complexSection];
        }
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.outputer insertAtIndexPath:p1];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.outputer deleleAtIndexPath:p2];
                break;
                
            case NSFetchedResultsChangeUpdate:
//                [self.outputer updateAtIndexPath:p2];
                break;
                
            case NSFetchedResultsChangeMove:
//                [self.outputer deleleAtIndexPath:indexPath];
//                [self.outputer insertAtIndexPath:p1];
                [self.outputer moveFromIndexPath:indexPath toIndexPath:p1];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([self.outputer respondsToSelector:@selector(performBatchUpdates:completion:)]) {
        [self.outputer performBatchUpdates:^{
            for (NSDictionary *change in self.sectionChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch(type) {
                        case NSFetchedResultsChangeInsert:
                            [self.outputer insertSectionAtIndex:[obj unsignedIntegerValue]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.outputer deleteSectionAtIndex:[obj unsignedIntegerValue]];
                            break;
                        case NSFetchedResultsChangeMove:
                            
                            break;
                        case NSFetchedResultsChangeUpdate:
                            
                            break;
                    }
                }];
            }
            for (NSDictionary *change in self.itemChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    id x = nil;
                    if ([obj isKindOfClass:[NSIndexPath class]]) {
                        NSIndexPath* p = obj;
                        if (self.complexSection != 0) {
                            p = [NSIndexPath indexPathForRow:p.row inSection:self.complexSection];
                        }
                        x = p;
                    }
                    else if([obj isKindOfClass:[NSArray class]])
                    {
                        NSArray* p = obj;
                        if (self.complexSection != 0) {
                            p = p.map(^id _Nonnull(NSIndexPath*  _Nonnull x) {
                                
                                return [NSIndexPath indexPathForRow:x.row inSection:self.complexSection];
                            });
                        }
                        x = p;
                    }
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch(type) {
                        case NSFetchedResultsChangeInsert:
                            [self.outputer insertAtIndexPaths:@[x]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.outputer deleleAtIndexPaths:@[x]];
                            break;
                        case NSFetchedResultsChangeUpdate:
//                            [self.outputer updateAtIndexPaths:@[x]];
                            break;
                        case NSFetchedResultsChangeMove:
                            //                        [self.outputer moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
//                            [self.outputer deleleAtIndexPath:x[0]];
//                            [self.outputer insertAtIndexPath:x[1]];
                            [self.outputer moveFromIndexPath:x[0] toIndexPath:x[1]];
                            break;
                    }
                }];
            }
        } completion:^(BOOL finished) {
            self.sectionChanges = nil;
            self.itemChanges = nil;
        }];
    }
    else {
        [self.outputer endUpdates];
    }
}




@synthesize outputer;


@synthesize complexSection;

@end
