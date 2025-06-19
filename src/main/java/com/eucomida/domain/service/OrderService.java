package com.eucomida.domain.service;

import com.eucomida.domain.exception.EntityNotFoundException;
import com.eucomida.domain.model.Order;
import com.eucomida.domain.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class OrderService {

    private final OrderRepository orderRepository;

    public Order save(Order order) {
        return orderRepository.save(order);
    }

    public String getOrderStatus(Long id) {
        return orderRepository.findById(id).orElseThrow(() ->
                new EntityNotFoundException(String.format("order with id %d not found.", id)))
                .getStatus().toString();
    }
}
