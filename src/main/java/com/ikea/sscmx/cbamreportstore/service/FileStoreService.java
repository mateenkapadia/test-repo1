package com.ikea.sscmx.cbamreportstore.service;

import java.io.IOException;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

public interface FileStoreService {
	public String uploadFileToAzure(MultipartFile file, @RequestParam String supplierId, String quarter)  throws IOException;
	public String downloadFileFromAzure ( @RequestParam String supplierId, String quarter);
}
