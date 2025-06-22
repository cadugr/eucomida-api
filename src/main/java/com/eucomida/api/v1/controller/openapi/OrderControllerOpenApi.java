package com.eucomida.api.v1.controller.openapi;

import com.eucomida.api.v1.model.input.OrderCreateDto;
import com.eucomida.api.v1.model.output.OrderDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;

@Tag(name = "Orders")
public interface OrderControllerOpenApi {
    @Operation(summary = "Create a new order.")
    @ApiResponses({
            @ApiResponse(responseCode = "400", description = "Bad request", content = {@Content(schema = @Schema(implementation = ProblemDetail.class))}),
            @ApiResponse(responseCode = "403", description = "Access denied", content = {@Content(schema = @Schema(implementation = ProblemDetail.class))}),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = {@Content(schema = @Schema(implementation = ProblemDetail.class))}),
    })
    OrderDto createOrder(@RequestBody @Valid OrderCreateDto orderCreateDto);

    @Operation(summary = "Get status from a specific order.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Success", content = {@Content(schema = @Schema(implementation = String.class))}),
            @ApiResponse(responseCode = "403", description = "Access denied", content = {@Content(schema = @Schema(implementation = ProblemDetail.class))}),
            @ApiResponse(responseCode = "404", description = "Resource not found", content = {@Content(schema = @Schema(implementation = ProblemDetail.class))}),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = {@Content(schema = @Schema(implementation = ProblemDetail.class))}),
    })
    String getOrderStatus(@PathVariable Long orderId);
}
