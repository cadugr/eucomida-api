package com.eucomida.api.v1.controller;

import com.eucomida.api.assembler.Converter;
import com.eucomida.api.v1.controller.openapi.OrderControllerOpenApi;
import com.eucomida.api.v1.model.input.OrderCreateDto;
import com.eucomida.api.v1.model.output.OrderDto;
import com.eucomida.domain.model.Order;
import com.eucomida.domain.service.OrderService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/orders")
public class OrderController implements OrderControllerOpenApi {

    private final OrderService orderService;

    private final Converter<OrderCreateDto, Order> representation;

    private final Converter<Order, OrderDto> model;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public OrderDto createOrder(@RequestBody @Valid OrderCreateDto orderCreateDto) {
        Order order = representation.toModel(orderCreateDto, Order.class);
        return model.toRepresentation(orderService.save(order), OrderDto.class);
    }

    @GetMapping("{orderId}/status")
    public String getOrderStatus(@PathVariable Long orderId) {
        return orderService.getOrderStatus(orderId);
    }

}
