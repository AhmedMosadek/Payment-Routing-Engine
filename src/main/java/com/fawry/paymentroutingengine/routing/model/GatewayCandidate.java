package com.fawry.paymentroutingengine.routing.model;

public record GatewayCandidate(
        GatewayProfile gateway,
        double remainingQuota,
        double estimatedCommission,
        double score
) {
}