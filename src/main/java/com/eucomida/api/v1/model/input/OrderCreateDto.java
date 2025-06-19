package com.eucomida.api.v1.model.input;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class OrderCreateDto {

    @NotNull
    private BigDecimal subtotal;
    @NotNull
    private BigDecimal freightRate;
    @NotNull
    private BigDecimal totalValue;

}
