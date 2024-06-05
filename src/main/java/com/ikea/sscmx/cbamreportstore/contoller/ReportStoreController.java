package com.ikea.sscmx.cbamreportstore.contoller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ikea.sscmx.cbamreportstore.service.FileStoreService;

@RestController
@RequestMapping(path = "/api/filesstore")
public class ReportStoreController {
	@Autowired
	FileStoreService fileService;
	
    @PostMapping("/upload") 
    public ResponseEntity upload(@RequestParam MultipartFile file, @RequestParam String supplierId, @RequestParam String quarter) throws IOException {
    	ResponseEntity response = null;
        try {
	    	String result = fileService.uploadFileToAzure(file, supplierId, quarter);
	    	response = ResponseEntity.status(200).body(result);
        }catch(IOException e) {
        	 ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, "Exception occured During file upload");
		    pd.setTitle("File upload failed");
		    response = ResponseEntity.status(500).body(pd);
        }
        return response;
    }
    
    @GetMapping("download")
    public ResponseEntity downloadFileFromAzure(@RequestParam("supplierId") String supplierId, @RequestParam String quarter) {
    	ResponseEntity response = null;
		String result =  fileService.downloadFileFromAzure(supplierId, quarter);
		response = ResponseEntity.status(200).body(result);
    	return response;
	}
}
