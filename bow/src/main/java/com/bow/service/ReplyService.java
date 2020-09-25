package com.bow.service;

import java.util.List;

import com.bow.domain.ReplyVO;

public interface ReplyService {

	public List<ReplyVO> readReply(int bno) throws Exception; //댓글조회
	
	public void writeReply(ReplyVO vo) throws Exception; //댓글작성
	public void updateReply(ReplyVO vo) throws Exception; //댓글작성
	public void deleteReply(ReplyVO vo) throws Exception; //댓글작성
	public ReplyVO selectReply(int rno) throws Exception; //댓글작성
	public int countReply(int bno) throws Exception; // 댓글총 갯수조회
}
