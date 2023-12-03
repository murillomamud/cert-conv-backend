package com.mamud.certificateconversion

import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.CorsRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer

@Configuration
class CorsConfig : WebMvcConfigurer {
    override fun addCorsMappings(registry: CorsRegistry) {
        registry.addMapping("/convert")
            .allowedOrigins("https://pfxtopem.mamud.cloud/")
            .allowedMethods("POST")
            .allowCredentials(true)
            .allowedHeaders("*")
    }
}
