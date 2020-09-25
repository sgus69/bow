package com.bow.util;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.bow.domain.BoardVO;

@Component("fileUtils")
public class FileUtils {
	private static final String filePath = "C:/hellopt_file/";//파일이 저장될 위치
	
	public List<Map<String,Object>> parseInsertFileInfo(Map<String,Object> map, HttpServletRequest req) throws Exception{
        MultipartHttpServletRequest mulReq = (MultipartHttpServletRequest)req;
         
        String original_Name=null;
        String original_Extension=null;
        String stored_Name=null;
 
        MultipartFile mulFile = null;
        Iterator<String> iterator= mulReq.getFileNames();
         
        List<Map<String,Object>> fileList = new ArrayList<Map<String,Object>>();
        Map<String,Object> fileMap = null;
         
        String board_IDX = (String) map.get("bno").toString();
         
        File file = new File(filePath);
        if(file.exists()==false) {
            file.mkdirs();
        }
         
        while(iterator.hasNext()) {
            mulFile=mulReq.getFile(iterator.next());
             
            if(mulFile.isEmpty()==false) {
                original_Name=mulFile.getOriginalFilename();
                original_Extension=mulFile.getOriginalFilename().substring(original_Name.lastIndexOf("."));
                stored_Name=CommonUtils.getRandomString()+original_Extension;
                 
                file = new File(filePath+stored_Name);
                mulFile.transferTo(file);
                 
                fileMap = new HashMap<String,Object>();
                 
                fileMap.put("bno", board_IDX);
                fileMap.put("oname", original_Name);
                fileMap.put("sname", stored_Name);
                fileMap.put("fsize", mulFile.getSize());
                fileList.add(fileMap);
            }
        }
         
        return fileList;
    }
}