package com.bow.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bow.domain.BoardVO;
import com.bow.domain.Criteria;
import com.bow.domain.PageMaker;
import com.bow.domain.ReplyVO;
import com.bow.domain.SearchCriteria;
import com.bow.service.BoardService;
import com.bow.service.ReplyService;

@RestController
@RequestMapping("/reply/**")
public class replyController {
	
	private static final Logger logger = LoggerFactory.getLogger(replyController.class);
	
	@Inject
	BoardService service;
	
	@Inject
	ReplyService rService;

	
	@RequestMapping(value="/list", method=RequestMethod.POST)
	public List<ReplyVO> getReplyList(@RequestParam("bno")int bno, Model model) throws Exception{
		System.out.println("댓글리스트");
		int count = rService.countReply(bno);
		model.addAttribute("replycount", count);
		return rService.readReply(bno);
	}
	//댓글작성
	@RequestMapping(value="/insert")
	public void insertReply(@RequestBody ReplyVO vo, Model model) throws Exception{
		System.out.println("댓글에이작스찾아오냐"+vo);
		try {
			rService.writeReply(vo);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	//댓글 수정
		@RequestMapping(value="/update", method=RequestMethod.POST)
		public Map<String, Object>updateReply(@RequestBody ReplyVO vo)
						throws IllegalStateException, IOException{
			System.out.println("댓수정");
			System.out.println("cvo: "+ vo);
			Map<String, Object> result = new HashMap<String, Object>();
			System.out.println("result: "+ result);
			
			try {
				rService.updateReply(vo);;
				result.put("status","OK");
			} catch(Exception e) {
				e.printStackTrace();
				result.put("status", "False");
			}
			
			return result;
			
		}
		//댓글 삭제
		@RequestMapping(value="/delete", method=RequestMethod.POST)
		public void delete(@RequestBody ReplyVO vo,Model model)throws Exception{
			System.out.println("댓삭");
			System.out.println("vo"+vo);
			rService.deleteReply(vo);;
		}
}
