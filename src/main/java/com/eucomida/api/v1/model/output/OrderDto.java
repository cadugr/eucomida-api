package com.eucomida.api.v1.model.output;

import com.eucomida.domain.model.OrderStatus;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderDto {

    private Long id;
    private BigDecimal subtotal;
    private BigDecimal freightRate;
    private BigDecimal totalValue;
    private OrderStatus status;

}
