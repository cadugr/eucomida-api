package com.eucomida.core.openapi;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    private static final String DESCRIPTION = "REST APIs of the eucomida project. All endpoints are protected. " +
            "If you have any questions about how to access them, please contact the project's development team.";

    @Bean
    public OpenAPI springDocsOpenApi() {
        return new OpenAPI().info(new Info().title("API Documentation")
                .description(DESCRIPTION).version("1.0"));
    }
}
