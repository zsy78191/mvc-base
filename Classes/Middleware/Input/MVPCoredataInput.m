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
#import "MVPProtocol.h"
@interface MVPCoredataInput() <NSFetchedResultsControllerDelegate>
{
    
}
@property (nonatomic, strong) NSFetchedResultsController* fetch;
@end

@implementation MVPCoredataInput

- (Class)mvp_modelClass
{
    return [NSManagedObjectModel class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@",[self mvp_modelClass]);
        
        NSFetchRequest* r = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self mvp_modelClass])];
        if ([self respondsToSelector:@selector(sortDescriptors)]) {
            [r setSortDescriptors:[self sortDescriptors]];
        }
        else {
           
        }
        
        if ([self respondsToSelector:@selector(predicate)]) {
            [r setPredicate:[self predicate]];
        }
        
        
        self.fetch = [[NSFetchedResultsController alloc] initWithFetchRequest:r managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
        
        [self.fetch setDelegate:self];
        
        NSError* error;
        [self.fetch performFetch:&error];
        NSLog(@"%@",error);
//        id<NSFetchedResultsSectionInfo> info = [[self.fetch sections] firstObject];
//        NSLog(@"%@",self.fetch);
//        NSLog(@"%@",[self.fetch fetchedObjects]);
//        NSLog(@"%@",@([info numberOfObjects]));
        
        
    }
    return self;
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
    return [[self mvp_modelClass] MR_countOfEntities];
}

- (id<MVPModelProtocol>)mvp_deleteModelAtIndexPath:(NSIndexPath *)path{
    __kindof NSManagedObject* o = [self.fetch objectAtIndexPath:path];
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

- (NSUInteger)mvp_insertModel:(id<MVPModelProtocol>)model atIndex:(NSUInteger)idx
{
    return [self mvp_addModel:model];
}

- (id<MVPModelProtocol>)mvp_modelAtIndexPath:(NSIndexPath *)path
{
    return [self.fetch objectAtIndexPath:path];
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
    [self.outputer beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.outputer insertSectionAtIndex:sectionIndex];
            break;
            
        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationLeft];
            [self.outputer deleteSectionAtIndex:sectionIndex];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(NSManagedObject*)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
//    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.outputer insertAtIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.outputer deleleAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.outputer updateAtIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.outputer deleleAtIndexPath:indexPath];
            [self.outputer insertAtIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.outputer endUpdates];
}


@synthesize outputer;


@end
