package com.ikea.sscmx.cbamreportstore;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CbamReportStoreApplication {

	public static void main(String[] args) {
		System.setProperty("server.servlet.context-path","/cbamfilestore-service");
		SpringApplication.run(CbamReportStoreApplication.class, args);
	}

}
