//
//  Graph.h
//  SortAlgorithms
//
//  Created by Anton Domashnev on 19/12/2016.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

@import Foundation;
@class GraphEdge;

@interface GraphVertex : NSObject <NSCopying>

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) BOOL visited;

@end

@interface GraphEdge : NSObject

@property (nonatomic, strong) GraphVertex *from;
@property (nonatomic, strong) GraphVertex *to;
@property (nonatomic, strong) NSNumber *weight;

@end

@interface Graph : NSObject

@property (nonatomic, strong) NSMutableDictionary<GraphVertex *, NSMutableArray<GraphEdge *> *> *adjacencyList;
@property (nonatomic, strong, readonly) GraphVertex *sourceVertex;

- (GraphVertex *)createVertex:(NSString *)value;
- (void)addDirectedEdgeFrom:(GraphVertex *)from to:(GraphVertex *)to weight:(NSNumber *)weight;

- (void)bfsFromSource:(GraphVertex *)vertex;
- (void)dfsFromSource:(GraphVertex *)vertex;

@end
