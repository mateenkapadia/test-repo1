package com.ikea.sscmx.cbamreportstore.config;

import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
	 @Bean
	    public GroupedOpenApi controllerApi() {
	        return GroupedOpenApi.builder()
	                .group("controller-api")
	                .packagesToScan("com.ikea.sscmx.cbamreportstore.contoller") // Specify the package to scan
	                .build();
	    }
}
