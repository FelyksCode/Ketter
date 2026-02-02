package com.ketter.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Bean
    public ServletRegistrationBean<FhirRestfulServer> hapiFhirServletRegistration() {
        ServletRegistrationBean<FhirRestfulServer> registration = new ServletRegistrationBean<>(new FhirRestfulServer(), "/fhir/*");
        registration.setName("Ketter FHIR Server");
        return registration;
    }
}
