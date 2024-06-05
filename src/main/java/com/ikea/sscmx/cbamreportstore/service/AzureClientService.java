package com.ikea.sscmx.cbamreportstore.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;

@Service
public class AzureClientService {
	@Value("${azure.config.containername}")
	String containerName;
	
	@Value("${azure.config.DefaultEndpointsProtocol}")
	String defaultEndpointsProtocol;
	
	@Value("${azure.config.AccountName}")
	String accountName;
	
	@Value("${azure.config.AccountKey}")
	String accountKey;
	
	@Value("${azure.config.EndpointSuffix}")
	String endpointSuffix;
	
	@Bean
	protected BlobServiceClient getBlobContainerClient() {
		String connectionString = "";
        System.out.println(connectionString);
        BlobServiceClient blobServiceClient = new BlobServiceClientBuilder().connectionString(connectionString).buildClient();
        return blobServiceClient;        

	}
	
}
