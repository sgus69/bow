package com.bow.dao;

import java.util.List;

import com.bow.domain.ReplyVO;

public interface ReplyDAO {
	public List<ReplyVO> readReply(int bno) throws Exception; //댓글조회
	public void writeReply(ReplyVO vo) throws Exception; //댓글작성
	public void updateReply(ReplyVO vo) throws Exception; //댓글수정
	public void deleteReply(ReplyVO vo) throws Exception; //댓글삭제
	public ReplyVO selectReply(int rno) throws Exception; //선택된 댓글조회
	public int countReply(int bno) throws Exception; // 댓글총 갯수조회
}
