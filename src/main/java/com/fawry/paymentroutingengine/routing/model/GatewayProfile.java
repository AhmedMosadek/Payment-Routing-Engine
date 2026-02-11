package com.fawry.paymentroutingengine.routing.model;

public record GatewayProfile(
        String code,
        double fixedCommission,
        double percentageCommission,
        double minTransactionAmount,
        double maxTransactionAmount,
        double defaultQuota,
        double processingTimeHours,
        boolean active
) {
    public double estimateCommission(double amount) {
        return 0d;
    }
}
