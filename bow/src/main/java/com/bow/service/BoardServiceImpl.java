package com.bow.service;

import java.io.File;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.bow.controller.BoardController;
import com.bow.dao.BoardDAO;
import com.bow.domain.BoardVO;
import com.bow.domain.Criteria;
import com.bow.domain.FileVO;
import com.bow.domain.SearchCriteria;
import com.bow.util.FileUtils;

@Service
public class BoardServiceImpl implements BoardService {
	private static final Logger log = LoggerFactory.getLogger(BoardServiceImpl.class);

	
	
	@Inject
	private BoardDAO dao;
	
	@Override
	public List<BoardVO> list(SearchCriteria scri) throws Exception {
		return dao.list(scri);
	}
	@Override
	public List<BoardVO> searchlist(SearchCriteria scri) throws Exception {
		return dao.searchlist(scri);
	}
	@Override
	public List<BoardVO> list() throws Exception {
		return dao.list();
	}

	@Override
	public int listCount(SearchCriteria scri) throws Exception {
		return dao.listCount(scri);
	}
	//글쓰기
	@Override
	public int write(BoardVO vo, MultipartHttpServletRequest req) throws Exception {
		 
		 String path = "C:/hellopt_file/";

			String upload_files="";
			String upload_names="";
			
			//파일 받아오기
			List<MultipartFile> file_list = req.getFiles("files");
			
			for (MultipartFile mf : file_list) {
				if(!mf.getOriginalFilename().equals("")) {
					
				String originalName = mf.getOriginalFilename();
				
				//난수 설정
				UUID uuid = UUID.randomUUID();
				
				String file_name = uuid.toString()+"_"+originalName;
				
				mf.transferTo(new File(path+file_name));
				
				upload_files+= file_name+"*";
				upload_names+= originalName+"*";			
				};
			}
			vo.setB_files(upload_files);
			vo.setB_file_names(upload_names);
			
			return dao.write(vo);
		 }
	
	//글 상세보기
	@Override
	public BoardVO view(int bno) throws Exception {
		dao.viewCnt(bno);
		dao.getFileInfo(bno);
		return dao.view(bno);
	}
	//글 수정하기
	@Override
	public void modify(BoardVO vo, MultipartHttpServletRequest req) throws Exception {
		String path = "C:/hellopt_file/";
		
		String ori_files[] = req.getParameterValues("ori_files");
		String ori_file_names[] = req.getParameterValues("ori_file_names");
		
		String upload_files="";
		String upload_names="";
		
		if(ori_files!=null||ori_file_names!=null) {
			for (int i = 0; i < ori_file_names.length; i++) {
				upload_files+=ori_files[i]+"*";
				upload_names+=ori_file_names[i]+"*";
			}
		}
		
		//파일 받아오기
		List<MultipartFile> file_list = req.getFiles("files");
		
		for (MultipartFile mf : file_list) {
			if(!mf.getOriginalFilename().equals("")) {
				
			String originalName = mf.getOriginalFilename();
			
			//난수 설정
			UUID uuid = UUID.randomUUID();
			
			String file_name = uuid.toString()+"_"+originalName;
			
			mf.transferTo(new File(path+file_name));
			
			upload_files+= file_name+"*";
			upload_names+= originalName+"*";
			
			System.out.println(originalName);
			
			};
		}
		vo.setB_files(upload_files);
		vo.setB_file_names(upload_names);
		
		dao.modify(vo);
		
	}

	@Override
	public void isdelete(int bno) throws Exception {
		
		dao.isdelete(bno);
	}
	@Override
	public void delete(int bno) throws Exception {
		
		dao.delete(bno);
	}
	//답변등록
	@Override
	public int reWrite(BoardVO vo, MultipartHttpServletRequest req) throws Exception {
		 String path = "C:/hellopt_file/";

			String upload_files="";
			String upload_names="";
			
			//파일 받아오기
			List<MultipartFile> file_list = req.getFiles("files");
			
			for (MultipartFile mf : file_list) {
				if(!mf.getOriginalFilename().equals("")) {
					
				String originalName = mf.getOriginalFilename();
				
				//난수 설정
				UUID uuid = UUID.randomUUID();
				
				String file_name = uuid.toString()+"_"+originalName;
				
				mf.transferTo(new File(path+file_name));
				
				upload_files+= file_name+"*";
				upload_names+= originalName+"*";			
				};
			}
			vo.setB_files(upload_files);
			vo.setB_file_names(upload_names);
			
		return dao.reWrite(vo);
	}
	//등록전 요소 업데이트
	@Override
	public int stepup(HttpServletRequest request) throws Exception {
		BoardVO vo = new BoardVO();
		vo.setRef(Integer.parseInt(request.getParameter("ref")));
		vo.setStep(Integer.parseInt(request.getParameter("step")));
		return dao.updateStep(vo);
	}

	@Override
	public int refCount(int ref) throws Exception {
		
		return dao.refCount(ref);
	}
	//파일업로드
	@Override
	public void insertFile(String oname, String sname, long fsize, int bno) throws Exception {
		HashMap<String, Object> hmp = new HashMap<String, Object>();
		hmp.put("oname", oname);
		hmp.put("sname", sname);
		hmp.put("fsize", fsize);
		hmp.put("bno", bno);
		System.out.println(hmp);
		dao.insertFile(hmp);
	}


	
	@Override
	public void updateFile(BoardVO vo, MultipartHttpServletRequest req) throws Exception {
		//저장경로

	}
	
	@Override
	public void deleteFile(int fno) throws Exception {
		dao.deleteFile(fno);
	}

	@Override
	public List<FileVO> getFileList(int bno) throws Exception {
		
		return dao.getFileList(bno);
	}

	@Override
	public List<FileVO>getFileInfo(int bno) throws Exception {
		return dao.getFileInfo(bno);
	}
	//파일삭제여부바꿔주기y로
	@Override
	public void ydelgbFile(int bno) throws Exception {
		dao.ydelgbFiel(bno);
		
	}
	//파일삭제여부바꿔주기n으로
	@Override
	public void ndelgbFile(int fno) throws Exception {
		dao.ydelgbFiel(fno);
		
	}
	

	



}
