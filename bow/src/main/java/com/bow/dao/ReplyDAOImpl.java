package com.bow.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.bow.domain.ReplyVO;

@Repository
public class ReplyDAOImpl implements ReplyDAO{
	
	@Inject
	private SqlSession sql;
	
	private static String namespace ="com.bow.mappers.reply";

	//댓글읽기
	@Override
	public List<ReplyVO> readReply(int bno) throws Exception {
		return sql.selectList(namespace + ".readReply", bno);
	}

	@Override
	public void writeReply(ReplyVO vo) throws Exception {
		sql.insert(namespace+".writeReply", vo);
	}

	@Override
	public void updateReply(ReplyVO vo) throws Exception {
		sql.update(namespace+".updateReply", vo);
	}

	@Override
	public void deleteReply(ReplyVO vo) throws Exception {
		sql.delete(namespace + ".deleteReply", vo);
		
	}

	@Override
	public ReplyVO selectReply(int rno) throws Exception {
		return sql.selectOne(namespace+".selectReply", rno);
	}

	@Override
	public int countReply(int bno) throws Exception {
		return sql.selectOne(namespace+".countReply", bno);
	}
	
}
