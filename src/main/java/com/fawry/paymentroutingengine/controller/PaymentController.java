package com.fawry.paymentroutingengine.controller;

import com.fawry.payment.api.PaymentRoutingApi;
import com.fawry.payment.dto.*;
import org.springframework.http.ResponseEntity;

public class PaymentController implements PaymentRoutingApi {

    @Override
    public ResponseEntity<TransactionHistoryResponse> getBillerTransactions(String billerId) {
        return null;
    }

    @Override
    public ResponseEntity<RecommendResponse> recommendGateway(RecommendRequest recommendRequest) {
        return null;
    }

    @Override
    public ResponseEntity<SplitResponse> splitPayment(SplitRequest splitRequest) {
        return null;
    }
}
