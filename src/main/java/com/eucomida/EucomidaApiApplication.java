package com.eucomida;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootApplication
public class EucomidaApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(EucomidaApiApplication.class, args);
	}

}
