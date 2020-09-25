package com.bow.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.activation.CommandMap;
import javax.inject.Inject;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bow.domain.BoardVO;
import com.bow.domain.Criteria;
import com.bow.domain.FileVO;
import com.bow.domain.PageMaker;
import com.bow.domain.ReplyVO;
import com.bow.domain.SearchCriteria;
import com.bow.service.BoardService;
import com.bow.service.ReplyService;
import com.google.gson.Gson;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Inject
	BoardService service;
	
	@Inject
	ReplyService repService;

	//게시물 목록
	@RequestMapping(value="/list", method = RequestMethod.GET)
	public void getList(BoardVO vo, Model model, @ModelAttribute("scri") SearchCriteria scri) throws Exception {
		System.out.println("vo:"+vo);
		//1.커맨드 객체로 Criteria를 매개변수로 넣어줘, 넘어오는 page와 perPageNum정보를 받습니다.
		//2.해당 cri를 이용해서 service-dao-mapper순으로 접근하면서 db처리를 해 cri 전달된 
		//현재 페이지 정보를 기준으로 BoardVO객체를 담은 ArrayList가 반환될 것이다.
		model.addAttribute("list", service.list(scri));//게시판의 글 리스트
		PageMaker pageMaker = new PageMaker();
		System.out.println("list:" + service.list(scri));
		//3.이제 view페이지에서 페이징 처리를 위해 사용할 PageMaker객체를 생성하고 
		/*
		 * 페이지에서 3을 누르면 컨트롤러로 숫자가 가서 페이지 메이커 객체에 pageMaker.set Cri(scri)로 scri를 주입한다
		 * scri는 cri를 상속받으니까 거기에있는 Page필드에 값이 담긴다? 페이지 번호를 알고싶다면 searchCriterria객체의
		 * getPage메소드를 호출하면 된다...
		 */
		//pageMaker 객체에 scri객체를 주입해 총 게시글수와 현재페이지, 페이지당 게시글 수의 값을 가져옴.
		pageMaker.setCri(scri);
		pageMaker.setTotalCount(service.listCount(scri));
		//페이지 메이커의 setTotalCount메소드가 호출이 되면서 페이징에 필요한 데이터가 생성됩니다.
		System.out.println("setTotalcount :"+ pageMaker.getTotalCount());
		System.out.println("괄호안에" + service.listCount(scri));
		model.addAttribute("pageMaker", pageMaker);
		model.addAttribute("scri", scri);
		//4.화면에 게시글을 뿌려주기 위해서 model.addAttribute를 통해 모델객체에 저장을 해준다
		//게시판 하단의 페이징 관련, 이전페이지, 페이지링크, 다음페이지
		
	}
	
	
	//글 상세 보기
	@RequestMapping(value="/view", method=RequestMethod.GET)
	public void getView(@RequestParam("bno")int bno, Model model, 
			@ModelAttribute("scri")SearchCriteria scri) throws Exception{
		System.out.println("게시물조회");
		
		BoardVO vo = service.view(bno);
		model.addAttribute("view", vo);
		System.out.println("게시물조회vo:"+vo);

		List<ReplyVO> repList = repService.readReply(bno);
		model.addAttribute("repList", repList);
		int count = repService.countReply(bno);
		model.addAttribute("replycount", count);
		System.out.println("댓글목록:"+ repList);
		
		
		List<FileVO> fvo = service.getFileInfo(bno);
		System.out.println("fvo:"+fvo);
		model.addAttribute("fvoinfo", fvo);
	}
	//게시물 작성 화면
		@RequestMapping(value="/write", method = RequestMethod.GET)
		public void getWrite()throws Exception{
			
		}
		//게시물 작성 처리
		@RequestMapping(value = "/write")
		public String postWrite(@Valid BoardVO vo,FileVO fvo,
				MultipartHttpServletRequest req ,Model model) throws Exception{
			logger.info("글작성");
			System.out.println("글작성vo:"+ vo);
			service.write(vo, req);
			return "redirect:/board/list";
		}
	
	//게시물 수정폼
	@RequestMapping(value="/modifyForm", method=RequestMethod.GET)
	public void getModify(@RequestParam("bno")int bno, Model model
						, @ModelAttribute("scri") SearchCriteria scri) throws Exception{
			System.out.println("오긴하나수정폼");
			BoardVO vo = service.view(bno);
			model.addAttribute("view", vo);
			model.addAttribute("scri", scri);
			
			List<FileVO> fvo = service.getFileInfo(bno);
			System.out.println("수정폼fvo:"+fvo);
			model.addAttribute("fvoinfo", fvo);
			
			
	}
	//게시물 수정처리
	@RequestMapping(value= "/modify", method = RequestMethod.POST)
	public String postModify(@Valid BoardVO vo, FileVO fvo, MultipartHttpServletRequest req, RedirectAttributes rttr ,
							Map<String, Object> map, Model model, @ModelAttribute("scri") SearchCriteria scri) throws Exception{
		
		int bno= vo.getBno();
		
		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		String ori_files[]= req.getParameterValues("ori_files");
		String ori_file_names[]=req.getParameterValues("ori_file_names");
		
		String cur_page = req.getParameter("cur_page");
		service.modify(vo, req);
		
        
		return "redirect:/board/view?bno=" + vo.getBno();
	}
	
	//게시물 삭제
	@RequestMapping(value="/delete", method=RequestMethod.GET)
	public String getDelete(@RequestParam("bno")int bno, RedirectAttributes rttr ,BoardVO vo,  
							@ModelAttribute("scri") SearchCriteria scri) throws Exception{
		int ref = vo.getRef();
		int refCount = service.refCount(ref);
		if(refCount >1) {
			service.isdelete(bno);

		}else {
			service.delete(bno);
		}
		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		return "redirect:/board/list";
	}
	//게시물 삭제
	@RequestMapping(value="/isdelete", method=RequestMethod.GET)
	public String isDelete(@RequestParam("bno")int bno, RedirectAttributes rttr ,BoardVO vo,  
			@ModelAttribute("scri") SearchCriteria scri) throws Exception{
		service.delete(bno);
		
		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		return "redirect:/board/list";
		
	}
	//답글 페이지
	@RequestMapping(value="/re", method = RequestMethod.GET)
	public String getReWrite(@RequestParam("bno")int bno, Model model, 
			 @ModelAttribute("scri") SearchCriteria scri)throws Exception{
		
		BoardVO vo = service.view(bno);
		model.addAttribute("view", vo);
		model.addAttribute("scri", scri);
		
		return "/board/writeRe";
	}
	//답글 처리
	@RequestMapping(value="/re", method=RequestMethod.POST)
	public String postReWrite(@Valid BoardVO vo, MultipartHttpServletRequest req, BindingResult binding, Errors errors ,Model model)throws Exception{
		 if(errors.hasErrors()) {
			   logger.info("postReWrite errors..");
			  }  
		service.stepup(req); 
		service.reWrite(vo, req);
		
		
		return "redirect:/board/list";
	}
	
	  //댓글 목록 (@RestController json방식으로 처리 : 데이터를 리턴)
  
	  @RequestMapping("listJson")
	  @ResponseBody//리턴 데이터를 json으로 변환(생략가능) public List<ReplyVO>
	  List<ReplyVO> listJason(@RequestParam int bno, Model model) throws Exception{ 
		  List<ReplyVO>list = repService.readReply(bno);
		  
		  model.addAttribute("list", list); 
		  
		  return list;
	  }
		  
		  //댓글작성
		  
		  @RequestMapping(value="/replyWrite", method=RequestMethod.POST) public String
		  replyWrite(ReplyVO vo, SearchCriteria scri, RedirectAttributes rttr) throws Exception
		  { 
			  System.out.println("댓작성컨트롤러"); 
			  repService.writeReply(vo);
		  
		  rttr.addAttribute("bno", vo.getBno()); 
		  rttr.addAttribute("page",scri.getPage()); 
		  rttr.addAttribute("perPageNum", scri.getPerPageNum());
		  rttr.addAttribute("searchType", scri.getSearchType());
		  rttr.addAttribute("keyword", scri.getKeyword());
		  return "redirect:/board/view"; 
	  }
		
			//파일다운로드
			@RequestMapping(value="/download")
			public void download(@RequestParam Map<String, String> paramMap, HttpServletResponse response, HttpServletRequest req) throws Exception{
				System.out.println("다운로드 오긴하나");
				 
		/*
		 * String path = paramMap.get("filePath"); //full경로
		 * String fileName = paramMap.get("fileName"); //파일명
		 */		
				String path = paramMap.get("filePath"); //full경로
				String fileName = paramMap.get("fileName"); //파일명
				
				File file = new File(path);
				
				FileInputStream fis = null;
			    ServletOutputStream out = null;
				
			    try{
			    	String downName = null;
			    	String browser= req.getHeader("User-Agent");
					//파일 인코딩	
			    	if(browser.contains("MSIE")|| browser.contains("Trident")|| browser.contains("Chrome")) {
			    		downName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+","%20"); 
			    	}else {
			    		downName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			    	}
						response.setHeader("Content-Disposition", "attachment); filename=\""+ downName + "\";");
						response.setHeader("Content-trnasfer-Encoding", "binary");
						response.setContentType("application/octer-stream");
						//response.setHeader("Pragma","no-cache;");
						//response.setHeader("Expires","-1;");
						
						fis = new FileInputStream(file);
						out= response.getOutputStream();
						  
					int readCount = 0;
					byte[] buffer = new byte[1024];
					
					while((readCount = fis.read(buffer, 0, buffer.length)) != -1) {
						out.write(buffer, 0, readCount);
					}
					out.flush();//출력
					
				}catch (Exception e) {
					e.printStackTrace();
				}finally {
					if(out != null) {
						try{
							out.close();
						}catch(IOException e){
							e.printStackTrace();
						}
					}
					if(fis != null) {
						try {
							fis.close();
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
			}  
	//엑셀 출력
	  @RequestMapping(value="/excel")
	  public void excel(Model model, @ModelAttribute("scri") SearchCriteria scri,
			  	HttpServletResponse resp, PageMaker pagemaker) throws Exception{
		  //게시판 목록 조회
		  List<BoardVO> list = service.list(scri);
		  //게시물 전체 목록조회
		  List<BoardVO> listall = service.list();
		  pagemaker.setCri(scri);
		  pagemaker.setTotalCount(service.listCount(scri));
		  //워크북 생성
		  Workbook wb = new HSSFWorkbook();
		  Sheet sheet = wb.createSheet("게시판");
		  Row row = null;
		  Cell cell = null;
		  int rowNo = 0;
		  
		  //시트 열 너비 설정
	        sheet.setColumnWidth(0, 1500);
	        sheet.setColumnWidth(1, 20000);
	        sheet.setColumnWidth(2, 5000);
	        sheet.setColumnWidth(3, 4000);
	        sheet.setColumnWidth(4, 3000);
		  
		  //테이블 헤더용 스타일
		  CellStyle headStyle = wb.createCellStyle();
		  
		  //가는 경계선을 가집니다.
		  headStyle.setBorderTop(BorderStyle.THIN);
		  headStyle.setBorderBottom(BorderStyle.THIN);
		  headStyle.setBorderLeft(BorderStyle.THIN);
		  headStyle.setBorderRight(BorderStyle.THIN);
		  
		  //배경색은 노란색입니다.
		  headStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
		  headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		  
		  //데이터는 가운데 정렬
		  headStyle.setAlignment(HorizontalAlignment.CENTER);
		  
		  //데이터용 경계 스타일 테두리만 지정
		  CellStyle bodyStyle = wb.createCellStyle();
		  bodyStyle.setBorderTop(BorderStyle.THIN);
		  bodyStyle.setBorderBottom(BorderStyle.THIN);
		  bodyStyle.setBorderLeft(BorderStyle.THIN);
		  bodyStyle.setBorderRight(BorderStyle.THIN);
		  
		  // 헤더 생성
		    row = sheet.createRow(rowNo++);
		    cell = row.createCell(0);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("번호");
		    cell = row.createCell(1);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("제목");
		    cell = row.createCell(2);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("작성자");
		    cell = row.createCell(3);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("작성일");
		    cell = row.createCell(4);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("조회수");
		    
		    
		    // 데이터 부분 생성
			int num = service.listCount(scri)-((scri.getPage()-1)*10);//총게시물수
		/*
		 * Date date = row.getCell(3).getDateCellValue(); 
		 * String regDate = new SimpleDateFormat("yy.MM.dd HH:mm").format(date); 
		 * cell.setCellType(HSSFCell.CELL_TYPE_STRING ); 
		 * String value = cell.getStringCellValue();
		 */
		//날짜포멧
			SimpleDateFormat format = new SimpleDateFormat("yy.MM.dd HH:mm");
		    System.out.println("num"+num);

		    
		    for(BoardVO vo : list) {
		    	//행생성
		    	row = sheet.createRow(rowNo++);

		    	//글번호
		        cell = row.createCell(0);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(num--);
		        
		        //제목
		        cell = row.createCell(1);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(vo.getTitle());
		        
		        //작성자
		        cell = row.createCell(2);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(vo.getWriter());
		        
		        //작성일
		        cell = row.createCell(3);
		        cell.setCellStyle(bodyStyle);
		        String date= format.format(vo.getRegDate());
		        cell.setCellValue(date);
		        //조회수
		        cell = row.createCell(4);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(vo.getViewCnt());
		        
		        System.out.println("날짜"+vo.getRegDate());
		    }
		    // 컨텐츠 타입과 파일명 지정
		    resp.setContentType("ms-vnd/excel");
		    resp.setHeader("Content-Disposition", "attachment;filename=boardexcel.xls");
		    // 엑셀 출력
		    wb.write(resp.getOutputStream());
		    wb.close();
	  }
	//엑셀 출력
	  @RequestMapping(value="/excelall")
	  public void excelall(Model model, @ModelAttribute("scri") SearchCriteria scri,
			  	HttpServletResponse resp, PageMaker pagemaker) throws Exception{

		  //게시물 전체 목록조회
		  List<BoardVO> listall = service.searchlist(scri);
		  //워크북 생성
		  Workbook wb = new HSSFWorkbook();
		  Sheet sheet = wb.createSheet("게시판");
		  Row row = null;
		  Cell cell = null;
		  int rowNo = 0;
		  
		  //시트 열 너비 설정
	        sheet.setColumnWidth(0, 1500);
	        sheet.setColumnWidth(1, 20000);
	        sheet.setColumnWidth(2, 5000);
	        sheet.setColumnWidth(3, 4000);
	        sheet.setColumnWidth(4, 3000);
		  
		  
		  //테이블 헤더용 스타일
		  CellStyle headStyle = wb.createCellStyle();

		  //가는 경계선을 가집니다.
		  headStyle.setBorderTop(BorderStyle.THIN);
		  headStyle.setBorderBottom(BorderStyle.THIN);
		  headStyle.setBorderLeft(BorderStyle.THIN);
		  headStyle.setBorderRight(BorderStyle.THIN);
		  
		  //배경색은 노란색입니다.
		  headStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
		  headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		  
		  //데이터는 가운데 정렬
		  headStyle.setAlignment(HorizontalAlignment.CENTER);
		  
		  //데이터용 경계 스타일 테두리만 지정
		  CellStyle bodyStyle = wb.createCellStyle();
		  bodyStyle.setBorderTop(BorderStyle.THIN);
		  bodyStyle.setBorderBottom(BorderStyle.THIN);
		  bodyStyle.setBorderLeft(BorderStyle.THIN);
		  bodyStyle.setBorderRight(BorderStyle.THIN);
		  // 헤더 생성
		    row = sheet.createRow(rowNo++);
		    cell = row.createCell(0);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("번호");
		    cell = row.createCell(1);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("제목");
		    cell = row.createCell(2);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("작성자");
		    cell = row.createCell(3);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("작성일");
		    cell = row.createCell(4);
		    cell.setCellStyle(headStyle);
		    cell.setCellValue("조회수");
		    
		    
		    // 데이터 부분 생성
			int num = service.listCount(scri);
			SimpleDateFormat format = new SimpleDateFormat("yy.MM.dd HH:mm");
		    System.out.println("num"+num);
		    for(BoardVO vo : listall) {
		        row = sheet.createRow(rowNo++);
		        cell = row.createCell(0);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(num--);
		        cell = row.createCell(1);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(vo.getTitle());
		        cell = row.createCell(2);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(vo.getWriter());
		        cell = row.createCell(3);
		        cell.setCellStyle(bodyStyle);
		        String date= format.format(vo.getRegDate());
		        cell.setCellValue(date);
		        cell = row.createCell(4);
		        cell.setCellStyle(bodyStyle);
		        cell.setCellValue(vo.getViewCnt());
		        
		        System.out.println("날짜"+vo.getRegDate());
		    }
		    // 컨텐츠 타입과 파일명 지정
		    resp.setContentType("ms-vnd/excel");
		    resp.setHeader("Content-Disposition", "attachment;filename=boardexcel.xls");
		    // 엑셀 출력
		    wb.write(resp.getOutputStream());
		    wb.close();
	  }
	  
	 /* //댓글수정
	 * 
	 * @RequestMapping(value="/replyUpdateView", method= RequestMethod.GET) public
	 * String replyUpdateView(ReplyVO vo, SearchCriteria scri, Model model)throws
	 * Exception{
	 * 
	 * model.addAttribute("replyUpdate", repService.selectReply(vo.getRno()));
	 * model.addAttribute("scri", scri);
	 * 
	 * return "board/replyUpdateView";
	 * 
	 * }
	 * 
	 * //댓글수정 Post
	 * 
	 * @RequestMapping(value="replyUpdate", method= RequestMethod.POST) public
	 * String replyUpdate(ReplyVO vo, SearchCriteria scri, RedirectAttributes
	 * rttr)throws Exception{ System.out.println("댓수정"); repService.updateReply(vo);
	 * 
	 * rttr.addAttribute("bno", vo.getBno()); rttr.addAttribute("page",
	 * scri.getPage()); rttr.addAttribute("perPageNum", scri.getPerPageNum());
	 * rttr.addAttribute("searchType", scri.getSearchType());
	 * rttr.addAttribute("keyword", scri.getKeyword());
	 * 
	 * return "redirect:/board/view"; } //댓글삭제Get
	 * 
	 * @RequestMapping(value="replyDeleteView", method = RequestMethod.GET) public
	 * String replyDeleteView(ReplyVO vo, Model model, SearchCriteria scri,
	 * RedirectAttributes rttr)throws Exception{ System.out.println("댓삭뷰");
	 * 
	 * model.addAttribute("replyDelete", repService.selectReply(vo.getRno()));
	 * model.addAttribute("scri", scri);
	 * 
	 * return "board/replyDeleteView"; } //댓글삭제 Post
	 * 
	 * @RequestMapping(value="replyDelete", method = RequestMethod.POST) public
	 * String replyDelete(ReplyVO vo, SearchCriteria scri, RedirectAttributes
	 * rttr)throws Exception{ System.out.println("댓삭"); repService.deleteReply(vo);
	 * 
	 * rttr.addAttribute("bno", vo.getBno()); rttr.addAttribute("page",
	 * scri.getPage()); rttr.addAttribute("perPageNum", scri.getPerPageNum());
	 * rttr.addAttribute("searchType", scri.getSearchType());
	 * rttr.addAttribute("keyword", scri.getKeyword());
	 * 
	 * return "redirect:/board/view"; }
	 */

}
