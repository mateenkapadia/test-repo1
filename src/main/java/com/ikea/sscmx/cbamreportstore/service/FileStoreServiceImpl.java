package com.ikea.sscmx.cbamreportstore.service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.models.BlobItem;

@Service
public class FileStoreServiceImpl implements FileStoreService {

	@Autowired
	AzureClientService azureService;
	
	public String uploadFileToAzure(MultipartFile file, String supplierId, String quarter) throws IOException {
        MultipartFile newFile = getFile(file, supplierId);
        
        BlobServiceClient blobServiceClient = azureService.getBlobContainerClient();        
        BlobContainerClient blobContainerClient = blobServiceClient.createBlobContainerIfNotExists(supplierId);
        
        InputStream inputStream = newFile.getInputStream();
        BlobClient blobClient = blobContainerClient.getBlobClient(quarter+"/"+newFile.getName());
        blobClient.upload(inputStream, true);

		return newFile.getName()+" file uploaded successfully";
	}

	@Override
	public String downloadFileFromAzure(String supplierId, String quarter){
		BlobItem b1 = null;
		String msg = "";
		String filename = "";
		
		BlobServiceClient blobServiceClient = azureService.getBlobContainerClient();
        BlobContainerClient blobContainerClient = blobServiceClient.getBlobContainerClient(supplierId);		 
        Optional<BlobItem> blob1  =  blobContainerClient.listBlobs().stream().filter(b->b.getName().contains(supplierId)).max(Comparator.comparing(blob->blob.getProperties().getLastModified()));//filter(blob -> blob.getProperties().getLastModified());
        b1 = blob1.get(); 
        
        System.out.println(b1.getProperties().getLastModified());
        BlobClient client = blobContainerClient.getBlobClient(b1.getName()); 
        filename =( b1.getName().split(quarter+"/"))[1];
        File file = new File(filename);
        if(!file.exists()) {
        	client.downloadToFile(filename);
        	msg = filename + " downloaded successfully.";
        }else
        	msg = filename + " already exists.";
        return msg;
	}
	
	
	
	private MultipartFile getFile(MultipartFile file, String supplierId) throws IOException{
		MockMultipartFile newFile = null;
    	DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd_HH-mm-ss");
    	LocalDateTime localDate = LocalDateTime.now();
    	String date = dtf.format(localDate).toString(); 
    	String newFileName = date+"_"+supplierId+"_"+file.getOriginalFilename();
		newFile = new  MockMultipartFile(newFileName, file.getBytes());
		System.out.println(newFile.getName() + "===========================" +newFile.getOriginalFilename());		
		return newFile;		
	}
}
