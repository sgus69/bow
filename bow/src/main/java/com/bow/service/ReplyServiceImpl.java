package com.bow.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.bow.dao.ReplyDAO;
import com.bow.domain.BoardVO;
import com.bow.domain.ReplyVO;
import com.bow.domain.SearchCriteria;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Inject
	private ReplyDAO dao;

	@Override
	public List<ReplyVO> readReply(int bno) throws Exception {
		return dao.readReply(bno);
	}

	@Override
	public void writeReply(ReplyVO vo) throws Exception {
		dao.writeReply(vo);
	}

	@Override
	public void updateReply(ReplyVO vo) throws Exception {
		dao.updateReply(vo);
	}

	@Override
	public void deleteReply(ReplyVO vo) throws Exception {
		dao.deleteReply(vo);
	}

	@Override
	public ReplyVO selectReply(int rno) throws Exception {
		return dao.selectReply(rno);
	}

	@Override
	public int countReply(int bno) throws Exception {
		return dao.countReply(bno);
	}
	
	


}
