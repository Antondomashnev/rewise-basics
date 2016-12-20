//
//  AppDelegate.m
//  rewise-basics
//
//  Created by Anton Domashnev on 20/12/2016.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

#import "AppDelegate.h"
#import "Graph.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSArray *)insertionSort:(NSArray *)input {
    NSMutableArray *mutableInput = [input mutableCopy];
    for (NSInteger i = 0; i < [input count]; i++) {
        NSNumber *value = input[i];
        for (NSInteger k = i; k > 0; k--) {
            if ([mutableInput[k - 1] integerValue] > [value integerValue]) {
                mutableInput[k] = mutableInput[k - 1];
                mutableInput[k - 1] = value;
                continue;
            }
            break;
        }
    }
    return [mutableInput copy];
}

//****************************************************//

- (NSArray *)merge:(NSArray *)array1 with:(NSArray *)array2 {
    NSMutableArray *result = [NSMutableArray array];
    NSInteger leftIndex = 0;
    NSInteger rightIndex = 0;
    while (leftIndex < [array1 count] && rightIndex < [array2 count]) {
        if ([array1[leftIndex] integerValue] < [array2[rightIndex] integerValue]) {
            [result addObject:array1[leftIndex]];
            leftIndex++;
        }
        else if ([array1[leftIndex] integerValue] > [array2[rightIndex] integerValue]) {
            [result addObject:array2[rightIndex]];
            rightIndex++;
        }
        else {
            [result addObject:array1[leftIndex]];
            leftIndex++;
            [result addObject:array2[rightIndex]];
            rightIndex++;
        }
    }
    
    while (leftIndex < [array1 count]) {
        [result addObject:array1[leftIndex]];
        leftIndex++;
    }
    
    while (rightIndex < [array2 count]) {
        [result addObject:array2[rightIndex]];
        rightIndex++;
    }
    
    return [result copy];
}

- (NSArray *)mergeSort:(NSArray *)input {
    if ([input count] == 1) {
        return input;
    }
    NSInteger middle = [input count] / 2;
    NSMutableArray *leftPart = [NSMutableArray array];
    for (NSInteger i = 0; i < middle; i++) {
        [leftPart addObject:input[i]];
    }
    NSMutableArray *rightPath = [NSMutableArray array];
    for (NSInteger i = middle; i < [input count]; i++) {
        [rightPath addObject:input[i]];
    }
    NSArray *leftResult = [self mergeSort:leftPart];
    NSArray *rightResult = [self mergeSort:rightPath];
    
    return [self merge:leftResult with:rightResult];
}

//*******************************************************//

- (NSInteger)lomutosPartioning:(NSMutableArray *)array lower:(NSInteger)lower higher:(NSInteger)higher {
    NSNumber *pivot = array[higher];
    NSInteger i = lower;
    for (NSInteger j = lower; j < higher; j++) {
        if ([array[j] integerValue] >= [pivot integerValue]) {
            continue;
        }
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;
    }
    [array exchangeObjectAtIndex:i withObjectAtIndex:higher];
    return i;
}

- (void)lomutosQuickSort:(NSMutableArray *)input lower:(NSInteger)lower higher:(NSInteger)higher {
    if (lower >= higher) {
        return;
    }
    NSInteger lomutosIndex = [self lomutosPartioning:input lower:lower higher:higher];
    [self lomutosQuickSort:input lower:lower higher:lomutosIndex - 1];
    [self lomutosQuickSort:input lower:lomutosIndex + 1 higher:higher];
}

//*******************************************************//

- (NSInteger)hoaresPartioning:(NSMutableArray *)array lower:(NSInteger)lower higher:(NSInteger)higher {
    NSNumber *pivot = array[lower];
    NSInteger i = lower - 1;
    NSInteger j = higher + 1;
    while (true) {
        do {
            i++;
        } while ([array[i] integerValue] < [pivot integerValue]);
        do {
            j--;
        } while ([array[j] integerValue] > [pivot integerValue]);
        if (i >= j) {
            return j;
        }
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
}

- (void)hoaresQuickSort:(NSMutableArray *)input lower:(NSInteger)lower higher:(NSInteger)higher {
    if (lower >= higher) {
        return;
    }
    NSInteger hoaresIndex = [self hoaresPartioning:input lower:lower higher:higher];
    [self hoaresQuickSort:input lower:lower higher:hoaresIndex];
    [self hoaresQuickSort:input lower:hoaresIndex + 1 higher:higher];
}

//*******************************************************//

- (CGPoint)dutchPartioning:(NSMutableArray *)array lower:(NSInteger)lower higher:(NSInteger)higher pivotIndex:(NSInteger)pivotIndex {
    NSNumber *pivot = array[pivotIndex];
    
    NSInteger smaller = lower;
    NSInteger equal = lower;
    NSInteger greater = higher;
    
    while (equal <= greater) {
        if ([array[equal] integerValue] < [pivot integerValue]) {
            [array exchangeObjectAtIndex:equal withObjectAtIndex:smaller];
            smaller++;
            equal++;
        }
        else if ([array[equal] integerValue] == [pivot integerValue]) {
            equal++;
        }
        else {
            [array exchangeObjectAtIndex:equal withObjectAtIndex:greater];
            greater--;
        }
    }
    return CGPointMake(smaller, greater);
}

- (void)dutchQuickSort:(NSMutableArray *)input lower:(NSInteger)lower higher:(NSInteger)higher {
    if (lower >= higher) {
        return;
    }
    CGPoint dutchIndexes = [self dutchPartioning:input lower:lower higher:higher pivotIndex:higher];
    [self dutchQuickSort:input lower:lower higher:dutchIndexes.x - 1];
    [self dutchQuickSort:input lower:dutchIndexes.y + 1 higher:higher];
}

//*******************************************************//

- (NSArray *)bucketSort:(NSArray *)input {
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *buckets = [NSMutableArray array];
    NSNumber *minimum = [input valueForKeyPath:@"@min.self"];
    NSNumber *maximum = [input valueForKeyPath:@"@max.self"];
    NSInteger numberOfBuckets = ([maximum integerValue] - [minimum integerValue]) / 2;
    for (NSInteger k = 0; k < numberOfBuckets; k++) {
        [buckets addObject:[NSMutableArray array]];
    }
    for (NSInteger i = 0; i < [input count]; i++) {
        NSInteger bucketNumber = [input[i] integerValue] / 2;
        [buckets[bucketNumber] addObject:input[i]];
    }
    for (NSInteger k = 0; k < numberOfBuckets; k++) {
        [result addObjectsFromArray:[self insertionSort:buckets[k]]];
    }
    return [result copy];
}

//*******************************************************//

- (void)heapSort:(NSMutableArray *)input upperBound:(NSInteger)upperBound {
    if ([input count] == 0) {
        return;
    }
    if (upperBound == 0) {
        return;
    }
    
    NSInteger maxElementIndex = 0;
    NSNumber *maxElement = input[0];
    for (NSInteger i = 0; i < upperBound; i++) {
        if ([input[i] integerValue] > [maxElement integerValue]) {
            maxElement = input[i];
            maxElementIndex = i;
        }
    }
    
    if (maxElementIndex != upperBound - 1) {
        [input exchangeObjectAtIndex:maxElementIndex withObjectAtIndex:upperBound - 1];
    }
    [self heapSort:input upperBound:upperBound - 1];
}

//*******************************************************//

- (BOOL)binarySearch:(NSArray *)input element:(NSNumber *)element {
    NSMutableArray *mutableInput = [input mutableCopy];
    [self dutchQuickSort:mutableInput lower:0 higher:[mutableInput count] - 1];
    BOOL found = NO;
    NSInteger leftBoundary = 0;
    NSInteger rightBoundary = [mutableInput count];
    while (leftBoundary < rightBoundary && !found) {
        NSInteger middleIndex = (rightBoundary - leftBoundary) / 2 + leftBoundary;
        NSNumber *middleElement = mutableInput[middleIndex];
        if ([middleElement integerValue] > [element integerValue]) {
            rightBoundary = middleIndex - 1;
        }
        else if ([middleElement integerValue] < [element integerValue]) {
            leftBoundary = middleIndex + 1;
        }
        else {
            found = YES;
        }
    }
    return found;
}

//*******************************************************//

- (Graph *)constructAlhabetGraph {
    Graph *graph = [Graph new];
    GraphVertex *a = [graph createVertex:@"A"];
    GraphVertex *b = [graph createVertex:@"B"];
    GraphVertex *c = [graph createVertex:@"C"];
    GraphVertex *d = [graph createVertex:@"D"];
    GraphVertex *e = [graph createVertex:@"E"];
    GraphVertex *f = [graph createVertex:@"F"];
    GraphVertex *g = [graph createVertex:@"G"];
    GraphVertex *h = [graph createVertex:@"H"];
    
    [graph addDirectedEdgeFrom:a to:b weight:@0];
    [graph addDirectedEdgeFrom:a to:c weight:@0];
    [graph addDirectedEdgeFrom:b to:d weight:@0];
    [graph addDirectedEdgeFrom:b to:e weight:@0];
    [graph addDirectedEdgeFrom:c to:f weight:@0];
    [graph addDirectedEdgeFrom:c to:g weight:@0];
    [graph addDirectedEdgeFrom:e to:h weight:@0];
    [graph addDirectedEdgeFrom:e to:f weight:@0];
    [graph addDirectedEdgeFrom:f to:g weight:@0];
    
    return graph;
}

//*******************************************************//

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray *input = @[@10, @(-1), @3, @9, @2, @8, @27, @8, @5, @1, @3, @0, @26];
    //    NSArray *input = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1];
    
    NSArray *insertionResult = [self insertionSort:input];
    NSLog(@"Insertion sort %@", insertionResult);
    
    NSArray *mergeResult = [self mergeSort:input];
    NSLog(@"Merge sort %@", mergeResult);
    
    NSArray *bucketResult = [self bucketSort:input];
    NSLog(@"Bucket sort %@", bucketResult);
    
    NSMutableArray *lomutosResult = [input mutableCopy];
    [self lomutosQuickSort:lomutosResult lower:0 higher:[lomutosResult count] - 1];
    NSLog(@"Lomuto quick sort %@", lomutosResult);
    
    NSMutableArray *hoaresResult = [input mutableCopy];
    [self hoaresQuickSort:hoaresResult lower:0 higher:[hoaresResult count] - 1];
    NSLog(@"Hoares quick sort %@", hoaresResult);
    
    NSMutableArray *dutchResult = [input mutableCopy];
    [self dutchQuickSort:dutchResult lower:0 higher:[dutchResult count] - 1];
    NSLog(@"Dutch quick sort %@", dutchResult);
    
    NSMutableArray *heapResult = [input mutableCopy];
    [self heapSort:heapResult upperBound:[heapResult count]];
    NSLog(@"Heap sort %@", heapResult);
    
    NSLog(@"Binary search %d", [self binarySearch:input element:@(-1)]);
    
    Graph *alphabetGraph1 = [self constructAlhabetGraph];
    [alphabetGraph1 bfsFromSource:alphabetGraph1.sourceVertex];
    
    Graph *alphabetGraph2 = [self constructAlhabetGraph];
    [alphabetGraph2 dfsFromSource:alphabetGraph2.sourceVertex];
    
    return YES;
}


@end
