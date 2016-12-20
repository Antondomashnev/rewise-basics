//
//  Graph.m
//  SortAlgorithms
//
//  Created by Anton Domashnev on 19/12/2016.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

#import "Graph.h"

@implementation GraphVertex

- (id)copyWithZone:(NSZone *)zone {
    GraphVertex *newVertex = [[self class] allocWithZone:zone];
    newVertex.value = [self.value copyWithZone:zone];
    return newVertex;
}

- (NSUInteger)hash {
    return [self.value hash];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[GraphVertex class]]) {
        return NO;
    }
    return [[(GraphVertex *)object value] isEqualToString:self.value];
}

@end

@implementation GraphEdge

@end

@interface Graph ()

@property (nonatomic, strong, readwrite) GraphVertex *sourceVertex;

@end

@implementation Graph

- (instancetype)init {
    self = [super init];
    if (self) {
        self.adjacencyList = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addDirectedEdgeFrom:(GraphVertex *)from to:(GraphVertex *)to weight:(NSNumber *)weight {
    NSParameterAssert(from);
    NSParameterAssert(to);
    NSParameterAssert(self.adjacencyList[from]);
    GraphEdge *edge = [GraphEdge new];
    edge.from = from;
    edge.to = to;
    edge.weight = weight;
    [self.adjacencyList[from] addObject:edge];
}

- (GraphVertex *)createVertex:(NSString *)value {
    GraphVertex *vertex = [GraphVertex new];
    vertex.value = value;
    
    if ([self.adjacencyList count] == 0) {
        self.sourceVertex = vertex;
    }
    else {
        NSParameterAssert(!self.adjacencyList[vertex]);
    }
    
    self.adjacencyList[vertex] = [NSMutableArray array];
    return vertex;
}

- (void)bfsFromSource:(GraphVertex *)vertex {
    GraphVertex *currentVisit = vertex;
    NSMutableArray *bfsQueue = [NSMutableArray arrayWithCapacity:[self.adjacencyList count]];
    [bfsQueue addObject:currentVisit];
    while ([bfsQueue count] > 0) {
        currentVisit = [bfsQueue firstObject];
        currentVisit.visited = YES;
        NSLog(@"BFS Visit %@", currentVisit.value);
        [bfsQueue removeObjectAtIndex:0];
        NSArray<GraphEdge *> *edges = self.adjacencyList[currentVisit];
        for (GraphEdge *edge in edges) {
            if (edge.to.visited) {
                continue;
            }
            [bfsQueue addObject:edge.to];
            edge.to.visited = YES;
        }
    }
}

- (void)dfsVisit:(GraphVertex *)vertex {
    if (vertex.visited) {
        return;
    }
    vertex.visited = YES;
    NSLog(@"DFS Visited %@", vertex.value);
    NSArray<GraphEdge *> *edges = self.adjacencyList[vertex];
    for (GraphEdge *edge in edges) {
        [self dfsVisit:edge.to];
    }
}

- (void)dfsFromSource:(GraphVertex *)vertex {
    [self dfsVisit:vertex];
}

@end
